// ============================================================
//  PS-15 スイッチボックス（1ボタン）v6
//  対象: Seimitsu PS-15
//  単位: mm
// ============================================================
//
//  【固定方式（対角2点・兼用設計）】
//    木板固定: φ4 木ネジ（蓋カウンターボア → 蓋 → 底面 → 木板）
//    単体使用: M3×30 ボルト（蓋 → 中空内部 → 底面インサートナット）
//
//  【インサートナット設計根拠（熱圧入）】
//    下穴径   = インサートOD + 0.1mm = 4.7mm（丸穴）
//    下穴深さ = インサート長 + 0.5mm = 5.5mm
//    ボス最外径 = OD × 2 以上 → 底面板厚 7mm で底面全体が十分なボスに相当
//    ボルト通し穴 φ3.5mm を下穴上方 1.5mm の固定壁部に設ける
//
//  【ボタン取り外し】
//    対角2本のねじを外す → 蓋＋ボタンを持ち上げる → フラット状態でクリップ操作
//
//  【配線】右側面・底部寄りに U 字スロット（幅 12mm × 高さ 10mm）
//
// ============================================================

/* ─── PS-15 仕様 ─── */
BTN_HOLE_D  = 30;    // 取付穴径 φ30mm
BTN_DEPTH   = 22.7;  // パネル下本体深さ（端子含む）

/* ─── ボックス基本寸法 ─── */
WALL        = 2.5;   // 側壁厚（底面板厚と共通）
BOTTOM_T    = WALL;  // 底面板厚 = 2.5mm（他の壁と同じ・ボス以外は薄い）
INNER_W     = 42;    // 内寸 X
INNER_D     = 42;    // 内寸 Y
INNER_H     = 41.5;  // 内寸 Z（組立総高 = OUTER_W = 47mm に合わせ正立方体化）
LID_T       = 3.0;   // 蓋板厚（PS-15 取付板厚上限 3.0mm に合わせる）
CORNER_R    = 4.0;   // 外形コーナー半径（四隅 R）
INNER_CORNER_R = CORNER_R - WALL;  // 内壁コーナー半径 = 1.5mm（壁厚を一定に保つ）
LID_EDGE_R  = 1.5;   // 蓋上面エッジ丸め半径（手が触れる部分）


/* ─── 固定穴（対角2点・木ネジ兼 M3 ボルト）─── */
// MOUNT_INSET ≥ 9mm 必要:
//   コーナー外形（CORNER_R=4）の最近接点 = 4(1+1/√2) ≈ 6.83mm
//   パイロット穴半径 PILOT_D/2 = 2.35mm → 干渉回避に 6.83+2.35 = 9.18mm 以上必要
MOUNT_INSET  = 9.0;  // コーナーからの内側オフセット（穴テーパー防止・最小 9mm）
MOUNT_HOLE_D = 4.5;  // 蓋・木ネジ用クリアランス穴径（φ4 木ネジ / M3 ボルト兼用）
MOUNT_CBORE_D= 9.0;  // カウンターボア径（φ4 木ネジ頭 / M3 ボルト頭 兼用）
CBORE_H      = 2.0;  // カウンターボア深さ（LID_T=3mm のため 2mm：M3 ボタンヘッドボルト頭高 1.7mm に対応）

/* ─── M3 インサートナット（熱圧入・底面外側から挿入）─── */
INSERT_OD   = 4.6;   // インサートナット外径
INSERT_L    = 8.0;   // インサートナット長さ（8mm：M3×50 で 7.5mm 噛み）
PILOT_D     = INSERT_OD + 0.1;     // 下穴径（D1 + 0.1mm）= 4.7mm
PILOT_DEPTH = INSERT_L + 0.5;      // 下穴深さ（L + 0.5mm）= 5.5mm

/* ─── 内側ボス（インサート部分だけ厚みを確保）─── */
// ボス高さ = 下穴深さ - 底板厚 → ボス上面が下穴の上端に一致
BOSS_H      = PILOT_DEPTH - BOTTOM_T;  // 3.0mm（底板内側に突出）
BOSS_OD     = 10.0;  // ボス外径（≥ 2×INSERT_OD = 9.2mm）

/* ─── 配線穴（右側面・U字スロット）─── */
WIRE_W      = 12.0;  // スロット幅
WIRE_H      = 10.0;  // スロット高さ（弧含む）

/* ─── 算出値 ─── */
OUTER_W = INNER_W + 2 * WALL;   // 47.0 mm
OUTER_D = INNER_D + 2 * WALL;   // 47.0 mm
BOX_H   = INNER_H + BOTTOM_T;   // 31.0 mm

$fn = 64;

/* [断面表示] */
show_section = true;   // 断面表示を有効にする
cut_axis = 2;          // [0:X軸, 1:Y軸, 2:Z軸]
// デフォルト = MAX → スライダー最大位置でモデル全体が表示される
// X: 箱(0-47) + gap(15) + 蓋(62-109) → MAX=110 で全表示
cut_x = 110;           // [0:1:110]
// Y: 外寸 47mm → MAX=50 で全表示
cut_y = 50;            // [0:1:50]
// Z: リム底面 -5mm 〜 箱天面 27mm → MAX=30 で全表示
cut_z = 30;            // [-5:1:30]

/* [出力] */
// 0: ビュー（並置）  1: 本体のみ（STL出力用）  2: 蓋のみ（STL出力用）
render_part = 0;       // [0:ビュー, 1:本体, 2:蓋]
// FDM 収縮補正: 穴径を指定値だけ拡大（ボス等の外形には不適用）
hole_comp = 0.2;       // [0:0.05:0.5]

// 固定穴座標（対角2点: 前左 / 後右）
mount_pts = [
    [MOUNT_INSET,             MOUNT_INSET            ],
    [OUTER_W - MOUNT_INSET,   OUTER_D - MOUNT_INSET  ]
];

// ============================================================
//  モジュール: 角Rつき矩形柱
// ============================================================
module rounded_box(w, d, h, r) {
    hull() {
        translate([    r,     r, 0]) cylinder(r = r, h = h);
        translate([w - r,     r, 0]) cylinder(r = r, h = h);
        translate([    r, d - r, 0]) cylinder(r = r, h = h);
        translate([w - r, d - r, 0]) cylinder(r = r, h = h);
    }
}

// ============================================================
//  モジュール: 上面エッジ丸め付き板（minkowski）
//    底面はフラット、上面エッジだけ R = edge_r で丸める
// ============================================================
module rounded_top_solid(w, d, h, corner_r, edge_r) {
    // h - 2*edge_r がゼロ以下になると minkowski が縮退するため最小 0.01mm を保証
    inner_h = max(h - 2 * edge_r, 0.01);
    intersection() {
        // minkowski で全エッジを丸める（球をスウィープ）
        translate([0, 0, edge_r])
            minkowski() {
                rounded_box(
                    w        - 2 * edge_r,
                    d        - 2 * edge_r,
                    inner_h,
                    corner_r - edge_r
                );
                sphere(r = edge_r, $fn = 32);
            }
        // 底面の丸みをカットしてフラットに保つ
        translate([-0.1, -0.1, 0])
            cube([w + 0.2, d + 0.2, h + 0.2]);
    }
}

// ============================================================
//  モジュール: U字配線スロット（右壁・底部寄り）
//    ─ intersection で Z≥BOTTOM_T にクリップし底板を保護
// ============================================================
module wire_u_slot() {
    intersection() {
        // U字形状本体（矩形 ＋ 上端半円、壁を貫通する方向に押し出し）
        translate([OUTER_W - WALL - 0.1, OUTER_D / 2, BOTTOM_T]) {
            // 直線部（底辺〜半円中心まで）: FDM 補正 +hole_comp
            translate([0, -(WIRE_W + hole_comp) / 2, 0])
                cube([WALL + 0.2, WIRE_W + hole_comp, WIRE_H - (WIRE_W + hole_comp) / 2]);
            // 上端半円（cylinder で全円を生成し、矩形部との union で U 字に）: FDM 補正 +hole_comp
            translate([0, 0, WIRE_H - (WIRE_W + hole_comp) / 2])
                rotate([0, 90, 0])
                    cylinder(d = WIRE_W + hole_comp, h = WALL + 0.2);
        }
        // クリップ: 側壁領域（Z≥BOTTOM_T）のみ切り抜き、底板は保護
        translate([-0.1, -0.1, BOTTOM_T])
            cube([OUTER_W + 0.2, OUTER_D + 0.2, BOX_H - BOTTOM_T + 0.1]);
    }
}

// ============================================================
//  モジュール: ボックス本体
//    原点 = 底面外側・前左コーナー
//
//  ボス設計:
//    底面板は薄く（WALL=2.5mm）、インサート位置だけ内側にボスを立てる
//    ボスは rounded_box 外形でクリップして外側に飛び出さないようにする
//    ボルトは外形より大きい下穴（φ4.7mm）を通じてインサートに届く
// ============================================================
module box_body() {
    difference() {
        union() {
            // ① 薄い底板の箱（空洞・U字スロット込み）
            difference() {
                rounded_box(OUTER_W, OUTER_D, BOX_H, CORNER_R);

                // 内部空洞（上面オープン・内壁も R 付き）
                translate([WALL, WALL, BOTTOM_T])
                    rounded_box(INNER_W, INNER_D, BOX_H, INNER_CORNER_R);

                // U字配線スロット（右側面・底部寄り）
                wire_u_slot();
            }

            // ② 内側ボス（対角2点）
            //    MOUNT_INSET=9mm により、ボスはコーナー外形内に完全に収まるため
            //    intersection クリップ不要（テーパー発生なし）
            for (p = mount_pts) {
                translate([p[0], p[1], BOTTOM_T])
                    cylinder(d = BOSS_OD, h = BOSS_H);
            }
        }

        // ③ インサート下穴（底面外側から・底板 ＋ ボスを貫通）
        //    エントリ 1mm: 45°面取り（d1 = PILOT_D+2, d2 = PILOT_D）
        //    残り 4.5mm: ストレート φ4.7mm
        for (p = mount_pts) {
            translate([p[0], p[1], -0.1]) {
                // 45°エントリ面取り（底面外側から 1mm）: FDM 補正 +hole_comp
                cylinder(d1 = PILOT_D + hole_comp + 2, d2 = PILOT_D + hole_comp, h = 1.1);
                // ストレート部（面取り底面〜ボス上面まで）: FDM 補正 +hole_comp
                cylinder(d = PILOT_D + hole_comp, h = PILOT_DEPTH + 0.1);
            }
        }

        // ④ 内側底面刻印（BOTTOM_T 上面から 0.5mm 彫刻・ケース内部から見える）
        //    内寸 42mm に収める 2行構成（行間 5mm）
        translate([OUTER_W/2, OUTER_D/2 + 2.5, BOTTOM_T - 0.5 - 0.1])
            linear_extrude(height = 0.6)
                text("NongSoft LLC",
                     size   = 3.5,
                     font   = "Liberation Sans:style=Bold",
                     halign = "center",
                     valign = "center");
        translate([OUTER_W/2, OUTER_D/2 - 2.5, BOTTOM_T - 0.5 - 0.1])
            linear_extrude(height = 0.6)
                text("2026",
                     size   = 3.5,
                     font   = "Liberation Sans:style=Bold",
                     halign = "center",
                     valign = "center");
    }
}

// ============================================================
//  モジュール: 蓋
//    上面エッジ丸め（LID_EDGE_R）＋ φ30 ボタン穴 ＋ 対角2点カウンターボア
//    原点 = 下面（ボックス当接面）・前左コーナー
// ============================================================
module lid() {
    difference() {
        // 蓋板（上面エッジ丸め付き外形）
        rounded_top_solid(OUTER_W, OUTER_D, LID_T, CORNER_R, LID_EDGE_R);

        // ボタン取付穴 φ30（中央）: FDM 補正 +hole_comp
        translate([OUTER_W / 2, OUTER_D / 2, -0.1])
            cylinder(d = BTN_HOLE_D + hole_comp, h = LID_T + 0.2);

        // 固定穴（対角2点）: カウンターボア ＋ 貫通穴: FDM 補正 +hole_comp
        for (p = mount_pts) {
            translate([p[0], p[1], 0]) {
                // カウンターボア（上面から）
                translate([0, 0, LID_T - CBORE_H])
                    cylinder(d = MOUNT_CBORE_D + hole_comp, h = CBORE_H + 0.1);
                // 貫通穴
                translate([0, 0, -0.1])
                    cylinder(d = MOUNT_HOLE_D + hole_comp, h = LID_T + 0.2);
            }
        }

        // 蓋裏面刻印（Z=0 面から 0.4mm 彫刻・蓋を外したとき裏から見える）
        //   ボタン穴（φ30）の下側スペース（Y≈5.5）に配置
        //   距離チェック: 穴中心(23.5)-テキスト中心(5.5)=18mm > 穴半径15mm ✓
        translate([OUTER_W/2, OUTER_D/2 - BTN_HOLE_D/2 - 3, -0.1])
            linear_extrude(height = 0.5)
                text("NongSoft LLC  2026",
                     size   = 2.5,
                     font   = "Liberation Sans:style=Bold",
                     halign = "center",
                     valign = "center");

        // コーナーオープンスロット: 不要
        //   cbore 半径 4.5mm > コーナー外壁までの距離 3.07mm
        //   → カウンターボアが自然にコーナー壁を 1.43mm 貫通するため
        //     追加のスロットを入れると周囲肉厚が < 1mm になり強度不足
    }
}

// ============================================================
//  メインモデル（並置）
// ============================================================
module main_model() {
    color("SteelBlue",    0.9)  box_body();
    color("LightSkyBlue", 0.9)  translate([OUTER_W + 15, 0, 0])  lid();
}

// ============================================================
//  寸法・推奨ボルト長（echo）
// ============================================================
//  M3 ボルト経路（単体使用時）:
//    蓋残し（カウンターボア下）= LID_T - CBORE_H =  1.0 mm
//    箱内部（中空）            = INNER_H          = 41.5 mm
//    ボス上まで                = 0 mm
//    合計経路                  =                  = 42.5 mm
//    インサート内噛み = 50 - 42.5 = 7.5mm（INSERT_L=8mm に対して適正）
//    → M3×50 推奨
bolt_path = (LID_T - CBORE_H) + INNER_H;

echo("=== PS-15 Box v5 寸法 ===");
echo(str("外寸 W×D×H (本体): ", OUTER_W, " × ", OUTER_D, " × ", BOX_H, " mm（コーナー R", CORNER_R, "）"));
echo(str("蓋厚:              ", LID_T, " mm（上面エッジ R", LID_EDGE_R, "）"));
echo(str("総高（組立時）:     ", BOX_H + LID_T, " mm"));
echo(str("内寸 W×D×H:        ", INNER_W, " × ", INNER_D, " × ", INNER_H, " mm"));
echo(str("ボタン深さ余裕:     ", INNER_H - BTN_DEPTH, " mm"));
echo(str("底面板厚:          ", BOTTOM_T, " mm（壁と同じ・ボス部以外）"));
echo(str("内側ボス:          φ", BOSS_OD, " × H", BOSS_H, " mm（対角2点）"));
echo(str("インサート下穴:    φ", PILOT_D, " mm × ", PILOT_DEPTH, " mm 深（M3×φ", INSERT_OD, "×L", INSERT_L, " 熱圧入）"));
echo(str("M3 ボルト経路:     ", bolt_path, " mm → M3×50 推奨（", 50 - bolt_path, " mm インサート内噛み）"));

// ============================================================
//  断面表示（Customizer 連動）
// ============================================================
module section_cut(axis) {
    // cut_x/y/z より正方向側を除去 → スライダーを下げるとモデル断面が現れる
    // デフォルト値（MAX）ではモデル全体が表示される
    pos = axis == 0 ? cut_x : axis == 1 ? cut_y : cut_z;
    if (axis == 0) {
        translate([pos, -250, -250]) cube([500, 500, 500]);
    } else if (axis == 1) {
        translate([-250, pos, -250]) cube([500, 500, 500]);
    } else {
        translate([-250, -250, pos]) cube([500, 500, 500]);
    }
}

// render_part=1/2 のとき断面・並置を無視して単体を原点に出力（STL用）
if (render_part == 1) {
    box_body();
} else if (render_part == 2) {
    // 蓋: 内面（ボックス当接面）を Z=0 にしたまま出力 → スライサーで平置き即印刷
    lid();
} else if (show_section) {
    difference() {
        main_model();
        section_cut(cut_axis);
    }
} else {
    main_model();
}
