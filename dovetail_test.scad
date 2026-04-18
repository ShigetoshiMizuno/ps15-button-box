// dovetail_test.scad — 1壁面スケッチ（逆台形キー付き）
// ブランチ: feature/dovetail-slide
//
// 左壁1面のみ。合わせ面（Z=HALF_H）に逆台形の凸・凹を配置。

$fn = 32;

/* ─── 寸法（本体と共通）─── */
WALL   = 2.0;
HALF_H = 23.5;
WALL_Y = 47.0;   // 壁の奥行き（OUTER_D）

/* ─── 逆台形キーのパラメータ ─── */
KEY_BASE = 8.0;   // 根元幅（合わせ面側・狭い）
KEY_TIP  = 10.0;  // 先端幅（広い）
KEY_NORM = WALL;  // 法線方向（壁厚と同じ）
KEY_H    = 5.0;   // 凸の高さ

SOCK_CLEAR = 0.2;           // 片側クリアランス
SOCK_H     = KEY_H + 0.25;  // 凹の深さ

/* ─── 逆台形 凸（根元狭・先端広）─── */
module key_bump() {
    linear_extrude(height = KEY_H, scale = [KEY_TIP / KEY_BASE, 1])
        square([KEY_BASE, KEY_NORM], center = true);
}

/* ─── 逆台形 凹（開口狭・奥広）─── */
// linear_extrude は「底面 → 上面」の向きで scale が効く。
// 奥（Z=-SOCK_H）に広い deep_w を置き、上面（Z=0、合わせ面）で open_w に絞る。
module key_socket() {
    open_w = KEY_BASE + 2 * SOCK_CLEAR;  // 開口幅 = 根元幅 + クリア（狭い）
    deep_w = KEY_TIP  + 2 * SOCK_CLEAR;  // 奥幅   = 先端幅 + クリア（広い）
    translate([0, 0, -SOCK_H])
        linear_extrude(height = SOCK_H + 0.1, scale = [open_w / deep_w, 1])
            square([deep_w, KEY_NORM], center = true);
}

/* ─── 壁1面（左壁）─── */
module one_wall() {
    difference() {
        // 壁本体
        cube([WALL, WALL_Y, HALF_H]);

        // 凹（合わせ面 Z=HALF_H に開口）
        translate([WALL / 2, WALL_Y * 3/4, HALF_H])
            rotate([0, 0, 90])
                key_socket();
    }

    // 凸（合わせ面 Z=HALF_H から突出）
    translate([WALL / 2, WALL_Y / 4, HALF_H])
        rotate([0, 0, 90])
            key_bump();
}

one_wall();

echo(str("逆台形キー: 根元 ", KEY_BASE, " mm → 先端 ", KEY_TIP, " mm / 高さ ", KEY_H, " mm"));
echo(str("凹: 開口 ", KEY_BASE + 2*SOCK_CLEAR, " mm（狭）→ 奥 ", KEY_TIP + 2*SOCK_CLEAR, " mm（広）/ 深さ ", SOCK_H, " mm"));
echo("※ 凹み形状が逆台形（開口狭・奥広）→ Z方向には抜けない（アンダーカット）");
