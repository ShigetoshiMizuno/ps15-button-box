// ============================================================
//  wedge_test.scad — 楔凸/凹 3案 目視比較テスト
//
//  目的: 「凹側の壁はいらない」解釈の目視判断
//  本番ファイル ps15_box.scad は変更しない
//
//  案A: socket 位置の壁を縦スロットで完全切り欠く
//  案B: socket を直方体切り欠き（テーパー無し）
//  案C: 凹を廃止し楔凸のみ（両位置に凸）
// ============================================================

/* ─── 共通パラメータ（本番と同値）─── */
WALL           = 2.5;
BOT_T          = 3.0;
HALF_H         = 23.5;
SEG_LEN        = 30.0;
WEDGE_TAN_BASE = 5.0;
WEDGE_TAN_TIP  = 4.0;
WEDGE_NORM     = WALL;
WEDGE_H        = 5.0;
SOCK_CLEAR     = 0.2;
SOCK_H         = 5.25;
SOCK_TAN_OPEN  = 5.4;
SOCK_TAN_BOT   = 4.4;
$fn = 48;

/* ─── 基本セグメント: 底板＋壁 ─── */
module wall_seg() {
    // 底板
    cube([SEG_LEN, WALL, BOT_T]);
    // 壁（底板の上）
    translate([0, 0, BOT_T])
        cube([SEG_LEN, WALL, HALF_H - BOT_T]);
}

/* ─── 楔凸（台形押出し、合わせ面から +Z 方向に突出）─── */
module wedge_bump(pos_x) {
    translate([pos_x, WALL/2, HALF_H])
        linear_extrude(height=WEDGE_H, scale=[WEDGE_TAN_TIP/WEDGE_TAN_BASE, 1])
            square([WEDGE_TAN_BASE, WEDGE_NORM], center=true);
}

/* ─── 案A: socket 位置の壁を縦スロットで完全切り欠く ─── */
module case_A() {
    difference() {
        union() {
            wall_seg();
            wedge_bump(SEG_LEN * 1/3);
        }
        // 縦スロット: 底板上面(Z=BOT_T)から合わせ面(Z=HALF_H)まで全高
        // 接線方向テーパー（下 SOCK_TAN_BOT → 上 SOCK_TAN_OPEN）
        translate([SEG_LEN * 2/3, WALL/2, BOT_T])
            linear_extrude(height=HALF_H - BOT_T + 0.1,
                           scale=[SOCK_TAN_OPEN/SOCK_TAN_BOT, 1])
                square([SOCK_TAN_BOT, WEDGE_NORM + 0.2], center=true);
    }
}

/* ─── 案B: socket を直方体切り欠き（テーパー無し）─── */
module case_B() {
    difference() {
        union() {
            wall_seg();
            wedge_bump(SEG_LEN * 1/3);
        }
        // 直方体切り欠き: 合わせ面から下に SOCK_H 分のみ
        translate([SEG_LEN * 2/3 - SOCK_TAN_OPEN/2, -0.1, HALF_H - SOCK_H])
            cube([SOCK_TAN_OPEN, WALL + 0.2, SOCK_H + 0.1]);
    }
}

/* ─── 案C: 凹廃止・楔凸のみ（接線 1/3 と 2/3 の両方に凸）─── */
module case_C() {
    wall_seg();
    wedge_bump(SEG_LEN * 1/3);
    wedge_bump(SEG_LEN * 2/3);
}

/* ─── ラベル ─── */
module label(txt) {
    translate([SEG_LEN/2, WALL/2, HALF_H + 10])
        linear_extrude(height=1)
            text(txt, size=6, halign="center", valign="center");
}

/* ─── 並置（X 方向に 40mm 間隔）─── */
// 案A: X = 0
translate([0, 0, 0]) {
    case_A();
    label("A");
}

// 案B: X = SEG_LEN + 40 = 70
translate([70, 0, 0]) {
    case_B();
    label("B");
}

// 案C: X = 2 * (SEG_LEN + 40) = 140
translate([140, 0, 0]) {
    case_C();
    label("C");
}
