# eARC / ARC / CEC 测试说明

**适用板卡**：MYS-8MP-8E2D-180-C-SRS
**登录方式**：`ssh root@192.168.1.37`（有线）或 `ssh root@192.168.10.72`（WiFi，DHCP 分配，IP 可能变化）

**文档结构**：按 **CEC / ARC / eARC** 三个功能块组织，每块自成闭环（切换 → 操作 → 验证 → 注意事项）。通用部分在第一节。

---

# 背景知识：HDMI 上的三类功能

> 本节帮助理解三个测试项分别属于 HDMI 的哪个部分。**不涉及操作**，熟悉的话可直接跳到第一节。

HDMI 线可以理解成一根**多芯电缆**，同时传四类信号：

```
┌─ 视频通道  ──►  传画面              ← 4Kx2K 说的是这条
├─ 音频通道  ──►  传声音（板子→电视）
├─ 控制通道  ←─►  传指令              ← CEC 说的是这条
└─ 回传通道  ◄──  电视把声音送回来      ← ARC / eARC 说的是这条（唯一反向的）

普通 HDMI 音频：  板子/机顶盒 ──声音──► 电视      （正向）
ARC / eARC：      电视 ──声音──► 板子/音响        （反向！）
```

## 三个功能分别是什么

**① 4Kx2K —— 属于「画面」部分**

说的是 HDMI 输出的**分辨率和刷新率**。这是视频通道的能力，和音频、控制互不影响。

> 本板支持 **4Kx2K@24/25/30Hz**（像素时钟 297 MHz，正是芯片上限）；**不支持 4K@50/60**（需 594 MHz，超出 PHY 能力）。

**② CEC —— 属于「指令」部分**

HDMI 上的设备间**控制协议**，用来传指令：开关机、切换输入源、遥控器透传等。

> 需要先"注册设备"（申请逻辑地址）才能收发。**板子的驱动只提供收发通道，协议逻辑需应用层实现**（业界通行做法，见 `cec-follower` 参考实现）。

**③ ARC / eARC —— 属于「声音回传」部分**

HDMI 的**音频回传通道**，把**电视自己的声音反向送出来**给音响/功放。

> ⚠️ **注意方向是反的**：普通 HDMI 音频是"播放设备 → 电视"，而 ARC 是"电视 → 音响"。
> **eARC 是 ARC 的升级版**，带宽大得多，能传未压缩的多声道音频。

## 三者的独立性

> ⚠️ **唯一的依赖关系**：**ARC 的建立必须走 CEC**，而 **eARC 不需要 CEC**（能力协商走它自己的专用通道）。其余互不影响，三类功能可各自单独测。

---

# 一、测试前准备（通用）

## 1.1 硬件准备

1. 电视或功放必须支持 **eARC 或 ARC**，并在菜单里**打开对应开关**（一般还要同时打开 CEC）。
2. HDMI 线要插在电视上**标注 eARC / ARC 的那个口** —— **不同电视口位不同，务必看清机身丝印**（有的标 eARC、有的只标 ARC，也有的在 HDMI 3 而不是 HDMI 2）。

   > ⚠️ **插错口的典型症状**：CEC 申请逻辑地址失败、CEC 发送报 `Tx, Error`；ARC/eARC 完全测不到。
   >
   > **如何确认插对了口**：读 `phys_addr` —— `x.0.0.0` 的 x 就是电视上的口位（如 `3.0.0.0` = HDMI 3）。
   >
3. 电视上要**有声音在播放**，否则测不到数据。
4. **耳机插到板子的耳机孔** —— 测音频通路时靠它听声音。

## 1.2 板子准备

**停掉出厂演示服务** —— 它们会占住板载声卡，导致 `aplay` 报 `Device or resource busy`：

```sh
systemctl stop playvideo.service playcamera.service record.service
```

> `playvideo.sh` 是**死循环**放歌（`while [ true ]; do aplay song.wav; done`），光杀进程没用，必须停服务。
> **板子每次重启后会恢复**，建议 `systemctl disable` 掉。

## 1.3 模式总览

音频模式由 ALSA 控件 `XCVR Mode` 控制，**三选一**：

| 值         | 模式             | 说明                                                  |
| ---------- | ---------------- | ----------------------------------------------------- |
| `SPDIF`  | SPDIF            | **开机默认**。本板 SPDIF 引脚未引出，实际不可用 |
| `ARC RX` | ARC（HDMI 1.4）  | 经典 ARC，**建立必须走 CEC**                    |
| `eARC`   | eARC（HDMI 2.1） | 增强 ARC，走 CMDC，**不需要 CEC**               |

```sh
# 查看当前模式
amixer -c imxaudioxcvr sget 'XCVR Mode'
```

**两者不会自动切换** —— 电视只支持 ARC 时必须**手动**切到 `ARC RX`；选 eARC 不会自动退回去。

### 支持的规格

**测极限参数时特别注意** —— 两种模式支持的范围不同：

| 模式 | 声道数                                          | 采样率                                                                                                                                 |
| ---- | ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| eARC | **只有 1、2、8、16、32**（6 / 12 不支持） | 32k / 44.1k / 48k / 64k / 88.2k / 96k / 128k / 176.4k / 192k / 256k / 352.8k / 384k / 512k / 705.6k / 768k / 1.024M / 1.4112M / 1.536M |
| ARC  | **只有 2**                                | 32k / 44.1k / 48k / 88.2k / 96k / 176.4k / 192k                                                                                        |

## 1.4 三条通用禁忌

1. **切换模式前不能有流在跑** —— 否则控件被置只读，切换失败：

   ```sh
   ps aux | grep -E "[a]record|[a]play"
   ```
2. **ARC / eARC 模式只能录音，不能播放**
   `aplay` 会报「找不到播放设备」，**这是正常的，不是故障**。需要播放请切回 `SPDIF`。
3. **录音设备名必须写 `sysdefault:CARD=imxaudioxcvr`**
   写成 `default:CARD=imxaudioxcvr` 会直接报错。

---

# 二、CEC 测试

## 2.1 前置：HDMI 必须先接好

> **CEC 的物理地址来自对端 HDMI 设备的 EDID。HDMI 没接好，CEC 根本无法工作。**

这是实机验证过的依赖链：

```
HDMI 连接 → 读到 EDID → phys_addr 有效 → 才能申请逻辑地址 → CEC 才能收发
```

**每次测试前，先执行这一条确认：**

```sh
cat /sys/kernel/debug/cec/cec0/status | head -5
```

| 看到                                  | 含义                                            | 处理                                        |
| ------------------------------------- | ----------------------------------------------- | ------------------------------------------- |
| `phys_addr: f.f.f.f`                | **HDMI 未连接或对端 EDID 不含 HDMI VSDB** | 检查 HDMI 线；换一个支持 HDMI 的显示器/电视 |
| `phys_addr: 1.0.0.0`（其他非 f 值） | 正常                                            | 继续                                        |

> ⚠️ **对端必须是真正的 HDMI 设备（EDID 里含 HDMI VSDB）。**
> **DVI 显示器**（用 DVI→HDMI 线）、**VGA→HDMI 转换器**、部分 HDMI 分配器**不提供 VSDB**，会导致 `phys_addr` 一直是 `f.f.f.f`，CEC 全部失败。

> ⚠️ **一个很隐蔽的陷阱**：如果 HDMI 没接好就执行下面的配置命令，命令会**返回成功**，但状态是 `enabled: 1` + `configured: 0`、`LA mask: 0x0000` —— **看起来配好了，实际一个逻辑地址都没申请到**，后面所有 CEC 测试必然失败。
> 好消息是：HDMI 后来接上时，系统会**自动补全**逻辑地址申请，不必重跑命令。

## 2.2 配置 CEC

> **HDMI CEC 没有"测试模式"开关。** 板子开机后 CEC 适配器处于**未启用**状态，必须先配置才能收发消息 —— **这是 CEC 测试失败最常见的原因**。

**检查当前状态：** 看 2.1 读出的那份状态（同一条命令）。如果 `enabled: 0` 或 `number of LAs: 0`，说明还没配置，此时 CEC **既不能发也不能收**。

**配置命令：**

```sh
# 推荐：板子作为「播放设备」（HDMI 源端角色）
cec-ctl -d /dev/cec0 --playback

# ARC / eARC 场景推荐：附带声明「支持 ARC Rx」能力
cec-ctl -d /dev/cec0 --playback --feat-source-has-arc-rx --osd-name "IMX8MP"

# 若要模拟「音响 / 功放」（ARC 接收端角色）
cec-ctl -d /dev/cec0 --audio --osd-name "IMX8MP-Audio"
```

**角色说明：**

板子是 HDMI **输出端**（TX），在 CEC 总线上扮演**播放设备**或**音响**；**对端电视不需要任何配置**，它本来就是 TV。

| 角色               | 命令           | 申请到的逻辑地址 | 适用场景                                                                |
| ------------------ | -------------- | ---------------- | ----------------------------------------------------------------------- |
| **播放设备** | `--playback` | 4 / 8 / 11       | **默认推荐** —— 板子作为 HDMI 源端                              |
| **音响**     | `--audio`    | 5                | 模拟音响 / 功放（ARC 接收端角色）                                       |
| 调谐器             | `--tuner`    | 6 / 7            | 按测试需要                                                              |
| 电视               | `--tv`       | 0                | ⚠️ **不要用** —— TV 由对端担任，板子没有 HDMI 输入，做不了 TV |

> 申请到哪个逻辑地址由 CEC 规范决定，同类型有多个地址时会自动挑一个空闲的。上面列出的地址即实测结果。

**确认配置成功：**

```sh
cat /sys/kernel/debug/cec/cec0/status        # 应显示 enabled: 1、number of LAs: 1
cec-ctl -d /dev/cec0 --list-devices
```

配置成功后板子会自动向电视广播 `REPORT_PHYSICAL_ADDRESS` 和 `DEVICE_VENDOR_ID` 消息，属正常现象。

**清除配置：**

```sh
cec-ctl -d /dev/cec0 -C
```

## 2.3 常规 CEC 功能测试（板子作 HDMI 源端）

> **前提**：对端必须是**支持 CEC 的电视**，且电视端已开启 CEC（各厂商叫法不同，见 [5.3 CEC 不工作时检查](#53-cec-不工作时检查)）。
> **显示器通常不支持 CEC**，接显示器测会全部失败。

按顺序执行以下步骤。

**步骤 1 — 配置板子为播放设备**

```sh
cec-ctl -d /dev/cec0 --playback --osd-name "IMX8MP"
```

**步骤 2 — 确认电视被识别**

```sh
cec-ctl -d /dev/cec0 --show-topology
```

预期能在拓扑里看到电视（逻辑地址 0）：

```
	Topology:

	    1.0.0.0: TV
	    1.0.0.0: Playback Device 1        ← 板子自己
```

> ⚠️ **如果只看到板子自己**，说明电视端 CEC 没开、线缆不支持、或对端是显示器。先解决这一项再往下测。

**步骤 3 — 查询电视电源状态**

```sh
cec-ctl -d /dev/cec0 --to 0 --give-device-power-status
```

电视正常应答时的输出：

```
Transmit from Playback Device 1 to TV (4 to 0):
GIVE_DEVICE_POWER_STATUS (0x8f)
	Sequence: 40 Tx Timestamp: ...
	Rx, Report Power Status
```

电视无应答时的输出：

```
	Tx, Not Acknowledged (4), Max Retries
```

> 看到 `Not Acknowledged` 就说明**电视端 CEC 没有开启**或链路有问题，不是板子的故障。

**步骤 4 — One Touch Play（电视自动切到本输入）**

```sh
cec-ctl -d /dev/cec0 --to 0 --image-view-on
```

预期：电视自动开机，并切换到板子所在的 HDMI 输入。

**步骤 5 — 监视总线**

```sh
cec-ctl -d /dev/cec0 -m
```

然后操作电视遥控器或电视菜单，终端应能看到往来的 CEC 报文。按 `Ctrl+C` 退出。

限定监视时长（例如 30 秒）：

```sh
cec-ctl -d /dev/cec0 -m --monitor-time 30
```

**步骤 6 — 测试结束，清除配置**

```sh
cec-ctl -d /dev/cec0 -C
```

## 2.4 发送 CEC 消息

> 所有发送命令都需要先完成 2.2 的配置。

```sh
# 让电视进入待机
cec-ctl -d /dev/cec0 --to 0 --standby

# 唤醒电视（并切到本输入）
cec-ctl -d /dev/cec0 --to 0 --image-view-on

# 查询电视电源状态
cec-ctl -d /dev/cec0 --to 0 --give-device-power-status

# 查询电视的名称
cec-ctl -d /dev/cec0 --to 0 --give-osd-name

# 查询电视的厂商 ID
cec-ctl -d /dev/cec0 --to 0 --give-device-vendor-id

# 查询电视的物理地址
cec-ctl -d /dev/cec0 --to 0 --give-physical-addr

# Ping（探测某逻辑地址是否存在）
cec-ctl -d /dev/cec0 -P --to 0
```

`--to 0` 中的 `0` 是目标逻辑地址，TV 固定为 `0`；**不加 `--to` 就是广播**。

**诊断 / 观察类：**

```sh
cec-ctl -d /dev/cec0 --list-devices     # 适配器完整状态     ★ 最常用
cec-ctl -d /dev/cec0 -S                 # 拓扑：总线上有哪些设备
cec-ctl -d /dev/cec0 -m                 # 监视报文（Ctrl+C 退出）
cec-ctl -d /dev/cec0 -v -m              # 带详细字段解析
```

## 2.5 合规性测试

```sh
cec-compliance -d /dev/cec0
```

按提示逐项执行。**运行前请先完成 2.2 的配置**。

## 2.6 CEC 注意事项

| 项目                       | 说明                                                                                 |
| -------------------------- | ------------------------------------------------------------------------------------ |
| 配置是**运行时状态** | **重启后失效**，每次开机都要重新执行 2.1 + 2.2                                 |
| HDMI 线断开后失效          | 物理地址来自 EDID，拔线后 `phys_addr` 变回 `f.f.f.f`、逻辑地址被清空，需重新配置 |
| 可选的设备类型             | 见 [2.2 配置 CEC](#22-配置-cec) 的角色说明表。板子用 `--playback` 或 `--audio`，**不要用 `--tv`** |
| 手动发送消息               | 不需要常驻进程，`cec-ctl` 执行完即退出                                             |
| **ARC 测试**         | ⚠️ **必须常驻 `cec-follower`**，否则对端发来的 ARC 消息无人应答，见 [3.2 关键：必须运行 cec-follower](#32-关键必须运行-cec-follower)    |
| 其它自动响应               | 需要常驻 `cec-follower`                                                            |

---

# 三、ARC 测试

> **ARC = Audio Return Channel（HDMI 1.4）**
> 电视把自身音频沿 HDMI 线回传给音频设备。**建立过程必须走 CEC**（`INITIATE_ARC` → `REPORT_ARC_INITIATED`），这是与 eARC 最大的区别。

## 3.1 切换命令

```sh
amixer -c imxaudioxcvr cset name='XCVR Mode' 'ARC RX'
amixer -c imxaudioxcvr cset name='ARC Mode' 'Single Ended'
```

若测不到数据，把第二条换成下面这条再试：

```sh
amixer -c imxaudioxcvr cset name='ARC Mode' 'Common'
```

> ⚠️ `ARC RX` 和 `Single Ended` 中间有空格，**引号不能去掉**。

**确认切换成功：**

```sh
amixer -c imxaudioxcvr sget 'XCVR Mode'      # 应显示 Item0: 'ARC RX'
```

**切回默认模式：**

```sh
amixer -c imxaudioxcvr cset name='XCVR Mode' SPDIF
```

## 3.2 关键：必须运行 cec-follower

> **这是 ARC 测试能否通过的关键。**
> 板子的内核和驱动**都不实现 ARC 消息的协议应答** —— 必须由用户态的 `cec-follower` 负责。
> **没有它，对端发 ARC 消息过来不会有任何回应**，测试会报「CEC 消息里没有进入/退出 ARC 的信息」。

三个组件各司其职，缺一不可：

| 组件                            | 职责                         | 是否需手动启动       |
| ------------------------------- | ---------------------------- | -------------------- |
| 内核 CEC 框架 + `dw-hdmi-cec` | CEC 物理层收发               | 自动                 |
| **`cec-follower`**      | **ARC 消息的协议应答** | **需要，常驻** |
| `fsl_xcvr`                    | ARC 音频通道                 | 自动                 |

> ⚠️ `cec-follower ... &` 是随 SSH 窗口起的，**窗口一关就被杀**。稳妥写法：

```sh
setsid nohup cec-follower -d /dev/cec0 > /tmp/cec-follower.log 2>&1 < /dev/null &
```

## 3.3 完整测试流程

```sh
# ① 确认 HDMI 已接、物理地址有效（见 [2.1 前置：HDMI 必须先接好](#21-前置hdmi-必须先接好)，这一步不能跳过）
cat /sys/kernel/debug/cec/cec0/status | head -5      # phys_addr 不能是 f.f.f.f

# ② 配置 CEC，并声明「支持 ARC Rx」能力
cec-ctl -d /dev/cec0 --playback --feat-source-has-arc-rx --osd-name "IMX8MP"

# ③ 启动 cec-follower 常驻 —— 关键！它负责应答 ARC 消息
setsid nohup cec-follower -d /dev/cec0 > /tmp/cec-follower.log 2>&1 < /dev/null &

# ④ 切换到 ARC 音频模式
amixer -c imxaudioxcvr cset name='XCVR Mode' 'ARC RX'
```

**确认 ARC 能力已正确声明：**

```sh
cec-ctl -d /dev/cec0 --list-devices | grep -A2 "Device Features"
```

预期输出：

```
	    Device Features        :
		Source Supports ARC Rx
```

**验证发送通路：**

```sh
cec-ctl -d /dev/cec0 --to 0 --initiate-arc
```

板子能正常发出 ARC 消息时，输出如下（**对端是显示器等非 CEC 设备时，到这里为止就算通过**）：

```
Transmit from Playback Device 1 to TV (4 to 0):
INITIATE_ARC (0xc0)
	Sequence: 35 Tx Timestamp: ...
	Tx, Not Acknowledged (4), Max Retries
```

对端是真正的 CEC 电视并已开启 CEC 时，应能看到对方返回 `REPORT_ARC_INITIATED` 而不是 `Not Acknowledged`。

**`cec-follower` 支持的 ARC 消息**（六条全部支持，已在板上验证）：

`INITIATE_ARC`、`REPORT_ARC_INITIATED`、`TERMINATE_ARC`、`REPORT_ARC_TERMINATED`、`REQUEST_ARC_INITIATION`、`REQUEST_ARC_TERMINATION`

**停止 follower：**

```sh
pkill cec-follower
```

## 3.4 ATC 交互式用例的配合方式（最容易踩的坑）

**ATC 的 ARC 用例是「交互式」的** —— 每个用例会弹窗提示需要 DUT 发出哪条消息：

```
User Action
Invoke the DUT to send an <Initiate ARC> message, and follow the instruction:
          Then continue by pressing OK
```

**这不是要求板子自动发送，而是要求操作员手动触发。** 此时需要执行对应命令，让板子把消息发出去。

**操作四步（顺序不能反）：**

| 步骤 | 动作                                          |
| ---- | --------------------------------------------- |
| 1    | ATC 弹出 `User Action` 对话框               |
| 2    | **先执行**对应命令（见下方对照表）      |
| 3    | **看 ATC trace 面板**，确认出现了该消息 |
| 4    | **确认后再点 OK**                       |

> ⚠️ **提前执行无效。** `cec-ctl` 是一次性发送，发完即结束；ATC 只在弹窗那个时点开始监听，**提前发等于白发**。

**弹窗原文 → 命令对照表：**

| ATC 弹窗要求发送                                   | 执行命令                                                  |
| -------------------------------------------------- | --------------------------------------------------------- |
| `<Initiate ARC>`                                 | `cec-ctl -d /dev/cec0 --to 0 --initiate-arc`            |
| `<Report ARC Initiated>`                         | `cec-ctl -d /dev/cec0 --to 0 --report-arc-initiated`    |
| `<Report ARC Terminated>`                        | `cec-ctl -d /dev/cec0 --to 0 --report-arc-terminated`   |
| `<Request ARC Initiation>`                       | `cec-ctl -d /dev/cec0 --to 0 --request-arc-initiation`  |
| `<Request ARC Termination>`                      | `cec-ctl -d /dev/cec0 --to 0 --request-arc-termination` |
| `<Terminate ARC>`                                | `cec-ctl -d /dev/cec0 --to 0 --terminate-arc`           |
| `<Standby>`（**非 ARC**，属 CEC 通用消息） | `cec-ctl -d /dev/cec0 --to 0 --standby`                 |
| `<Image View On>`（通用）                        | `cec-ctl -d /dev/cec0 --to 0 --image-view-on`           |

> 用法很简单：**照抄弹窗里的 `<XXX>`，对照本表找命令即可。**

> 补充说明：ARC 那六条分为「进入」「退出」两组，每组三个角色（主动执行 / 请求对方 / 报告结果）——
> **进入 ARC**：`--initiate-arc` (0xC0) / `--request-arc-initiation` (0xC3) / `--report-arc-initiated` (0xC1)
> **退出 ARC**：`--terminate-arc` (0xC5) / `--request-arc-termination` (0xC4) / `--report-arc-terminated` (0xC2)

**发送成功时，ATC trace 面板应新增：**

```
R  xx:xx:xx.xxx  Playback Device 1 ==> TV   INITIATE_ARC          40
R  xx:xx:xx.xxx  TV ==> Playback Device 1   ReportARCInitiated    c1
```

第一行是 DUT 发出的消息（`40` = 0xC0 的原始载荷），第二行是对端应答。**看不到第一行，就说明命令没执行或时机不对。**

## 3.5 ARC 注意事项

1. **ARC 建立必须走 CEC** —— 若 CEC 不通（申请不到逻辑地址、`Tx, Error`），ARC 也必然失败。先按 [第二节 CEC 测试](#二cec-测试) 把 CEC 调通。
2. **对端必须是支持 ARC 的电视**，且插在**标注 ARC 的口**。显示器不支持。
3. **ARC 带宽上限低**：只有 2 声道、最高 192 kHz（对比 eARC 的 32 声道 / 1.536 MHz）。
4. `ARC Mode` 的 `Single Ended` / `Common` 二选一，一种不通就换另一种（取决于电视端 ARC 的电气实现）。

---

# 四、eARC 测试

> **eARC = Enhanced Audio Return Channel（HDMI 2.1）**
> 相比 ARC 带宽大幅提升（未压缩 7.1 / TrueHD / Atmos）。**能力协商走 CMDC（eARC 数据通道），由 XCVR 内置固件处理，不需要 CEC。**

## 4.1 切换命令

```sh
amixer -c imxaudioxcvr cset name='XCVR Mode' eARC
```

**确认切换成功：**

```sh
amixer -c imxaudioxcvr sget 'XCVR Mode'      # 应显示 Item0: 'eARC'
```

**切回默认模式：**

```sh
amixer -c imxaudioxcvr cset name='XCVR Mode' SPDIF
```

> ⚠️ **不要照抄 NXP 文档的 `amixer -c 0 cset numid=1 2`！**
> 在 NXP EVK 上 XCVR 是 card 0，但在本板是 **card 3**。card 0 的 `numid=1` 是 `PCM Playback Volume`，执行后会**把音量压到 2/192（几乎静音）**，而 eARC 模式**根本没切**。

## 4.2 CDS（Capabilities Data Structure，能力描述符）

### 当前状态（均为实测结果）

| 项目                     | 结果                                                 |
| ------------------------ | ---------------------------------------------------- |
| **eARC 链路建立**  | ✅ 已通 —— 分析仪捕获 **141937 个 eARC bit** |
| CAP_CHNG 能力协商握手    | ✅ 通过                                              |
| CMDC 通道复位            | ✅ 完成（`EXT_STATUS` bit23 `RX_CMDC_RSTO` = 1） |
| COMMA 时序               | ✅ 4.52 ms（规范上限 200 ms）                        |
| **CDS 能力描述符** | ❌ **内容为空 —— 当前唯一阻塞项**            |

### CDS 是什么

板子通过 eARC 通道发给电视/分析仪的一张「能力清单」，声明本机支持哪些音频格式（声道数 / 采样率 / 压缩格式）。驱动把它当作 **256 字节的黑盒**：只提供读写接口，**不生成任何内容**（`cap_ds[]` 出厂默认全 0）。

### 写入 CDS 的方法

```sh
# ① 必须先切到 eARC 模式（其它模式下该控件只读）
amixer -c imxaudioxcvr cset name='XCVR Mode' eARC

# ② 写入 256 字节
HEAD="0x01,0x01,0x1d,0x38,0x09,0x0f,0x07,0x0f,0x7f,0x07,0x67,0x7e,0x03,0x57,0x04,0x03,0x15,0x07,0x50,0x5f,0x7f,0x01,0x3e,0x06,0xc0,0x4d,0x02,0x00,0x83,0x4f,0x00,0x00"
TAIL=$(printf "0x00,%.0s" $(seq 1 224)); TAIL=${TAIL%,}
amixer -c imxaudioxcvr cset iface=PCM,name='Capabilities Data Structure' "$HEAD,$TAIL"

# ③ 回读校验（应为 256 字节、29 个非零）
amixer -c imxaudioxcvr cget numid=3
```

### ⚠️ 顺序不能反 —— 这是最容易做错的

```
① 切 eARC 模式  →  ② 写 CDS  →  ③ 开流 arecord  →  ④ 跑测试
                                    ↑
                    CDS 只在这一步才真正进 XCVR（固件加载时）
```

| 错误做法          | 后果                                          |
| ----------------- | --------------------------------------------- |
| 先开流再写 CDS    | 控件已变只读，`amixer` 报 Permission denied |
| 写了 CDS 但没开流 | CDS 只在驱动内存里，**XCVR 侧仍是全 0** |
| 开流后改了 CDS    | 改动要等**下一次开流**才生效            |

> **一旦写入，只要板子不重启就一直有效**（`cap_ds[]` 存在驱动内存里，每次开流自动重新加载）。**板子重启后失效，需重写。**

### 若不通过，逐个试 CDS 变体

板载脚本可快速切换（改一个字节换一种排布假设）：

```sh
/root/cds.sh a    # 当前版本（默认）
/root/cds.sh b    # 备选排布
/root/cds.sh c    # 备选 End marker
/root/cds.sh d    # 备选 End marker
/root/cds.sh 0    # 清零
/root/cds.sh show # 只读回显
```

> **若所有变体均不通过**：CDS 的字节格式定义在**非公开的 HDMI 2.1 规范（Table 9-42）**，无开源实现可参考，测试机构也只能提供解析后的字段表。此时需由 **NXP 或 Simplay Labs 提供 CDS 的 byte-map 或参考样本**，请协助向对应厂商反馈。

## 4.3 音频通路测试

**请开两个 SSH 窗口**，一个负责录音，另一个负责观察数据。

### 窗口 1：启动录音

```sh
timeout 60 arecord -D sysdefault:CARD=imxaudioxcvr -f dat -d 60 /tmp/test.wav
```

> **`timeout` 一定不能去掉。**
> 如果电视没送数据过来，`arecord` 会一直卡住不返回、也不报错。不加 `timeout` 只能按 Ctrl+C 强行退出。

> **建议顺序：先在窗口 1 启动录音，再去电视端打开 eARC 开关。**
> 驱动需要先开始接收，电视端后开 eARC 更容易握手成功。如果一次没通，可以把电视端的 eARC 关掉再打开一次。

**备选：NXP 官方环路方式**（把 eARC 音频实时转发到板载声卡，用耳机听）

```sh
arecord -Dsysdefault:CARD=imxaudioxcvr -c2 -r48000 -fs32_LE -twav \
  | aplay -Dsysdefault:CARD=imx8mpsgtl5000s
```

> 这条会一直占用终端，属正常。**一旦 Ctrl+C，链路就断了。**

### 窗口 2：录音进行中观察计数器

```sh
cat /sys/devices/platform/soc@0/30c00000.bus/30c00000.spba-bus/30cc0000.xcvr/counters/rx_bitcnt
```

**每隔约 5 秒执行一次，连续读三次**，比较数字：

```sh
cat /sys/devices/platform/soc@0/30c00000.bus/30c00000.spba-bus/30cc0000.xcvr/counters/rx_bitcnt
sleep 5
cat /sys/devices/platform/soc@0/30c00000.bus/30c00000.spba-bus/30cc0000.xcvr/counters/rx_bitcnt
sleep 5
cat /sys/devices/platform/soc@0/30c00000.bus/30c00000.spba-bus/30cc0000.xcvr/counters/rx_bitcnt
```

> ⚠️ **必须在录音进行中读**（也就是窗口 1 的 `arecord` 还没结束时）。
> 录音结束后设备会自动休眠，此时再读**一定是 0**，这是正常现象，不能当作"没收到数据"。

## 4.4 结果判定

| 看到的情况                                       | 说明                                |
| ------------------------------------------------ | ----------------------------------- |
| 数字**持续变大**，录音文件里也有正常声音   | ✅ 正常                             |
| 数字**持续变大**，但录音是噪声             | ⚠️ 线通了但没对上，检查电视端设置 |
| 数字**三次都一样、始终是 0**（录音进行中） | ❌ 没收到数据，见 [第五节 问题排查](#五问题排查)             |

录完可以用 `aplay /tmp/test.wav` 播放检查。

> **录音参数要和电视输出的一致。**
> 如果 `-r` 指定的采样率不在 [1.3 支持的规格](#支持的规格) 里，系统会**自动取最接近的值，不报错** —— 结果是「能录但速度不对」。

## 4.5 寄存器验证（客观判据）

**必须在流运行中读**（设备 runtime-suspend 时读回来是 `XXXXXXXX`）。

```sh
C=/sys/devices/platform/soc@0/30c00000.bus/30c00000.spba-bus/30cc0000.xcvr

# eARC 状态寄存器（偏移 0x20）
grep "^020:" /sys/kernel/debug/regmap/30cc0000.xcvr/registers

# 数据量
cat $C/counters/rx_bitcnt

# 当前是否 active
cat $C/power/runtime_status
```

`EXT_STATUS` 位判读：

| 位              | 名称                    | 含义                                     |
| --------------- | ----------------------- | ---------------------------------------- |
| bit31           | `HPD_INPUT`           | =1 HDMI 已连接                           |
| **bit27** | **`HB_STATUS`** | **=1 eARC 心跳正常（链路已建立）** |
| bit23           | `RX_CMDC_RSTO`        | =1 CMDC 复位完成                         |
| bit25 / bit26   | `CMDC_COTO`           | =1 CMDC 超时（异常）                     |

**实测参考值**：

- 正常待机（无 eARC 源）：`0x82850000` → bit31=1、bit23=1、**bit27=0**
- 链路建立后：**bit27 应变为 1**，且 `rx_bitcnt` 持续增长

## 4.6 eARC 注意事项

1. **eARC 不需要 CEC** —— 能力协商走 CMDC（固件处理）。CEC 不通**不影响** eARC 音频链路。
2. **电视必须支持 eARC** —— 只支持 ARC 的电视（如部分机型仅标 ARC）无法测 eARC，需换设备或用分析仪。
3. **对端插在标注 eARC 的口**，且电视菜单里 eARC 开关打开、`Digital Audio Out = PCM`。

---

# 五、问题排查

## 5.1 ARC / eARC 收不到数据时依次检查

1. 电视菜单里 eARC / ARC 开关是否打开（多数电视还要开 CEC）
2. HDMI 线是否插在电视的 **eARC / ARC 专用口**（见 [1.1 硬件准备](#11-硬件准备)）
3. 电视上是否真的有声音在播放、音量是否被静音
4. 换一根 HDMI 线试试
5. **确认 CEC 已配置**（ARC 的建立依赖它；eARC 不依赖）：
   ```sh
   cat /sys/kernel/debug/cec/cec0/status      # 需要 enabled: 1
   ```
6. ARC 模式下，把 `ARC Mode` 在 `Single Ended` 和 `Common` 之间换一下再试
7. 电视端把 eARC 关掉再打开一次，重新握手
8. 确认板载声卡没被占用（`aplay` 报 `Device or resource busy` 时）：
   ```sh
   systemctl stop playvideo.service playcamera.service record.service
   ```

## 5.2 CEC 分层排查命令（**遇到问题先跑这一套**）

按「从底层往上」逐层排查，每层的输出就能定位卡在哪一层。

**第 1 层 — HDMI 链路（CEC 的地基）**

```sh
for c in /sys/class/drm/card*-HDMI*; do echo "$(basename $c): $(cat $c/status) 模式数=$(wc -l < $c/modes)"; done
head -6 /sys/kernel/debug/cec/cec0/status
```

| 输出                          | 结论                                    |
| ----------------------------- | --------------------------------------- |
| `disconnected` / 模式数为 0 | HDMI 线没插好 —— 后面不用查了         |
| `phys_addr: f.f.f.f`        | EDID 读不到，或对端不支持 CEC（见 [2.1](#21-前置hdmi-必须先接好)） |
| `phys_addr: x.0.0.0`        | ✅ 正常，继续下一层                     |

**第 2 层 — CEC 配置状态**

```sh
cat /sys/kernel/debug/cec/cec0/status
cec-ctl -d /dev/cec0 --list-devices | grep -E "Logical Address|Device Features|Source Supports"
```

需同时满足：`configured: 1`、`LA mask` **非 0**、`Logical Address: 4`、`Source Supports ARC Rx`

| 异常                                    | 含义                                                             |
| --------------------------------------- | ---------------------------------------------------------------- |
| `configured: 0` / `LA mask: 0x0000` | **逻辑地址没申请到** —— 命令虽然返回成功，CEC 实际不能用 |
| 缺少 `Source Supports ARC Rx`         | 配置命令没生效，重跑 2.2                                         |

**第 3 层 — 进程与音频模式**

```sh
pgrep -a cec-follower || echo "❌ cec-follower 没有运行"
amixer -c imxaudioxcvr sget 'XCVR Mode' | tail -1
```

> ⚠️ 常见坑：`cec-follower ... &` 随 SSH 窗口关闭会被杀。稳妥写法见 [3.2](#32-关键必须运行-cec-follower)。

**第 4 层 — 实发一条，看结果**

```sh
cec-ctl -d /dev/cec0 --to 0 --initiate-arc
```

| 输出                                                   | 结论                                                                 |
| ------------------------------------------------------ | -------------------------------------------------------------------- |
| `INITIATE_ARC (0xc0)` + `Tx, Not Acknowledged`     | 消息发出了但对端没应答 → **多半是发早了**（ATC 当时未在监听） |
| `INITIATE_ARC (0xc0)` + `Tx, Error`                | CEC 线电平异常 —— 常见于**插错 HDMI 口**或线材问题           |
| `INITIATE_ARC (0xc0)` + `Rx, Report ARC Initiated` | ✅ 完全成功                                                          |
| 报错 / 无输出                                          | 命令没跑起来 → 回查第 2、3 层                                       |

**第 5 层 — 总线上有哪些设备**

```sh
cec-ctl -d /dev/cec0 --show-topology
```

应能看到 **TV（逻辑地址 0）**。如果只有 `x.0.0.0: Playback Device 1` 一行，说明对端没有接上或没有响应 CEC。

## 5.3 CEC 不工作时检查

| 现象                                                  | 原因                                                                                           | 处理                                                                      |
| ----------------------------------------------------- | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| `phys_addr` 显示 `f.f.f.f`                        | HDMI 未接好，或对端不提供 HDMI VSDB（DVI 显示器、转接器）                                      | 见 [2.1](#21-前置hdmi-必须先接好)，换用真正的 HDMI 显示器或电视                                      |
| **配置命令返回成功，但 CEC 完全不工作**         | HDMI 未就绪时执行配置，**逻辑地址没申请到**（状态是 `enabled: 1` + `configured: 0`） | 先确认 HDMI 已接，再重跑 2.2                                              |
| **发送报 `Tx, Error`, `Max Retries`**       | CEC 线电平异常 —— **多半是插错 HDMI 口**，或线材/端口接触不良                          | 换到标注 ARC/eARC 的口；换一根 HDMI 线                                    |
| 收发都无反应                                          | 适配器未配置                                                                                   | 执行 2.2 的配置命令                                                       |
| 之前能用，突然不行                                    | 重启了，或 HDMI 拔插过                                                                         | 重新执行 2.1 + 2.2                                                        |
| 能发但收不到电视的消息                                | 电视端 CEC 未开启                                                                              | 电视菜单里打开 CEC（各厂商叫法不同：Anynet+ / BRAVIA Sync / SimpLink 等） |
| **ARC 测试完全无响应**（对端说收不到 ARC 消息） | **`cec-follower` 没有运行**                                                            | 见 [3.2](#32-关键必须运行-cec-follower)，启动 `cec-follower -d /dev/cec0`                                |

## 5.4 需要反馈问题时，请提供以下信息

```sh
dmesg | grep -iE "xcvr|firmware|cec" | grep -v audit | tail -20
amixer -c imxaudioxcvr controls
cat /sys/kernel/debug/cec/cec0/status
uname -a
```

并请一并说明：

- 使用的电视**型号**
- 测的是 **eARC 还是 ARC**
- HDMI 插在电视的**哪个口**（读 `phys_addr` 的 x 值即可）
- 电视端菜单设置
- **三次 `rx_bitcnt` 的数值**（录音进行中读的）
