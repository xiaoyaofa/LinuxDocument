drivers/dma/ti/k3-psil-am62.c

static struct psil_ep am62_src_ep_map[]
添加
```

/* PDMA_MAIN0 - SPI0-2 */
PSIL_PDMA_XY_PKT(0x4300),
PSIL_PDMA_XY_PKT(0x4301),
```
删除
```
PSIL_PDMA_XY_PKT(0x430c),
PSIL_PDMA_XY_PKT(0x430d),
```
static struct psil_ep am62_dst_ep_map[]
添加
```

/* PDMA_MAIN0 - SPI0-2 */
PSIL_PDMA_XY_PKT(0xc300),
PSIL_PDMA_XY_PKT(0xc301),
```
删除
```
PSIL_PDMA_XY_PKT(0xc30c),
PSIL_PDMA_XY_PKT(0xc30d),
```
