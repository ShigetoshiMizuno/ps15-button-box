"""
STL → STEP 変換スクリプト（FreeCAD 1.1 用）
使い方:
    "C:\\Users\\shige\\AppData\\Local\\Programs\\FreeCAD 1.1\\bin\\freecadcmd.exe" stl_to_step.py
"""

import sys
import os

try:
    import FreeCAD
    import Part
    import Mesh
    import MeshPart
except ImportError:
    print("ERROR: FreeCAD モジュールが見つかりません。freecadcmd.exe で実行してください。")
    sys.exit(1)

BASE_DIR = r"L:\home\prj\NongSoftLLC\projects\10_current\基板作成\押しボタンボックス"

files = [
    ("ps15_box_half.stl", "ps15_box_half.step"),
]

for stl_name, step_name in files:
    stl_path  = os.path.join(BASE_DIR, stl_name)
    step_path = os.path.join(BASE_DIR, step_name)

    print(f"\n--- {stl_name} → {step_name} ---")

    if not os.path.exists(stl_path):
        print(f"  SKIP: {stl_path} が見つかりません")
        continue

    doc = FreeCAD.newDocument("convert")

    Mesh.insert(stl_path, doc.Name)
    doc.recompute()

    mesh_feature = None
    for obj in doc.Objects:
        if obj.TypeId == "Mesh::Feature":
            mesh_feature = obj
            break

    if mesh_feature is None:
        print("  ERROR: メッシュの読み込みに失敗しました")
        FreeCAD.closeDocument(doc.Name)
        continue

    shape = Part.Shape()
    shape.makeShapeFromMesh(mesh_feature.Mesh.Topology, 0.1, False)

    if shape.isNull():
        print("  ERROR: Shape 変換に失敗しました（メッシュが複雑すぎる可能性）")
        FreeCAD.closeDocument(doc.Name)
        continue

    solid = Part.Solid(Part.Shell(shape.Faces))
    solid.exportStep(step_path)
    print(f"  OK: {step_path}")

    FreeCAD.closeDocument(doc.Name)

print("\n=== 変換完了 ===")
