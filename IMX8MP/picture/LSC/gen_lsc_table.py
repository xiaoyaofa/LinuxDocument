#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_lsc_table.py — 从匀光场帧生成 NXP ISP 的 17x17 LSC 增益表

前提：
  1. 采集时必须是"线性状态"（AWB 关 + 单位增益、CCM 单位矩阵、GAMMA 关、CPROC 关）
  2. BLC 已标定正确（黑位落在 limited-range 的 16）
  3. 光源已预热稳定（连抓 5 帧比值极差 < 1%）

数值约定（由 OS08A20 参考表反推确认）：
  - 数值是增益，Q10 定点：1024 = 1.0x
  - 归一化基准 = 最亮的那一点为 1024，其余点 > 1024
  - gain(x,y) = 1024 * I_max / I(x,y)

模式：
  --mode luma   （默认）只用 Y 通道的亮度阴影，4 个通道填同一张表
                 —— 能修掉主体衰减，但修不了色度阴影
                 —— 色度阴影需要中性匀光场（AWB 标定完成后再做）
  --mode rgb    从 YCbCr 反解 R/G/B，逐通道出表
                 ⚠️ 要求匀光场接近中性（|Cb-128|<3 且 |Cr-128|<3），否则结果不可信

用法：
  python gen_lsc_table.py 匀光场.yuv --raw 1920x1080 --mode luma --out lsc_table.txt
"""
import argparse
import numpy as np

GRID = 17
Q10 = 1024.0
BLACK = 16.0        # limited-range 黑位；BLC 标定后暗场就落在这里
SCALE = 255.0 / 219.0


def load_yuv(path, w, h):
    raw = np.fromfile(path, dtype=np.uint8)
    need = w * h * 2
    if raw.size < need:
        raise SystemExit("文件太小: %d < %d" % (raw.size, need))
    buf = raw[:need].reshape(h, w, 2)
    Y = buf[:, :, 0].astype(np.float64)
    Cb = buf[:, 0::2, 1].astype(np.float64)
    Cr = buf[:, 1::2, 1].astype(np.float64)
    return Y, Cb, Cr


def to_linear(v):
    """limited range -> 线性（去掉 16 的偏置）"""
    return np.clip((v - BLACK) * SCALE, 0.0, None)


def yuv_to_rgb(Y, Cb, Cr):
    y = to_linear(Y)
    cb = (Cb - 128.0) * (255.0 / 224.0)
    cr = (Cr - 128.0) * (255.0 / 224.0)
    cb = np.repeat(np.repeat(cb, 2, axis=1), 2, axis=0)[:Y.shape[0], :Y.shape[1]]
    cr = np.repeat(np.repeat(cr, 2, axis=1), 2, axis=0)[:Y.shape[0], :Y.shape[1]]
    R = y + 1.5748 * cr
    B = y + 1.8556 * cb
    G = y - 0.1873 * cr - 0.4681 * cb
    return R, G, B


def block17(img):
    h, w = img.shape
    ys = np.linspace(0, h, GRID + 1).astype(int)
    xs = np.linspace(0, w, GRID + 1).astype(int)
    out = np.zeros((GRID, GRID))
    for i in range(GRID):
        for j in range(GRID):
            blk = img[ys[i]:ys[i + 1], xs[j]:xs[j + 1]]
            out[i, j] = np.median(blk) if blk.size else 0.0
    return out


def to_gain(block):
    ref = np.percentile(block, 99)
    g = Q10 * ref / np.maximum(block, 1e-6)
    return g


def fmt(v):
    return "[" + " ".join("%.0f" % x for x in v.ravel()) + "]"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("frame")
    ap.add_argument("--raw", required=True, help="WxH")
    ap.add_argument("--mode", choices=["luma", "rgb"], default="luma")
    ap.add_argument("--out", default="lsc_table.txt")
    args = ap.parse_args()

    w, h = (int(x) for x in args.raw.lower().split("x"))
    Y, Cb, Cr = load_yuv(args.frame, w, h)
    lin = to_linear(Y)

    print("=" * 72)
    print("输入: %s   (%dx%d)   模式: %s" % (args.frame, w, h, args.mode))
    print("=" * 72)
    c = lin[h // 2 - 54:h // 2 + 54, w // 2 - 96:w // 2 + 96].mean()
    print("Y(线性化后): 全图 %.1f   中心 %.1f" % (lin.mean(), c))
    print("色度: Cb=%.1f  Cr=%.1f   (|偏差| %s)"
          % (Cb.mean(), Cr.mean(),
             "OK" if abs(Cb.mean() - 128) < 3 and abs(Cr.mean() - 128) < 3 else "偏色，rgb 模式不可信"))
    print()

    if args.mode == "luma":
        if abs(Cb.mean() - 128) > 3 or abs(Cr.mean() - 128) > 3:
            print("提示: 当前匀光场有色偏，亮度阴影不受影响，但算不了色度阴影。")
            print()
        blk = block17(lin)
        g = to_gain(blk)
    else:
        R, G, B = yuv_to_rgb(Y, Cb, Cr)
        blk = (block17(R) + 2 * block17(G) + block17(B)) / 4.0   # 按人眼亮度权重合成
        g = to_gain(blk)

    print("  LSC 增益表统计:")
    print("    min %.0f (=1.0x)   max %.0f (=%.2fx)   中心(8,8) %.0f"
          % (g.min(), g.max(), g.max() / Q10, g[8, 8]))
    corners = np.mean([g[0, 0], g[0, 16], g[16, 0], g[16, 16]])
    print("    四角均值 %.0f   相对中心 %.3f" % (corners, corners / g[8, 8]))
    print("    -> 反推边缘亮度衰减 %.3f（对应 cos^4 等效角 %.1f 度）"
          % (1 / (corners / g[8, 8]),
             np.degrees(np.arccos((1 / (corners / g[8, 8])) ** 0.25))))
    print()

    lines = ["# LSC 增益表（Q10，1024 = 1.0x，最亮点 = 1024）",
             "# 来源: %s" % args.frame,
             "# 模式: %s" % args.mode,
             "# ⚠️ 等分网格是否与 ISP 内部 LSC sectors 对齐需闭环验证", ""]
    for name in ("red", "greenR", "greenB", "blue"):
        lines.append('<LSC_SAMPLES_%s index="1" type="double" size="[17 17]">%s</LSC_SAMPLES_%s>'
                     % (name, fmt(g), name))
    open(args.out, "w", encoding="utf-8").write("\n".join(lines) + "\n")
    print("已写出:", args.out)
    print()
    print("闭环验证（必做）:")
    print("  1) 4 行 LSC_SAMPLES_* 替换进 XML 对应光源 profile（如 D65_100）")
    print('  2) vvext 2 "LSC ON/OFF" 1   然后  vvext 2 "PRELOAD" 1')
    print("  3) 重抓匀光场，看 四角/中心 是否接近 1.000")
    print("     偏离时把整表乘以 1/r 再试，通常 2~3 轮收敛到 5% 内")


if __name__ == "__main__":
    main()
