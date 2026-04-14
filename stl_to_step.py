"""
STL → STEP 変換スクリプト（FreeCAD 1.1 用）
使い方:
    freecadcmd.exe stl_to_step.py
"""

import sys
import os

# FreeCAD モジュールパス（freecadcmd.exe 経由で実行する場合は自動設定済み）
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
    ("ps15_box_body.stl", "ps15_box_body.step"),
    ("ps15_lid.stl",      "ps15_lid.step"),
]

for stl_name, step_name in files:
    stl_path  = os.path.join(BASE_DIR, stl_name)
    step_path = os.path.join(BASE_DIR, step_name)

    print(f"\n--- {stl_name} → {step_name} ---")

    if not os.path.exists(stl_path):
        print(f"  SKIP: {stl_path} が見つかりません")
        continue

    # 新規ドキュメント
    doc = FreeCAD.newDocument("convert")

    # STL メッシュ読み込み
    mesh_obj = doc.addObject("Mesh::Feature", "Mesh")
    Mesh.insert(stl_path, doc.Name)
    doc.recompute()

    # メッシュオブジェクトを取得
    mesh_feature = None
    for obj in doc.Objects:
        if obj.TypeId == "Mesh::Feature":
            mesh_feature = obj
            break

    if mesh_feature is None:
        print("  ERROR: メッシュの読み込みに失敗しました")
        FreeCAD.closeDocument(doc.Name)
        continue

    # Mesh → Shape 変換（MeshPart モジュール）
    shape = MeshPart.meshToShape(mesh_feature.Mesh, True)

    if shape.isNull():
        print("  ERROR: Shape 変換に失敗しました（メッシュが複雑すぎる可能性）")
        FreeCAD.closeDocument(doc.Name)
        continue

    # STEP 出力
    shape.exportStep(step_path)
    print(f"  OK: {step_path}")

    FreeCAD.closeDocument(doc.Name)

print("\n=== 変換完了 ===")
