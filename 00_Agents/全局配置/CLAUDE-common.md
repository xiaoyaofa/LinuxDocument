# Linux BSP 团队全局开发规范

> 作者：wilson.xie
> 通用团队版：可复制为 `~/.claude/CLAUDE.md`、项目 `CLAUDE.md`，或放到自己的 `CLAUDE_CONFIG_DIR` 使用；个人称呼/偏好请自行补充。
> 适用于所有项目。项目特定规范放在项目 `CLAUDE.md` / `AGENTS.md`；团队通用偏好放这里。
> 最后更新：2026-10-19

## 1. 身份与沟通

- 默认不使用昵称；需要称呼时用“你”即可。
- 默认用中文回复；代码、命令、路径、日志、提交信息保持原文。
- 先给结论，再给依据；直接、简洁，不要奉承和多余客套。
- 不确定就说明假设、风险和需要我确认的点；不要编造事实或验证结果。
- 有不同意见直接指出，并给出可执行的替代方案。

## 2. 工作方式

- 先读后改：先看项目 `CLAUDE.md` / `AGENTS.md` / README、构建脚本和相关源码，再动手。
- 非 trivial 任务先给计划（plan mode），我确认后再改。
- 改动最小化：只改必要文件，匹配周围代码风格；不做未经请求的重构、格式化、依赖升级。
- 不覆盖、不回滚我或其他人的未提交改动；发现冲突先停下说明。
- 需求不清先问；涉及架构、接口、数据格式、ABI、硬件引脚/极性的变更必须先确认。
- 完成后自检：编译、测试、静态检查；报告实际执行的命令和结果。
- 没有实际验证，不要说“已完成”“已修复”“测试通过”。

## 3. Git 与提交（强约束）

- **未经我明确确认，绝不 `git commit`、`git push`、创建 PR 或修改远端分支。**
- 改完先给出 `git diff`、`git status` 和构建/测试结果，等我确认。
- 不在默认分支直接提交；需要分支时先说明。
- 提交信息用英文、祈使句、简洁，遵循项目现有风格。
- 内核补丁：人类作者提供 `Signed-off-by`；代理不要自行添加 `Signed-off-by`。署名格式按项目要求执行。
- 尊重仓库级 git 身份和配置：不要改 `user.name` / `user.email`、remote、SSH key，也不要重写作者历史。
- 默认只本地 commit；**push / 开 PR / 发布 tag 前必须再次确认**，不要把 commit 和 push 串在一条命令里。
- 不修改 git config、hooks、远端 URL；不 force push；不改写已推送历史。
- 不提交密钥、token、密码、私有固件、大二进制；提交前检查 `.gitignore`。

## 4. Linux 内核 / BSP 开发

- 动手前确认：内核版本、分支/HEAD、defconfig、目标 DTS/DTB、交叉编译工具链。
- 编译内核或设备树前先 `source` 项目指定的 SDK / `environment-setup`；环境变量不跨 shell 持久，每次重新导入。
- 如果 SDK 的 host 工具与系统 glibc 冲突，回退系统 `HOSTCC`/`HOSTLD`/`HOSTAR`/`HOSTCXX`，并清掉 `CFLAGS`/`LDFLAGS` 等目标参数；不要混用不同 SoC 的工具链。
- 构建前确认目标板型、defconfig、DTB 目标；构建后核对产物时间戳和内核版本字符串，避免部署旧 Image/DTB。
- 优先 in-tree 构建，除非项目规定 `O=`；不要随意 `make clean` 或删除构建产物。
- 遵循 `Documentation/process/coding-style.rst`：tab 缩进、80 列、命名和注释与文件一致；改动后跑 `checkpatch.pl`。
- 设备树：先查 binding（`Documentation/devicetree/bindings/`）和 SoC pinctrl；不发明未文档化属性；改完编译 DTB，并用 `dtc -I dtb -O dts` 反编译确认。
- DTS 的 `status` 默认值、PHY 的 `compatible`、节点名重复、pinctrl 复用冲突都容易误判；以实际 probe、原理图和实测为准，不要只看注释。
- 移植新板型时先复制现有板级文件再改副本；不要修改已有板型/客户变体；共享文件只做向后兼容的纯新增，必要时先问。
- 驱动：先读 probe/remove/PM/并发/错误路径；注意锁、引用计数、DMA、寄存器位；不要只改 happy path。
- 调试优先 `dmesg`、`ftrace`、`debugfs`、`/proc`、`/sys`、`gpioinfo`、pinctrl；`devmem` / 直接写寄存器仅限调试并说明风险。
- 不擅自修改 U-Boot / TF-A / OP-TEE / rootfs 等相邻组件；跨仓库改动分别说明。
- 不擅自改分区、烧录、`dd`、`mkfs`、`flash_erase`；涉及板子或块设备的写操作先确认并备份。
- 不凭猜测确定硬件引脚/极性；以原理图、pin list、DTS 和实测为准。

### Yocto / Buildroot

- 优先改 layer、recipe、bbappend；不要直接改 `tmp/`、`downloads/`、`sstate-cache/` 等生成物。
- 代理变量要在启动 bitbake 的 shell 里 export；不要随意在 `local.conf` 加 `FETCHCMD_wget` / `PREMIRRORS`（会改变配置校验和，触发全量重编译）。
- 不要删除 `DL_DIR` / `SSTATE_DIR`；`bitbake -c cleanall`、删除 downloads/sstate 前必须确认。

### 板端测试

- 优先 SSH，保留串口作为后备；阻塞命令加 `timeout`；CPU/内存压测可能饿死 sshd，压测时不要依赖交互式 SSH。
- 烧录、分区、`dd`、重启前先备份（DTB/rootfs/分区表）并确认目标设备。

## 5. 代码质量

- 简单优先；避免过度抽象和“以后可能用得上”的功能。
- 错误处理完整，资源释放对称，不在原子/中断上下文睡眠。
- 保持 API/ABI 向后兼容；内核 UAPI 变更要特别谨慎。
- 注释解释“为什么”，不重复“做了什么”；不留死代码和调试打印。
- 修掉新增编译警告；不要用 `-Wno-` 掩盖问题。
- 不为让测试通过而删除测试、断言或错误处理。

## 6. 工具与上下文

- 优先使用 Read/Edit/Grep/Glob 等专用工具；独立读取可并行。
- Linux 环境下有 `fd` / `fdfind` 命令时，优先用它查找文件，代替 `find`。
- 大范围搜索用 subagent，避免无关文件占满上下文。
- 修改前先读文件，不凭记忆改代码。
- 长任务用 plan/todo 跟踪；阶段结束报告进展。
- 不执行来源不明的脚本；安装依赖或下载外部代码前先确认。
- 不把敏感信息发送到外部服务。

## 7. 安全与破坏性操作

- 删除/覆盖前先看目标；优先可恢复操作。
- 不运行 `rm -rf /`、`dd` 写磁盘、`mkfs`、`git reset --hard`、`git clean -fdx` 等危险命令，除非我明确要求并确认目标。
- 不修改全局配置、权限、SSH 密钥、防火墙，除非任务明确要求。
- 不在文件、提交或记忆中保存密码、token、SSH 私钥等凭据。
- 不绕过权限提示；被拒绝的操作不要换路径重试。
- 共享服务器/共享仓库默认只读；不改他人 home、不杀他人进程、不占用共享构建目录；需要写操作时先确认。
- 原理图、网表、引脚表、BOM、客户板名/项目名不得提交到公开仓库或发送到外部服务；发布文档/skill 前先脱敏。

## 8. 文档与记忆

- 项目规范写在项目 `CLAUDE.md` / `AGENTS.md`；团队通用规范写全局 `~/.claude/CLAUDE.md`。
- 个人偏好写 `CLAUDE.local.md` 或自己的独立配置目录（`CLAUDE_CONFIG_DIR`），不要写进共享的全局文件。
- 不把项目特定信息写进全局文件。
- 我给出可复用偏好时，提议更新全局 CLAUDE.md 或记忆。
- 配套交付物（如 xlsx 表格 + md 说明）必须同步修改：先定表格，再回填文档，最后做一致性检查。
- 项目专属的非显而易见信息（构建坑、硬件坑、客户隔离要求）写入项目 `AGENTS.md` 或项目记忆，不写进全局文件。
- 文档用中文；代码、命令、路径用原文。

## 9. 输出格式

- 结论先行，列点或表格；命令用代码块。
- 引用文件用 `path:line` 或可点击链接。
- 只贴关键代码片段，不输出大段无关内容。
- 不确定的地方明确标注。
