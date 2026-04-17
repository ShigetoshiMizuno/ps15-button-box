// ============================================================
//  PS-15 スイッチボックス（1ボタン）v12 — 上下同一ハーフ設計
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
//  【位置合わせ（4壁・合わせ面 楔形方式・点対称配置）】
//    前後左右すべての壁の合わせ面（Z=HALF_H）に台形押出しの楔凸/凹を配置。
//    接線方向テーパー 10→8mm、法線方向 壁厚一杯 2.0mm、高さ 5mm。
//    東西壁（左右）にも楔を追加し、rotate([0,0,90]) で接線方向をY軸方向に合わせる。
//    点対称配置:
//      前壁  凸(W/4)  + 凹(3W/4)、後壁  凸(3W/4) + 凹(W/4)
//      左壁  凸(D/4)  + 凹(3D/4)、右壁  凸(3D/4) + 凹(D/4)
//      → 反射(x,y,z)→(W-x,y,2H-z)/(x,D-y,2H-z) で 凸↔凹 が噛み合う
//    Socket は接線テーパー付き（開口10.4→奥8.4mm、凸と同方向・クリア0.2mm／片側一定）
//    凸のハの字 ＋ 凹の同方向テーパー ＝ 位置決めキー効果（接線方向の自動センタリング）
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

/* ─── 位置合わせ凸凹（4壁・合わせ面 楔形方式）─── */
// 楔形: 台形（接線方向にテーパー）を法線方向に押し出した形状
// 配置: 前後壁（南北）＋ 左右壁（東西）の4壁すべて。
// 東西壁は rotate([0,0,90]) で接線方向をY軸方向に合わせる。
WEDGE_TAN_BASE = 10.0;         // 接線方向 底（合わせ面側）
WEDGE_TAN_TIP  = 8.0;          // 接線方向 先端
WEDGE_NORM     = WALL;         // 法線方向（壁厚いっぱい = 2.0mm）
WEDGE_H        = 5.0;          // 突出高さ
SOCK_CLEAR     = 0.2;          // 接線方向 片側クリアランス（FDM）
SOCK_H         = WEDGE_H + 0.25;                      // 凹 深さ = 5.25
SOCK_TAN_OPEN  = WEDGE_TAN_BASE + 2 * SOCK_CLEAR;     // 10.4（合わせ面側）
SOCK_TAN_BOT   = WEDGE_TAN_TIP  + 2 * SOCK_CLEAR;     // 8.4（奥側）
SOCK_NORM      = WEDGE_NORM;                          // 法線方向クリア無し = 2.0

/* ─── 配線穴（合わせ面・半円切り欠き／合体で円形）─── */
// 全4壁に配置（連接時 daisy-chain 対応）
WIRE_D = 10.0;   // 合体時の円径（各ハーフは半円切り欠き）

/* ─── スナップフィットドーム ─── */
SNAP_BUMP_R  = 1.2;   // バンプ半球半径（受け穴より 0.1mm 大きく → 干渉クリック）
SNAP_HOLE_R  = 1.1;   // 受け穴半径
SNAP_HOLE_D  = 1.0;   // 受け穴深さ（mm）

/* ─── ツイストロック（バヨネット）─── */
TWIST_TAB_W  = 6.0;   // タブ幅（壁方向）
TWIST_TAB_H  = 2.5;   // タブ高さ（Z 方向突出量）
TWIST_TAB_T  = 1.5;   // タブ厚（壁厚方向）
TWIST_CLEAR  = 0.3;   // スロットクリアランス

/* ─── ヘリカルランプ ─── */
RAMP_H = 3.0;   // ランプ高さ（Z方向・左端と右端の高低差）

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
// 0: ビュー（並置）  1: ハーフ単体（STL出力用）  2: ツイスト確認（上ハーフ45°回転）
render_part = 0;       // [0:ビュー, 1:ハーフ単体, 2:ツイスト確認]
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
//  モジュール: 楔形ヘルパ
//    wedge      — 凸（底: tan_base×norm、先端: tan_tip×norm、高さ h）
//                 X軸 = 接線方向（テーパー）、Y軸 = 法線方向（一定）、Z軸 = 突出方向
//    wedge_socket — 凹（開口で広く・奥で狭い楔ソケット）
//                 原点 = 合わせ面開口中心、-Z方向に掘る
// ============================================================
// 楔: 底(tan_base × norm) → 先端(tan_tip × norm)、高さ h
// X軸=接線方向（テーパー）、Y軸=法線方向（一定）、Z軸=突出
module wedge(tan_base, tan_tip, norm, h) {
    linear_extrude(height=h, scale=[tan_tip/tan_base, 1])
        square([tan_base, norm], center=true);
}

// 凹: 接線テーパー付き（開口広く・奥狭く・凸と同方向テーパー）
// Z=-d（奥）から Z=0.1（合わせ面より0.1mmオーバーラン）まで、接線方向に広がる
module wedge_socket(tan_open, tan_bot, norm, d) {
    translate([0, 0, -d])
        linear_extrude(height = d + 0.1, scale = [tan_open / tan_bot, 1])
            square([tan_bot, norm], center = true);
}

// ============================================================
//  モジュール: 合わせ面の凸（bump）を追加 — union()内で呼ぶ
//    rotate([180,0,180]) 反転後に凸↔凹が噛み合うよう座標を設計。
//    前後壁はX位置で振り分け（反転でX→OUTER_W-X になるため入れ替わる）。
//    左右壁（東西）はY位置で振り分け（反転でY→OUTER_D-Y になるため入れ替わる）。
//    東西壁の楔は rotate([0,0,90]) で接線方向をY軸方向に合わせる。
// ============================================================
module mating_bumps() {
    // 前壁（Y=0側）凸: X = OUTER_W/4
    translate([OUTER_W / 4, WALL / 2, HALF_H])
        wedge(WEDGE_TAN_BASE, WEDGE_TAN_TIP, WEDGE_NORM, WEDGE_H);
    // 後壁（Y=OUTER_D側）凸: X = OUTER_W*3/4（点対称）
    translate([OUTER_W * 3 / 4, OUTER_D - WALL / 2, HALF_H])
        wedge(WEDGE_TAN_BASE, WEDGE_TAN_TIP, WEDGE_NORM, WEDGE_H);
    // 左壁（X=0側）凸: Y = OUTER_D/4
    translate([WALL / 2, OUTER_D / 4, HALF_H])
        rotate([0, 0, 90])
            wedge(WEDGE_TAN_BASE, WEDGE_TAN_TIP, WEDGE_NORM, WEDGE_H);
    // 右壁（X=OUTER_W側）凸: Y = OUTER_D*3/4（点対称）
    translate([OUTER_W - WALL / 2, OUTER_D * 3 / 4, HALF_H])
        rotate([0, 0, 90])
            wedge(WEDGE_TAN_BASE, WEDGE_TAN_TIP, WEDGE_NORM, WEDGE_H);
}

// ============================================================
//  モジュール: 合わせ面の凹（socket）を削る — difference()内で呼ぶ
//    東西壁の凹も rotate([0,0,90]) で接線方向をY軸方向に合わせる。
// ============================================================
module mating_sockets() {
    // 前壁凹: X = OUTER_W*3/4
    translate([OUTER_W * 3 / 4, WALL / 2, HALF_H])
        wedge_socket(SOCK_TAN_OPEN, SOCK_TAN_BOT, SOCK_NORM, SOCK_H);
    // 後壁凹: X = OUTER_W/4（点対称）
    translate([OUTER_W / 4, OUTER_D - WALL / 2, HALF_H])
        wedge_socket(SOCK_TAN_OPEN, SOCK_TAN_BOT, SOCK_NORM, SOCK_H);
    // 左壁凹: Y = OUTER_D*3/4（点対称）
    translate([WALL / 2, OUTER_D * 3 / 4, HALF_H])
        rotate([0, 0, 90])
            wedge_socket(SOCK_TAN_OPEN, SOCK_TAN_BOT, SOCK_NORM, SOCK_H);
    // 右壁凹: Y = OUTER_D/4（点対称）
    translate([OUTER_W - WALL / 2, OUTER_D / 4, HALF_H])
        rotate([0, 0, 90])
            wedge_socket(SOCK_TAN_OPEN, SOCK_TAN_BOT, SOCK_NORM, SOCK_H);
}

// ============================================================
//  モジュール: スナップフィットドーム バンプ — union() 内で呼ぶ
//    合わせ面（Z=HALF_H）から +Z 方向に半球を突出させる。
//    点対称配置: X=OUTER_W/4 と X=OUTER_W*3/4 の2点。
//    反転後: バンプ(W/4)→受け穴(W/4)、バンプ(3W/4)→受け穴(3W/4) が対応。
// ============================================================
module snap_bumps() {
    // 前壁断面中央（Y=WALL/2）に配置 → 壁の固体材料に接続
    translate([OUTER_W / 4,       WALL / 2, HALF_H]) sphere(r = SNAP_BUMP_R);
    translate([OUTER_W * 3 / 4,   WALL / 2, HALF_H]) sphere(r = SNAP_BUMP_R);
    // 後壁断面中央（Y=OUTER_D-WALL/2）にも配置（4点でより確実なスナップ）
    translate([OUTER_W / 4,       OUTER_D - WALL / 2, HALF_H]) sphere(r = SNAP_BUMP_R);
    translate([OUTER_W * 3 / 4,   OUTER_D - WALL / 2, HALF_H]) sphere(r = SNAP_BUMP_R);
}

// ============================================================
//  モジュール: スナップフィットドーム 受け穴 — difference() 内で呼ぶ
//    合わせ面（Z=HALF_H）から -Z 方向に受け穴を掘る。
//    点対称配置: X=OUTER_W/4 と X=OUTER_W*3/4 の2点。
// ============================================================
module snap_holes() {
    // 前壁（Y=WALL/2）
    translate([OUTER_W / 4,       WALL / 2,            HALF_H - SNAP_HOLE_D])
        cylinder(r = SNAP_HOLE_R, h = SNAP_HOLE_D + 0.1);
    translate([OUTER_W * 3 / 4,   WALL / 2,            HALF_H - SNAP_HOLE_D])
        cylinder(r = SNAP_HOLE_R, h = SNAP_HOLE_D + 0.1);
    // 後壁（Y=OUTER_D-WALL/2）
    translate([OUTER_W / 4,       OUTER_D - WALL / 2,  HALF_H - SNAP_HOLE_D])
        cylinder(r = SNAP_HOLE_R, h = SNAP_HOLE_D + 0.1);
    translate([OUTER_W * 3 / 4,   OUTER_D - WALL / 2,  HALF_H - SNAP_HOLE_D])
        cylinder(r = SNAP_HOLE_R, h = SNAP_HOLE_D + 0.1);
}

// ============================================================
//  モジュール: ツイストロックタブ（バヨネット凸）— union() 内で呼ぶ
//    合わせ面（Z=HALF_H）から +Z 方向に突出するタブ。
//    前壁外面（Y=0 側）: X=OUTER_W/4 中心
//    後壁外面（Y=OUTER_D 側）: X=OUTER_W*3/4（点対称）
//    45° ひねりでスロット位置（X=3/4, X=1/4）に噛み合う。
// ============================================================
module twist_tabs() {
    // 前壁タブ: X=OUTER_W/4 中心、壁外面（Y=0 外側）から Z 方向に突出
    translate([OUTER_W/4 - TWIST_TAB_W/2, -TWIST_TAB_T, HALF_H])
        cube([TWIST_TAB_W, TWIST_TAB_T, TWIST_TAB_H]);
    // 後壁タブ: X=OUTER_W*3/4（点対称）
    translate([OUTER_W*3/4 - TWIST_TAB_W/2, OUTER_D, HALF_H])
        cube([TWIST_TAB_W, TWIST_TAB_T, TWIST_TAB_H]);
}

// ============================================================
//  モジュール: ツイストロックスロット（バヨネット凹）— difference() 内で呼ぶ
//    45° 回転状態でタブが通過できる切り欠き。
//    前壁 X=OUTER_W*3/4（タブ位置 X=W/4 と点対称）
//    後壁 X=OUTER_W/4（タブ位置 X=3W/4 と点対称）
// ============================================================
module twist_slots() {
    sw = TWIST_TAB_W + 2 * TWIST_CLEAR;
    st = TWIST_TAB_T + TWIST_CLEAR;
    sh = TWIST_TAB_H + TWIST_CLEAR;
    // 前壁スロット: X=OUTER_W*3/4 中心
    translate([OUTER_W*3/4 - sw/2, -st, HALF_H - TWIST_CLEAR])
        cube([sw, st, sh + TWIST_CLEAR]);
    // 後壁スロット: X=OUTER_W/4（点対称）
    translate([OUTER_W/4 - sw/2, OUTER_D, HALF_H - TWIST_CLEAR])
        cube([sw, st, sh + TWIST_CLEAR]);
}

// ============================================================
//  モジュール: ヘリカルランプ（前後壁上端・90°ひねりロック用傾斜面）
//    前壁（Y=0〜WALL）: X=0（低=HALF_H）→ X=OUTER_W（高=HALF_H+RAMP_H）
//    後壁（Y=OUTER_D-WALL〜OUTER_D）: X=0（高=HALF_H+RAMP_H）→ X=OUTER_W（低=HALF_H）
//    前後で点対称 → 上ハーフ90°ひねりでZ方向に引き込まれてロック。
// ============================================================
module helix_ramps() {
    // 前壁ランプ: X=0でZ=HALF_H、X=OUTER_WでZ=HALF_H+RAMP_H
    hull() {
        translate([0, 0, HALF_H])
            cube([0.01, WALL, 0.01]);
        translate([OUTER_W - 0.01, 0, HALF_H + RAMP_H])
            cube([0.01, WALL, 0.01]);
    }
    // 後壁ランプ: X=0でZ=HALF_H+RAMP_H、X=OUTER_WでZ=HALF_H（点対称）
    hull() {
        translate([0, OUTER_D - WALL, HALF_H + RAMP_H])
            cube([0.01, WALL, 0.01]);
        translate([OUTER_W - 0.01, OUTER_D - WALL, HALF_H])
            cube([0.01, WALL, 0.01]);
    }
}

// ============================================================
//  モジュール: ハーフ本体（上下共通・1種類のみ）
//    原点 = 底面外側・前左コーナー
//    天面（Z = HALF_H 側）: ボタン穴 + カウンターボア（反転時に上に来る）
//    底面（Z = 0 側）     : インサート下穴 + ボス（正立時に台座になる）
//    開口端（Z = HALF_H 側）: 位置合わせ凸凹（4壁楔形方式）
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

            // ③ 位置合わせ凸（4壁楔形方式・一時無効化）
            // mating_bumps();

            // ⑨ スナップフィットドーム（合わせ面・点対称配置）
            snap_bumps();

            // ⑪ ツイストロックタブ（前後壁外面・45°ひねりロック）
            twist_tabs();

            // ⑬ ヘリカルランプ（前後壁・90°ひねりZ引き込みロック用傾斜面）
            helix_ramps();
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

        // ⑧ 位置合わせ凹（4壁楔形ソケット・一時無効化）
        // mating_sockets();

        // ⑩ スナップフィット受け穴
        snap_holes();

        // ⑫ ツイストロックスロット（前後壁・点対称配置）
        twist_slots();

        // ⑦ 底面内側刻印（ボタン穴の外側・底板内面から 0.5mm 彫刻）
        // Y=4.5, X=OUTER_W/2+5 に "NongSoft LLC"（前左ボス φ10@(9,9) を回避し右にオフセット）
        translate([OUTER_W / 2 + 5, 4.5, BOT_T - 0.5 - 0.1])
            linear_extrude(height = 0.6)
                text("NongSoft LLC",
                     size   = 3.0,
                     font   = "Liberation Sans:style=Bold",
                     halign = "center",
                     valign = "center");
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

echo("=== PS-15 Box v12 上下同一ハーフ設計（開口カップ）===");
echo(str("外寸 W×D（組立時）:   ", OUTER_W, " × ", OUTER_D, " mm（コーナー R", CORNER_R, "）"));
echo(str("外寸 H（組立時）:     ", 2 * HALF_H, " mm（各ハーフ ", HALF_H, " mm）"));
echo(str("各ハーフ内高（開口）: ", INNER_H_HALF, " mm（底板 ", BOT_T, " mm + 開口内高 ", INNER_H_HALF, " mm）"));
echo(str("総内高（組立時）:     ", 2 * INNER_H_HALF, " mm（BTN_DEPTH ", BTN_DEPTH, " mm に対して余裕 ", 2 * INNER_H_HALF - BTN_DEPTH, " mm）"));
echo(str("底面板厚:             ", BOT_T, " mm（ボタン穴・cbore・インサート穴が集中）"));
echo(str("内側ボス:             φ", BOSS_OD, " × H", BOSS_H, " mm（4箇所）"));
echo(str("インサート下穴:       φ", PILOT_D, " mm × ", PILOT_DEPTH, " mm 深（M3×φ", INSERT_OD, "×L", INSERT_L, " 熱圧入）"));
echo(str("位置合わせ凸凹:       楔 接線 ", WEDGE_TAN_BASE, "→", WEDGE_TAN_TIP, " × 法線 ", WEDGE_NORM, " × H", WEDGE_H, " mm / 凹 ", SOCK_TAN_OPEN, "→", SOCK_TAN_BOT, " × ", SOCK_NORM, " × ", SOCK_H, " mm（4壁各2点・点対称配置・接線クリア", SOCK_CLEAR, " mm／一定）"));
echo(str("配線穴:               φ", WIRE_D, " mm × 4壁（前後左右・合わせ面半円／連接対応）"));
echo(str("スナップフィット:      バンプ R", SNAP_BUMP_R, " / 受け穴 R", SNAP_HOLE_R, " × D", SNAP_HOLE_D, " mm（合わせ面・点対称2点・干渉クリック）"));
echo(str("ツイストロック:        タブ W", TWIST_TAB_W, " × H", TWIST_TAB_H, " × T", TWIST_TAB_T, " mm（前後壁外面・45°ひねりロック）"));
echo(str("ヘリカルランプ:        前後壁上端に傾斜 RAMP_H=", RAMP_H, "mm（90°ひねりZ引き込み）"));
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
} else if (render_part == 2) {
    // ツイスト確認: 下ハーフ正立 + 上ハーフを45°回転した「差し込み直前」状態
    // タブがスロットに合っているか目視確認用
    color("SteelBlue", 0.9) half_body();
    color("Orange", 0.7)
        translate([OUTER_W/2, OUTER_D/2, 2*HALF_H])
            rotate([0, 0, 45])
                translate([-OUTER_W/2, -OUTER_D/2, 0])
                    translate([OUTER_W, 0, 0])
                        rotate([180, 0, 180])
                            half_body();
} else if (show_section) {
    difference() {
        main_model();
        section_cut(cut_axis);
    }
} else {
    main_model();
}
