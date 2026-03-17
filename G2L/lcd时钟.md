drivers/gpu/drm/rcar-du/rcar_du_crtc.c
计算公式
Fvco =24Mhz x pl5_intin x ( pl5_postdiv1 / pl5_postdiv2)
Fout = Fvoc / ( 2x (dsi_div_a + 1) x (dsi_div_b + 1) )
2kHz < Fvco < 4096MHz

dsi_div_a分频只有1~16
dsi_div_b分频只有1 2 4 8
