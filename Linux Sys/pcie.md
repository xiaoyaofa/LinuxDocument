## 查看pcie总线
```
lspci -vv
```
查看单个pcie设备
```
lspci -vvs 01:00.0
```
## 信息说明
1. 设备标识行
```
00:00.0 PCI bridge: Synopsys, Inc. DWC_usb3 / PCIe bridge (rev 01) (prog-if 00 [Normal decode])
│     │            │              │                          │        │
│     │            │              │                          │        └─ 编程接口
│     │            │              │                          └─ 修订版本
│     │            │              └─ 设备名
│     │            └─ 厂商名
│     └─ 设备类型
└─ BDF: Bus:Device.Function
```
2. Control 寄存器
```
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
         │   │  │          │          │         │         │        │         │     │
         │   │  │          │          │         │         │        │         │     └─ 中断禁止
         │   │  │          │          │         │         │        │         └─ Fast B2B
         │   │  │          │          │         │         │        └─ Stepping
         │   │  │          │          │         │         └─ Parity Err
         │   │  │          │          │         └─ VGA Snoop
         │   │  │          │          └─ Memory Write Invalidation
         │   │  │          └─ Special Cycle
         │   │  └─ Bus Master (DMA 能力)
         │   └─ Memory space (内存映射访问)
         └─ I/O space (端口 I/O)
```
关键位：
```
位	含义
I/O+	启用 I/O 端口访问
Mem+	启用 Memory-mapped 访问
BusMaster+	启用 DMA（设备能主动发起读写）
SERR+	启用系统错误上报
DisINTx+	禁用传统 INTx 中断（用 MSI 替代）
```
3. Status 寄存器
```
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        │                                              │
        │                                              └─ DEVSEL: 设备响应速度
        └─ Cap: 有 Capabilities 列表（关键标志）
```
4. Latency
```
Latency: 0
└─ Timer 值，控制总线占用时间，0 = 用默认
```
5. Interrupt
```
Interrupt: pin A routed to IRQ 243
           │              │
           │              └─ 中断号（Linux 动态分配）
           └─ INTx 引脚（A/B/C/D）
```
6. Region（BAR，Base Address Register）
```
Region 0: Memory at 18000000 (32-bit, non-prefetchable) [size=1M]
          │                │       │                   │
          │                │       │                   └─ 大小
          │                │       └─ 类型
          │                │           - prefetchable: 可预取（一般是显存）
          │                │           - non-prefetchable: 不可预取（寄存器）
          │                └─ 地址位宽
          │                    - 32-bit / 64-bit
          └─ 内存/IO 映射

Region 0: I/O ports at ...    ← 端口 I/O
Region 0: Memory at ...      ← 内存映射
```
7. Bridge 信息（仅 Root Port）
```
Bus: primary=00, secondary=01, subordinate=ff, sec-latency=0
     │         │        │           │
     │         │        │           └─ 二级总线 latency
     │         │        └─ 下级总线最大值（ff 表示不限）
     │         └─ 二级总线号（下挂的设备总线）
     └─ 主总线号

I/O behind bridge: [disabled]            ← 桥后面 I/O 窗口
Memory behind bridge: 18100000-181fffff  ← 桥后面内存窗口
Prefetchable memory behind bridge: [disabled]
```
8. Power Management Capability
```
Capabilities: [40] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot+,D3cold+)
               │      │    │   │   │             │
               │      │    │   │   │             └─ 各电源状态支持 PME
               │      │    │   │   └─ 辅助电流
               │      │    │   └─ D2 状态支持
               │      │    └─ D1 状态支持
               │      └─ Device Specific Init
               └─ PME Clock
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        │  │          │           │        │
        │  │          │           │        └─ PME 状态
        │  │          │           └─ 数据 scale
        │  │          └─ PME 使能
        │  └─ 无软重置
        └─ 当前电源状态
            - D0: 全功率工作
            - D1/D2: 部分省电
            - D3hot: 深度省电（设备仍响应配置空间）
            - D3cold: 完全断电
```
9. MSI/MSI-X 中断
```
Capabilities: [50] MSI: Enable+ Count=1/1 Maskable+ 64bit-
              │            │     │      │      │
              │            │     │      │      └─ 64 位地址
              │            │     │      └─ 支持掩码
              │            │     └─ 当前/最大向量数
              │            └─ 启用状态
              └─ Capability offset
        Address: c0005000  Data: 0000
        └─ MSI 地址/数据

Capabilities: [d0] MSI-X: Enable+ Count=33 Masked-
             │             │      │     │
             │             │      │     └─ 掩码位
             │             │      └─ 当前/最大向量数
             │             └─ 启用状态
             └─ Capability offset
```
10. Express Capability（PCIe 核心）
```
Capabilities: [70] Express (v2) Root Port (Slot-), MSI 00
              │       │       │        │
              │       │       │        └─ 类型:
              │       │       │           - Root Port: PCIe 根端口（SoC 内部）
              │       │       │           - Endpoint: 端点设备（如 NVMe）
              │       │       │           - Switch Upstream/Downstream: 交换机
              │       │       └─ 是否是 Slot（插槽）
              │       └─ PCIe 规范版本
              └─ Capability offset
```
DevCap / DevCtl / DevSta
```
DevCap: MaxPayload 128 bytes    ← 最大 TLP 负载
        ExtTag- RBE+           ← 扩展 Tag, Relaxed Ordering
DevCtl: MaxPayload 128 bytes    ← 实际使用值
        MaxReadReq 512 bytes   ← 最大读请求
DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
        └─ 笼统错误状态（详细看 AER）
```
LnkCap / LnkCtl / LnkSta（链路能力/控制/状态）
```
LnkCap: Port #0, Speed 8GT/s, Width x1, ASPM L0s L1, Exit Latency L0s <1us, L1 <16us
        │       │           │          │                 │
        │       │           │          │                 └─ 退出延迟
        │       │           │          └─ ASPM 支持
        │       │           │              - L0s: 浅睡眠
        │       │           │              - L1: 深睡眠
        │       │           └─ 链路宽度
        │       └─ 链路速度
        │           - 2.5 GT/s = Gen1
        │           - 5 GT/s   = Gen2
        │           - 8 GT/s   = Gen3
        │           - 16 GT/s  = Gen4
        │           - 32 GT/s  = Gen5
        └─ 端口号

LnkCtl: ASPM Disabled     ← 当前 ASPM 设置
        RCB 64 bytes       ← Read Completion Boundary
        CommClk+           ← Common Clock（共用时钟）
        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        │
        └─ 自协商宽度禁用

LnkSta: Speed 8GT/s (ok), Width x1 (ok)
        │             │      │      │
        │             │      │      └─ 宽度状态
        │             │      │          - (ok): 协商到能力上限
        │             │      │          - (downgraded): 被降级（设备支持更多）
        │             │      │          - (0): 链路未建立
        │             └─ 速度状态
        └─ 链路状态总览

        TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt+
        │       │      │         │         │
        │       │      │         │         └─ 自适应带宽管理
        │       │      │         └─ 数据链路层活跃
        │       │      └─ 使用 Slot Clock
        │       └─ 训练中
        └─ 训练错误
```
DevCap2 / DevCtl2 / LnkCap2 / LnkCtl2 / LnkSta2
```
DevCap2: Completion Timeout: Range ABCD    ← 完成超时范围
         TimeoutDis+                       ← 超时可禁用
         LTR-                              ← Latency Tolerance Reporting
         10BitTagComp- 10BitTagReq-        ← 10-bit Tag

LnkCap2: Supported Link Speeds: 2.5-8GT/s  ← 支持的速度
         Crosslink- Retimer- 2Retimers-    ← 链路扩展

LnkCtl2: Target Link Speed: 8GT/s          ← 目标速度
         EnterCompliance- SpeedDis-        ← Compliance 模式

LnkSta2: Current De-emphasis Level: -6dB  ← 去加重（高频补偿）
         EqualizationComplete+             ← 均衡完成（Gen3 必需）
         EqualizationPhase1+ Phase2+ Phase3+ ← 均衡阶段
         LinkEqualizationRequest-           ← 请求重新均衡
         Retimer- 2Retimers-                ← Retimer 中继
```
11. AER (Advanced Error Reporting)
```
Capabilities: [100 v2] Advanced Error Reporting
        UESta:  ...                ← Uncorrectable Error Status（不可纠正）
                DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                │     │     │    │     │        │         │        │     │       │      │        │
                │     │     │    │     │        │         │        │     │       │      │        └─ ACS 违规
                │     │     │    │     │        │         │        │     │       │      └─ 不支持的请求
                │     │     │    │     │        │         │        │     │       └─ ECRC 错误
                │     │     │    │     │        │         │        │     └─ 畸形 TLP
                │     │     │    │     │        │         │        └─ 接收溢出
                │     │     │    │     │        │         └─ 意外的完成
                │     │     │    │     │        └─ 完成 abort
                │     │     │    │     └─ 完成超时
                │     │     │    └─ 流控协议错误
                │     │     └─ TLP poisoning
                │     └─ 发送端检测到的严重错误
                │     - 重发同样的 TLP 太多
                └─ 数据链路协议错误

        CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
                │      │       │        │         │        │
                │      │       │        │         │        └─ 高级非致命错误
                │      │       │        │         └─ 完成超时（带状态）
                │      │       │        └─ 总数计数器溢出
                │      │       └─ 坏 DLLP（链路层包）
                │      └─ 坏 TLP（事务层包）★ SI 问题
                └─ 接收错误 ★ SI 问题

        UEMsk/CEMsk: 掩码（屏蔽掉的错误不报）
        UESvrt/CESvrt: 哪些错误严重到要触发中断

        AERCap: First Error Pointer  ← 第一个错误的位置
                ECRCGenCap+/-         ← ECRC 生成能力
                ECRCChkCap+/-          ← ECRC 校验能力

        HeaderLog: 错误包内容（前几个字节）★ 排查关键
                   00000000 = 无错误记录
                   非 0 = 有错误时记录的包内容

        RootSta: CERcvd- MultCERcvd- UERcvd- MultUERcvd-
                 └─ Root 收到的错误消息

        ErrorSrc: ERR_COR: 0000 ERR_FATAL/NONFATAL: 0000
                  └─ 错误源 ID（哪个设备报的）
```
12. L1 PM Substates
```
Capabilities: [158 v1] L1 PM Substates
        L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2- ASPM_L1.1+ L1_PM_Substates+
                  │              │             │             │
                  │              │             │             └─ ASPM 触发的 L1.1
                  │              │             └─ ASPM 触发的 L1.2
                  │              └─ PM 触发的 L1.1
                  └─ PM 触发的 L1.2

                  PortCommonModeRestoreTime=10us  ← 公共模式恢复时间
                  PortTPowerOnTime=10us          ← T_POWER_ON 时间

        L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
                   └─ 当前是否启用各 L1 子状态

        L1SubCtl2: T_PwrOn=300us
                   └─ 实际配置的 T_POWER_ON 时间
```
```
子状态	进入方式	退出延迟
L1.0	ASPM 触发	短
L1.1	ASPM 触发，但保留 REFCLK	中
L1.2	PM 触发，关闭 REFCLK	长（最省电）
```
13. Latency Tolerance Reporting (LTR)
```
Capabilities: [100 v1] Latency Tolerance Reporting
        Max snoop latency: 0ns       ← 最大可容忍 snoop 延迟
        Max no snoop latency: 0ns    ← 最大可容忍 no snoop 延迟
        └─ 0 = 不限制
```
14. ARI (Alternative Routing-ID Interpretation)
```
Capabilities: [128 v1] Alternative Routing-ID Interpretation (ARI)
        ARICap: MFVC- ACS-, Next Function: 0
        ARICtl: MFVC- ACS-, Function Group: 0
```
15. Data Link Feature
PCIe 4.0+ 新增，用于描述数据链路层特性。
```
Capabilities: [1e0 v1] Data Link Feature <?>
```
16. Secondary PCI Express
```
Capabilities: [148 v1] Secondary PCI Express
        LnkCtl3: LnkEquIntrruptEn- PerformEqu-
                 │                  │
                 │                  └─ 执行均衡（重训）
                 └─ 均衡中断使能

        LaneErrStat: 0    ← ★ 每个 Lane 的错误状态位图
                       │   0 = 所有 lane 都好
                       │   非 0 = 有 lane 出错（按位对应）
                       └─ 单 lane 错误时能定位是哪条 lane
```
17. Kernel driver in use
```
Kernel driver in use: pcieport    ← Root Port 驱动
Kernel driver in use: nvme        ← NVMe 设备驱动
```

## 排查 PCIe 故障的标准流程
```
字段速查表（按重要性）
字段	        重要性	        看什么
LnkSta	        🔴 高	    链路速率/宽度协商
CESta (AER)	    🔴 高	    具体 PCI 错误（如 BadTLP）
DevSta	        🟡 中	    笼统错误状态
HeaderLog	    🟡 中	    错误包内容（深度排查）
LnkCap	        🟢 低	    能力上限（参考）
LnkSta2	        🟡 中	    Gen3 均衡状态
LaneErrStat	    🟡 中	    哪条 lane 有错
L1SubCtl1	    🟢 低	    L1 子状态配置
MSI Enable+	    🟢 低	    中断方式
```

```
# 1. 链路是否协商成功
lspci -vv | grep -E "LnkSta:"

# 2. 是否有错误
lspci -vv | grep -E "CESta|UESta|DevSta"

# 3. 详细看具体错误类型
lspci -vvs 00:00.0 | grep -A1 CESta    # Root Port
lspci -vvs 01:00.0 | grep -A1 CESta    # NVMe

# 4. 看错误包内容
lspci -vvs 00:00.0 | grep -A1 HeaderLog

# 5. 看 lane 错误分布
lspci -vvs 00:00.0 | grep LaneErrStat
```
查看错误计数
setpci -s 00:00.0 CAP_EXP+0x14.L=0xffffffff
## 读写测试
### 顺序读写30s
```
fio --name=seq \
    --rw=readwrite \
    --bs=1M \
    --size=1G \
    --direct=1 \
    --runtime=30 \
    --time_based=1 \
    --ioengine=libaio \
    --iodepth=32 \
    --filename=/run/media/nvme0n1/testfile
```
### 单独测顺序读
```
fio --name=seqread --rw=read --bs=1M --size=1G --direct=1 \
    --runtime=30 --time_based=1 \
    --ioengine=libaio --iodepth=32 \
    --filename=/run/media/nvme0n1/testfile
```
### 单独测顺序写
```
fio --name=seqwrite --rw=write --bs=1M --size=1G --direct=1 \
    --runtime=30 --time_based=1 \
    --ioengine=libaio --iodepth=32 \
    --filename=/run/media/nvme0n1/testfile
```