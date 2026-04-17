// ============================================================
//  PS-15 スイッチボックス（1ボタン）v14 — 上下同一ハーフ設計
//  対象: Seimitsu PS-15
//  単位: mm
// ============================================================
//
//  【設計方針】
//    同一形状のハーフを2個印刷し、組み合わせてボックスを構成。
//    同じ印刷設定・同じ寸法誤差 → サイズ合わせ問題を根本解消。
//
//  【組立方法】
//    下ハーフ: 天面を上（正立）に置く
//    上ハーフ: ひっくり返して（天面を下向き）下ハーフに重ねる
//              → ボタン穴が最上面に来る
//    固定   : 4コーナー M3ボルト（長さは echo 参照）
//
//  【固定方式（4コーナー）】
//    インサートナット（M3）を下ハーフ底面外側から熱圧入
//    上ハーフ（反転）天面のカウンターボアからボルトを通す
//
//  【底面フィレット】接地面（Z=0側）の水平エッジ4本を R1.5mm でフィレット。
//                    反転した上ハーフの天面（組立時の上面）も同時に丸まる。
//                    合わせ面は直角を維持（ハーフ同士がぴったり接する）。
//
//  【配線】全4壁（前後左右）合わせ面に半円切り欠き（2ハーフ合体で円φ10mm）
//          連接時（daisy-chain）に各方向へケーブルが通せる
//
//  【位置合わせ（ラップジョイント・段継ぎ方式）】
//    E/W（東西）壁の合わせ面（Z=HALF_H）に段差δ=1.5mm の舌（凸）と溝（凹）を設ける。
//    下ハーフ E 壁に舌、W 壁に溝。反転した上ハーフは E/W が入れ替わり凸↔凹が噛み合う。
//    南(+Y) → 北(-Y) スライドで嵌合・自己ストップ。
//    変換: (x,y,z) → (OUTER_W-x, y, 2*HALF_H-z)
//
// ============================================================

/* ─── PS-15 仕様 ─── */
BTN_HOLE_D  = 30;    // 取付穴径 φ30mm
BTN_DEPTH   = 22.7;  // パネル下本体深さ（端子含む）

/* ─── ボックス基本寸法 ─── */
WALL        = 2.0;   // 側壁厚
BOT_T       = 2.0;   // 底面板厚（ボタン穴・cbore・インサート穴が集中する面）
HALF_H      = 23.5;  // 各ハーフ高さ
// 各ハーフはオープンカップ設計: Z=0〜BOT_T が底板、Z=BOT_T〜HALF_H が開口内部
INNER_H_HALF = HALF_H - BOT_T;           // 各ハーフ内高 = 21.5mm（開口カップ）
INNER_W     = 43;    // 内寸 X
INNER_D     = 43;    // 内寸 Y
CORNER_R      = 4.0;   // 外形コーナー半径
BOTTOM_FILLET = 1.5;   // 底面4辺のフィレット半径（合わせ面はシャープ保持）
INNER_CORNER_R = CORNER_R - WALL;        // 内壁コーナー半径 = 2mm

/* ─── 固定穴（4コーナー）─── */
MOUNT_INSET  = 9.0;  // コーナーからの内側オフセット（最小 9mm）
MOUNT_HOLE_D = 4.5;  // クリアランス穴径（M3 ボルト用）
MOUNT_CBORE_D= 9.0;  // カウンターボア径（M3 ボタンヘッドボルト頭）
CBORE_H      = 1.0;  // カウンターボア深さ（残し厚 = BOT_T - CBORE_H = 1.0mm）

/* ─── M3 インサートナット（熱圧入・底面外側から挿入）─── */
INSERT_OD   = 4.6;   // インサートナット外径
INSERT_L    = 8.0;   // インサートナット長さ
PILOT_D     = INSERT_OD + 0.1;           // 下穴径 = 4.7mm
PILOT_DEPTH = INSERT_L + 0.5;            // 下穴深さ = 8.5mm

/* ─── 内側ボス（底面板内側に突出）─── */
// ボス高さ = 下穴深さ - 底板厚 → ボス上面が下穴の上端に一致
BOSS_H      = PILOT_DEPTH - BOT_T;       // 6.5mm
BOSS_OD     = 10.0;  // ボス外径（≥ 2×INSERT_OD = 9.2mm）

/* ─── 位置合わせ凸凹（E/W壁・合わせ面 ラップジョイント方式）─── */
// 段継ぎ: E壁内側 1mm に舌（凸）、W壁内側 1mm に溝（凹）を配置。
// 下ハーフ反転で凸↔凹が入れ替わり噛み合う（同一ハーフ設計）。
STEP_DELTA   = 1.5;    // 段差高さ（mm）
STEP_Y_START = 29;     // 舌/溝 Y 開始位置（mm）
STEP_Y_END   = 43;     // 舌/溝 Y 終了位置（mm）
STEP_CLEAR   = 0.35;   // FDM 片側クリア（バンプ頂点+0.3mm分+余裕0.05mm確保）

// ---- ディテント (E1: 球バンプ) ----
DETENT_BUMP_R  = 0.30;   // バンプ半径（舌上面に凸）
DETENT_DIVOT_R = 0.45;   // ディンプル半径（溝天井に凹、CLEAR込み）
DETENT_Y       = (STEP_Y_START + STEP_Y_END) / 2;  // = 36（ストローク中央）

/* ─── 配線穴（合わせ面・半円切り欠き／合体で円形）─── */
// 全4壁に配置（連接時 daisy-chain 対応）
WIRE_D = 10.0;   // 合体時の円径（各ハーフは半円切り欠き）

/* ─── 算出値 ─── */
OUTER_W = INNER_W + 2 * WALL;   // 47.0mm
OUTER_D = INNER_D + 2 * WALL;   // 47.0mm

$fn = 64;

/* [断面表示] */
show_section = true;   // 断面表示を有効にする
cut_axis = 2;          // [0:X軸, 1:Y軸, 2:Z軸]
// デフォルト = MAX → スライダー最大位置でモデル全体が表示される
// X: ハーフ1(0-47) + gap(15) + ハーフ2(62-109) → MAX=110 で全表示
cut_x = 110;           // [0:1:110]
// Y: 外寸 47mm → MAX=50 で全表示
cut_y = 50;            // [0:1:50]
// Z: 0〜HALF_H=23.5mm → MAX=25 で全表示
cut_z = 25;            // [0:1:25]

/* [出力] */
// 0: ビュー  1: ハーフ単体（STL出力用）
render_part = 0;       // [0:ビュー, 1:ハーフ単体]
// FDM 収縮補正: 穴径を指定値だけ拡大（ボス等の外形には不適用）
hole_comp = 0.2;       // [0:0.05:0.5]

// 4コーナー: 前左・前右・後左・後右
mount_pts = [
    [MOUNT_INSET,             MOUNT_INSET            ],  // 前左
    [OUTER_W - MOUNT_INSET,   MOUNT_INSET            ],  // 前右
    [MOUNT_INSET,             OUTER_D - MOUNT_INSET  ],  // 後左
    [OUTER_W - MOUNT_INSET,   OUTER_D - MOUNT_INSET  ]   // 後右
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
//  モジュール: 外殻（底面4辺フィレット・合わせ面はシャープ）
//    minkowski で球をスイープしてフィレット生成、上端は cube でクリップ
// ============================================================
module outer_shell() {
    r = BOTTOM_FILLET;
    intersection() {
        minkowski() {
            translate([r, r, r])
                rounded_box(OUTER_W - 2*r, OUTER_D - 2*r, HALF_H - r, CORNER_R - r);
            sphere(r = r);
        }
        // 上端クリップ（合わせ面 Z=HALF_H 以上を落として直角に保つ）
        cube([OUTER_W, OUTER_D, HALF_H]);
    }
}

// ============================================================
//  モジュール: 配線穴（4壁・合わせ面半円切り欠き）
//    合わせ面 Z=HALF_H に中心を持つ円柱を各壁中央に配置 → 壁の上端を半円に切り欠く
//    2ハーフ合体で円φWIRE_D になる（daisy-chain 連接時は各方向にケーブル通し可）
// ============================================================
module wire_half_hole() {
    hole_d = WIRE_D + hole_comp;
    // 前壁（Y=0）: 軸Y方向
    translate([OUTER_W / 2, -0.1, HALF_H])
        rotate([-90, 0, 0])
            cylinder(d = hole_d, h = WALL + 0.2);
    // 後壁（Y=OUTER_D）: 軸Y方向
    translate([OUTER_W / 2, OUTER_D - WALL - 0.1, HALF_H])
        rotate([-90, 0, 0])
            cylinder(d = hole_d, h = WALL + 0.2);
    // 左壁（X=0）: 軸X方向
    translate([-0.1, OUTER_D / 2, HALF_H])
        rotate([0, 90, 0])
            cylinder(d = hole_d, h = WALL + 0.2);
    // 右壁（X=OUTER_W）: 軸X方向
    translate([OUTER_W - WALL - 0.1, OUTER_D / 2, HALF_H])
        rotate([0, 90, 0])
            cylinder(d = hole_d, h = WALL + 0.2);
}

// ============================================================
//  モジュール: ラップジョイント 舌（凸） — union() 内で呼ぶ
//    E 壁（X = OUTER_W - WALL）内側 1mm に配置。
//    合わせ面 Z=HALF_H を中心に ±STEP_DELTA/2 突出。
//    反転した上ハーフでは W 壁に現れ、下ハーフの W 壁溝に噛み合う。
// ============================================================
module step_tongue() {
    translate([OUTER_W - WALL, STEP_Y_START, HALF_H - STEP_DELTA / 2])
        cube([1.0, STEP_Y_END - STEP_Y_START, STEP_DELTA]);
}

// ============================================================
//  モジュール: ラップジョイント 溝（凹） — difference() 内で呼ぶ
//    W 壁（X = 0〜WALL）内側 1mm に配置。
//    STEP_CLEAR を片側に付与してFDM干渉を回避。
//    X のオーバーラン -0.1mm は CGAL 演算誤差回避のため必須。
// ============================================================
module step_groove() {
    translate([-0.1, STEP_Y_START - STEP_CLEAR, HALF_H - STEP_DELTA / 2 - STEP_CLEAR])
        cube([
            1.0 + STEP_CLEAR + 0.1,
            (STEP_Y_END - STEP_Y_START) + 2 * STEP_CLEAR,
            STEP_DELTA + 2 * STEP_CLEAR
        ]);
}

// ============================================================
//  モジュール: ディテント バンプ（凸） — union() 内で呼ぶ
//    下ハーフ E 壁・舌の上面中央に半球バンプ
//    バンプ中心: (舌中央X, DETENT_Y, 舌上面Z=HALF_H+STEP_DELTA/2)
// ============================================================
module detent_bump() {
    translate([OUTER_W - WALL/2, DETENT_Y, HALF_H + STEP_DELTA/2])
        sphere(r = DETENT_BUMP_R, $fn = 24);
}

// ============================================================
//  モジュール: ディテント ディンプル（凹） — difference() 内で呼ぶ
//    下ハーフ W 壁・溝の底面中央に半球ディンプル
//    ディンプル中心: (溝中央X, DETENT_Y, 溝底面Z=HALF_H-STEP_DELTA/2-STEP_CLEAR)
// ============================================================
module detent_divot() {
    translate([WALL/2, DETENT_Y, HALF_H - STEP_DELTA/2 - STEP_CLEAR])
        sphere(r = DETENT_DIVOT_R, $fn = 24);
}

// ============================================================
//  モジュール: ハーフ本体（上下共通・1種類のみ）
//    原点 = 底面外側・前左コーナー
//    天面（Z = HALF_H 側）: ボタン穴 + カウンターボア（反転時に上に来る）
//    底面（Z = 0 側）     : インサート下穴 + ボス（正立時に台座になる）
//    開口端（Z = HALF_H 側）: 位置合わせ凸凹（E/W壁ラップジョイント方式）
// ============================================================
module half_body() {
    difference() {
        union() {
            // ① 外殻（天面 + 底面 + 側壁）
            difference() {
                outer_shell();

                // 内部空洞はそのまま（内壁はシャープでOK）
                translate([WALL, WALL, BOT_T])
                    rounded_box(INNER_W, INNER_D, HALF_H, INNER_CORNER_R);

                // 配線穴（4壁合わせ面半円切り欠き・合体で円形・daisy-chain対応）
                wire_half_hole();
            }

            // ② 内側ボス（底面板内側・4コーナー）
            for (p = mount_pts) {
                translate([p[0], p[1], BOT_T])
                    cylinder(d = BOSS_OD, h = BOSS_H);
            }

            // ③ ラップジョイント 舌（E壁内側・合わせ面±STEP_DELTA/2）
            step_tongue();
            detent_bump();
        }

        // ④ インサート下穴（底面外側から・底板 + ボスを貫通）
        //    エントリ 1mm: 45°面取り
        //    残り: ストレート φ4.7mm
        for (p = mount_pts) {
            translate([p[0], p[1], -0.1]) {
                // 45°エントリ面取り（底面外側から 1mm）
                cylinder(d1 = PILOT_D + hole_comp + 2, d2 = PILOT_D + hole_comp, h = 1.1);
                // ストレート部
                cylinder(d = PILOT_D + hole_comp, h = PILOT_DEPTH + 0.1);
            }
        }

        // ⑤ カウンターボア + 貫通穴（底面外側から・反転時に天面になる）
        //    上ハーフ反転後: この面が最上面 → cbore にボルト頭が収まる
        //    下ハーフ正立時: この面が底面 → cbore はゴム足で隠れる
        for (p = mount_pts) {
            translate([p[0], p[1], 0]) {
                // カウンターボア（底面外側から 2mm）
                translate([0, 0, BOT_T - CBORE_H])
                    cylinder(d = MOUNT_CBORE_D + hole_comp, h = CBORE_H + 0.1);
                // 貫通穴（底板を全貫通）
                translate([0, 0, -0.1])
                    cylinder(d = MOUNT_HOLE_D + hole_comp, h = BOT_T + 0.2);
            }
        }

        // ⑥ ボタン取付穴 φ30（底面中央・反転時に天面になる）
        translate([OUTER_W / 2, OUTER_D / 2, -0.1])
            cylinder(d = BTN_HOLE_D + hole_comp, h = BOT_T + 0.2);

        // ⑦ 底面内側刻印（ボタン穴の外側・底板内面から 0.5mm 彫刻）
        // Y=4.5, X=OUTER_W/2+5 に "NongSoft LLC"（前左ボス φ10@(9,9) を回避し右にオフセット）
        translate([OUTER_W / 2 + 5, 4.5, BOT_T - 0.5 - 0.1])
            linear_extrude(height = 0.6)
                text("NongSoft LLC",
                     size   = 3.0,
                     font   = "Liberation Sans:style=Bold",
                     halign = "center",
                     valign = "center");

        // ⑧ ラップジョイント 溝（W壁内側・STEP_CLEAR片側付与）
        step_groove();
        detent_divot();
    }
}

// ============================================================
//  モジュール: ビュー用並置（組立イメージ）
//    下ハーフ: 正立
//    上ハーフ: X軸中心で反転（天面を下向き）→ 下ハーフ上に積む
// ============================================================
module main_model() {
    // 下ハーフ（正立）
    color("SteelBlue", 0.9)
        half_body();

    // 上ハーフ（ひっくり返して積む）
    // Z軸まわり 180° + X軸まわり 180° → 天面が下、ボタン穴が上
    color("LightSkyBlue", 0.9)
        translate([OUTER_W, 0, 2 * HALF_H])
            rotate([180, 0, 180])
                half_body();
}

// ============================================================
//  寸法・推奨ボルト長（echo）
// ============================================================
//  M3 ボルト経路（組立時）:
//    上ハーフ(反転)  cbore残し           = BOT_T - CBORE_H   = 1.0 mm
//    上ハーフ(反転)  内高（開口カップ）  = INNER_H_HALF      = 21.5 mm
//    下ハーフ(正立)  内高（開口カップ）  = INNER_H_HALF      = 21.5 mm
//    合計経路                                                 = 44.0 mm
//    インサート内噛み  = ボルト全長 - 44.0 mm
//    INSERT_L=8mm → M3×55 推奨（噛み 11mm）
bolt_path = (BOT_T - CBORE_H) + INNER_H_HALF + INNER_H_HALF;
recommended_bolt = ceil((bolt_path + INSERT_L) / 5) * 5;  // 5mm単位で切り上げ

echo("=== PS-15 Box v14 上下同一ハーフ設計（開口カップ）===");
echo(str("外寸 W×D（組立時）:   ", OUTER_W, " × ", OUTER_D, " mm（コーナー R", CORNER_R, "）"));
echo(str("外寸 H（組立時）:     ", 2 * HALF_H, " mm（各ハーフ ", HALF_H, " mm）"));
echo(str("各ハーフ内高（開口）: ", INNER_H_HALF, " mm（底板 ", BOT_T, " mm + 開口内高 ", INNER_H_HALF, " mm）"));
echo(str("総内高（組立時）:     ", 2 * INNER_H_HALF, " mm（BTN_DEPTH ", BTN_DEPTH, " mm に対して余裕 ", 2 * INNER_H_HALF - BTN_DEPTH, " mm）"));
echo(str("底面板厚:             ", BOT_T, " mm（ボタン穴・cbore・インサート穴が集中）"));
echo(str("内側ボス:             φ", BOSS_OD, " × H", BOSS_H, " mm（4箇所）"));
echo(str("インサート下穴:       φ", PILOT_D, " mm × ", PILOT_DEPTH, " mm 深（M3×φ", INSERT_OD, "×L", INSERT_L, " 熱圧入）"));
echo(str("ラップジョイント: δ=", STEP_DELTA, " mm, Y=[", STEP_Y_START, ",", STEP_Y_END, "], CLEAR=", STEP_CLEAR, " mm（片側）"));
echo(str("ディテント: バンプR=", DETENT_BUMP_R, ", ディンプルR=", DETENT_DIVOT_R, ", Y=", DETENT_Y, ", スライド余裕=", STEP_CLEAR - DETENT_BUMP_R, " mm"));
echo(str("配線穴:               φ", WIRE_D, " mm × 4壁（前後左右・合わせ面半円／連接対応）"));
echo(str("底面フィレット:       R", BOTTOM_FILLET, " mm（接地4辺・合わせ面はシャープ）"));
echo(str("固定穴:               4コーナー（前左+前右+後左+後右、MOUNT_INSET=", MOUNT_INSET, " mm）"));
echo(str("M3 ボルト経路:        ", bolt_path, " mm（cbore残し ", BOT_T - CBORE_H, " mm + 上ハーフ内高 ", INNER_H_HALF, " mm + 下ハーフ内高 ", INNER_H_HALF, " mm）"));
echo(str("推奨ボルト長:         M3×", recommended_bolt, "（インサート内噛み ", recommended_bolt - bolt_path, " mm / INSERT_L=", INSERT_L, " mm）"));

// ============================================================
//  断面表示（Customizer 連動）
// ============================================================
module section_cut(axis) {
    pos = axis == 0 ? cut_x : axis == 1 ? cut_y : cut_z;
    if (axis == 0) {
        translate([pos, -250, -250]) cube([500, 500, 500]);
    } else if (axis == 1) {
        translate([-250, pos, -250]) cube([500, 500, 500]);
    } else {
        translate([-250, -250, pos]) cube([500, 500, 500]);
    }
}

// ============================================================
//  出力制御
// ============================================================
if (render_part == 1) {
    // ハーフ単体（STL出力用）: 天面を上にして原点に出力
    half_body();
} else if (show_section) {
    difference() {
        main_model();
        section_cut(cut_axis);
    }
} else {
    main_model();
}
