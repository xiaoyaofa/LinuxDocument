# AppArmor 功能验证（MYD-JMX95）

适用开发板：`myd-jmx95-15x15-lpddr5`，内核 `6.12.49-lts-next-g5ada9224d957`
验证日期：2026-09-22

AppArmor 分内核和用户态两部分，都要有才能真正生效：

- **内核侧**：LSM 已编入并启用（`CONFIG_SECURITY_APPARMOR=y`）
- **用户态**：`apparmor` 包（提供 `apparmor_parser`、`aa-status` 和策略文件）

---

## 一、确认内核侧已生效

```bash
cat /sys/kernel/security/lsm                  # 期望 capability,apparmor
cat /sys/module/apparmor/parameters/enabled   # 期望 Y
dmesg | grep -i apparmor | head -4
```

期望看到：

```
capability,apparmor
Y
[    0.000764] AppArmor: AppArmor initialized
[    0.071451] AppArmor: AppArmor Filesystem Enabled
```

> `/sys/kernel/security/lsm` 里没有 `apparmor` 就说明内核不对，后面不用做了。

---

## 二、先理解：AppArmor 约束的是进程，不是文件

这一节解释一个很容易踩的认知误区。如果跳过它直接做第四节的测试，
很可能会得出"这 apparmor 有什么用，我用普通命令照样能创建文件"的结论——
**那是对模型的误解，不是 AppArmor 失效**。

### 核心模型

AppArmor 不是"文件访问白名单"，而是**给进程发通行证**。

一个 profile 只对**被挂上它的进程**生效；对没挂上它的进程，这份策略在系统里**等于不存在**。
所以同一个操作，换个执行方式，结果可以完全不同：

| 命令 | 进程进入的 profile | 结果 |
|---|---|---|
| `aa-exec -p aa-demo -- touch /tmp/x` | 显式切到 `aa-demo` | 受限 → 被拒绝 |
| `touch /tmp/x` | unconfined（无 profile） | AppArmor 完全不干预 → 正常创建 |

第四节演示里用的 `aa-demo` 是**具名 profile、且没有路径挂载点**：

```
profile aa-demo flags=(enforce) { ... }
```

这种写法**永远不会自动套用到任何程序上**，只能被显式进入。所以普通的 `touch` 不受它约束，
这是设计如此，不是策略没生效。

> `aa-exec` 是**调试工具**，相当于 profile 版的 `sudo -u`——用来验证"策略写得对不对"，
> 不是生产环境里 AppArmor 起作用的方式。

### 生产里靠「路径挂载」自动生效

真实环境用的是带挂载点的写法。板子上 syslogd 的 profile 就是现成的例子
（`/etc/apparmor.d/sbin.syslogd` 第 16 行）：

```
profile syslogd /{usr/,}{bin,sbin}/syslogd flags=(complain) {
```

`profile <名字> <挂载路径>` —— 任何 exec 到 `/{usr/,}{bin,sbin}/syslogd` 的进程都会**自动进入**
这个 profile（那串花括号是 AppArmor 的 glob，等价于 `/bin/syslogd`、`/sbin/syslogd`、
`/usr/bin/syslogd`、`/usr/sbin/syslogd` 四个路径）。

开机时 systemd 拉起的 `/usr/sbin/syslogd`（ppid=1）就是这样被自动套上的，
**全程没有任何人用 `aa-exec`**，而且它真的被拦住了：

```
apparmor="DENIED" operation="mknod" class="file" profile="syslogd"
name="/run/syslogd.cache" pid=731 comm="syslogd" exe="/usr/sbin/syslogd" subj=syslogd
```

syslogd 想在 `/run` 建缓存文件而被拒，反复重试刷屏，后来把这个 profile 切成 complain 模式才恢复正常，
日志随之变成 `apparmor="ALLOWED"`。

**这段"开机自动受限 → 被拦 → 人工处理 → 放行"的完整过程，就是 AppArmor 在真实环境里的样子。**

自动套用一共有三种途径：

1. **路径挂载**（最主要）：`profile 名字 /path/to/prog { }`
2. **简写**：`profile /path/to/prog { }`，profile 名就是路径。`/etc/apparmor.d/` 下
   `usr.sbin.syslogd` 这类文件名就是这个意思（把路径里的 `/` 换成 `.`）
3. **显式转换**：`aa-exec`、profile 内的 `px`/`cx` 规则、systemd 单元的 `AppArmorProfile=`

### 为什么这个模型有价值

它回答的不是"这个文件谁能碰"，而是**"这个程序一旦被攻破，它能干什么"**。

- **传统权限**：`syslogd` 以 root 运行 → 一旦 syslogd 有漏洞被利用，攻击者直接拿到完整 root 权限
- **AppArmor**：`syslogd` 仍然以 root 运行，但内核只允许它碰 profile 里**逐条列出的**那些东西：

  ```
  capability syslog,
  /dev/log                  wl,
  /etc/syslog.conf          r,
  /var/log/**               rw,
  @{run}/syslogd.pid        krwl,
  ```

  它就算被攻破，也越不出这几张条子的范围

**上面那次拦截的根因就藏在这份清单里**：profile 写的是 `@{run}/syslogd.pid`，
而这块板子上的 syslogd 要建的是 `/run/syslogd.cache`——名字不同，不在清单里，于是被拒。

这恰好说明了规则的性质：**策略是逐条列举的，没列到就是拒绝**。这不是"漏写了一条策略"的失误，
而是上游 profile（面向 openSUSE/Ubuntu 写的）和 OpenEmbedded 镜像里的实际服务不完全匹配——
在把整套上游策略直接装进 OE 镜像时，这是需要预期的。

同一个文件，`syslogd` 能写而 `apache2` 不能写 —— **权限跟着程序走，不跟着文件走**。
这就是它叫 MAC（Mandatory Access Control，强制访问控制）而不是 ACL 的原因。

---

## 三、确认用户态已就绪

> **正常流程下不需要手动装任何包。** AppArmor 已经编进本 SDK 构建的镜像，烧录后板上就有。本节只做确认。

它进镜像的路径是：

```
local.conf 里 DISTRO_FEATURES:append = " apparmor"
        ↓
systemd 的 PACKAGECONFIG 打开 apparmor，带 -Dapparmor=enabled 编译并链接 libapparmor.so.1
        ↓
OpenEmbedded 的 shlib 自动依赖据此把 apparmor 包拉进 rootfs
```

已在镜像 manifest 里核实（`myir-image-emmc-...rootfs-*.manifest`）：

```
apparmor armv8a 4.0.3-r0
systemd  armv8a 1:257.6-r0
```

板上确认：

```bash
dpkg -l apparmor | tail -1
```

期望：

```
ii  apparmor       4.0.3-r0     arm64        AppArmor another MAC control system
```

再确认工具、策略文件和开机服务都在：

```bash
command -v apparmor_parser aa-status aa-enforce aa-complain   # 都在 /usr/sbin/
ls /etc/apparmor.d | wc -l                                    # 期望 150 左右
systemctl is-enabled apparmor; systemctl is-active apparmor   # enabled / active
```

四项都正常就可以直接进第四节。

> ⚠️ **注意这个引入方式是间接的**——靠的是 systemd 的 shlib 依赖，镜像配方里其实**没有**显式列出
> `apparmor`。这意味着：如果将来构建不带 systemd 的镜像（改用 sysvinit），apparmor 就**不会**被
> 自动拉进去。需要更强保证的话，在 `myir-image-multimedia.bb` 的 `CORE_IMAGE_EXTRA_INSTALL_COMMON`
> 里显式加一行 `apparmor`。

> **如果显示未安装**（`dpkg -l apparmor` 无输出或 `un`）：说明板子上跑的是启用 AppArmor
> **之前**构建的旧镜像。临时补装的办法见文末「附：在旧镜像上临时安装 apparmor」，
> 长期方案是重新构建并烧录镜像。

---

## 四、验证功能

### 4.1 基本状态

```bash
aa-status
```

期望输出开头是：

```
apparmor module is loaded.
160 profiles are loaded.
64 profiles are in enforce mode.
```

（160 是包里自带的策略数量，说明策略确实加载进内核了）

```bash
systemctl is-enabled apparmor     # enabled
systemctl is-active apparmor      # active
```

### 4.2 用最小 profile 触发一次真实拒绝

这段是**核心验证**：写一个只允许访问 `/tmp/allowed.txt` 的 profile，
然后去看它对别的路径是不是真的拦得住。

> **先看第二节再来做这段。**
> 本节的 `aa-demo` 是**具名 profile、没有路径挂载点**，必须靠 `aa-exec` 显式进入才生效，
> 普通执行不受它约束——这是为了把"策略本身写得对不对"这一个变量单独隔离出来验证。
> 如果你发现"普通 `touch` 照样能建文件"，那是具名 profile 的正常行为，不是 AppArmor 失效；
> 生产里靠的是路径挂载自动生效（syslogd 就是例子）。

```bash
cat > /etc/apparmor.d/aa-demo <<'EOF'
#include <tunables/global>

profile aa-demo flags=(enforce) {
  #include <abstractions/base>
  /usr/bin/touch.coreutils rix,
  /tmp/allowed.txt rw,
  # /tmp/newdenied.txt 没有规则 -> 会被隐式拒绝
}
EOF

apparmor_parser -r -W /etc/apparmor.d/aa-demo
grep aa-demo /sys/kernel/security/apparmor/profiles      # 期望 aa-demo (enforce)
```

**测试 1：允许的路径应该成功**

```bash
rm -f /tmp/allowed.txt
aa-exec -p aa-demo -- /usr/bin/touch /tmp/allowed.txt && echo "ALLOW OK"
```

期望打印 `ALLOW OK`。

**测试 2：没有规则的路径应该被拒绝**

```bash
rm -f /tmp/newdenied.txt
aa-exec -p aa-demo -- /usr/bin/touch /tmp/newdenied.txt; echo "exit=$?"
```

期望：

```
touch: cannot touch '/tmp/newdenied.txt': Permission denied
exit=1
```

**测试 3：内核里的审计记录**

```bash
journalctl -S "-1min" | grep 'apparmor="DENIED"' | tail -2
```

期望：

```
apparmor="DENIED" operation="mknod" class="file" profile="aa-demo"
name="/tmp/newdenied.txt" pid=1477 comm="touch" requested_mask="c" denied_mask="c"
```

> **注意是 `journalctl` 不是 `dmesg`**。journald 接管了 audit socket
> （`apparmor.service` 自己就写着 `After=systemd-journald-audit.socket`），
> 所以 `dmesg | grep DENIED` 永远是空的。

**测试 4（对照）：确认拒绝来自 AppArmor 而不是文件系统权限**

```bash
apparmor_parser -R /etc/apparmor.d/aa-demo
rm -f /tmp/newdenied.txt
touch /tmp/newdenied.txt && echo "卸载 profile 后创建成功 -> 拒绝确实来自 AppArmor"
```

### 4.3 complain / enforce 对比

complain（抱怨）模式下策略只记录不拦截，可以证明拦截来自策略而非权限：

```bash
aa-complain /etc/apparmor.d/aa-demo
grep aa-demo /sys/kernel/security/apparmor/profiles      # 期望 aa-demo (complain)

rm -f /tmp/newdenied.txt
aa-exec -p aa-demo -- /usr/bin/touch /tmp/newdenied.txt && echo "complain 模式：创建成功（预期）"

aa-enforce /etc/apparmor.d/aa-demo
rm -f /tmp/newdenied.txt
aa-exec -p aa-demo -- /usr/bin/touch /tmp/newdenied.txt || echo "enforce 模式：重新被拒绝（预期）"
```

### 4.4 路径挂载的 profile：普通执行即被拦

4.2 用的是具名 profile，必须靠 `aa-exec` 进入。这一节换成**路径挂载**的写法，
让普通执行也被自动限制——这才是生产里的形态（原理见第二节）。

给 profile 加个挂载点即可。拷一份二进制到独立路径可以避开符号链接带来的歧义：

```bash
mkdir -p /usr/local/bin          # 本镜像默认没有这个目录
cp /usr/bin/touch.coreutils /usr/local/bin/aa-demo-touch

cat > /etc/apparmor.d/aa-demo-attached <<'EOF'
#include <tunables/global>

profile aa-demo-attached /usr/local/bin/aa-demo-touch {
  #include <abstractions/base>
  /tmp/allowed.txt rw,
  # /tmp/newdenied.txt 没有任何规则 -> 隐式拒绝
}
EOF

apparmor_parser -r -W /etc/apparmor.d/aa-demo-attached
grep aa-demo-attached /sys/kernel/security/apparmor/profiles   # 期望 aa-demo-attached (enforce)

rm -f /tmp/allowed.txt
/usr/local/bin/aa-demo-touch /tmp/allowed.txt && echo "ALLOW OK"

rm -f /tmp/newdenied.txt
/usr/local/bin/aa-demo-touch /tmp/newdenied.txt; echo "exit=$?"
# 普通执行，不需要 aa-exec，同样会被 Permission denied, exit=1
```

这是板上实测过的（2026-09-22）：

```
profile: aa-demo-attached (enforce)
ALLOW OK
aa-demo-touch: cannot touch '/tmp/newdenied.txt': Permission denied
```

对比第二节开头那张表就能看出差别：同一条 `touch` 命令，**挂上 profile 之后普通执行也会被拦**。

### 4.5 持久化：哪些扛得住重启

一句话原则：**只有写进 `/etc/apparmor.d/` 的东西才扛得住重启**。

| 操作 | 重启后 | 说明 |
|---|---|---|
| profile 文件放在 `/etc/apparmor.d/` 下 | ✅ 保留 | 就是磁盘文件 |
| profile 被自动加载 | ✅ 保留 | `apparmor.service` 是 `enabled`，每次开机加载整个目录 |
| **路径挂载**的自动拦截（`profile 名字 /path`） | ✅ 保留 | 加载后，任何 exec 该路径的进程自动受限 |
| **具名 profile** 的自动拦截（`profile 名字`） | ❌ 不适用 | 任何情况下都要显式 `aa-exec -p` 进入 |
| `aa-complain` / `aa-enforce` 切换模式 | ✅ 保留 | 它们**直接改写 profile 文件**里的 `flags=(complain)`，不是运行时状态 |
| `apparmor_parser -r` 手动加载 | ⚠️ 内存态 | 重启后由文件重建；文件不在则 profile 消失 |
| `aa-exec -p` 进入 profile | ❌ 仅当次 | 只影响那一次执行的进程 |
| 删了 profile 文件但没卸载 | ⚠️ 内存里还在 | 重启后消失；想立刻清掉用 `aa-remove-unknown` |

`aa-complain <profile文件>` 具体做的事：在 `sbin.syslogd` 里写入 `flags=(complain)`，文件修改时间随之更新。
所以重启后依然保持 complain，不会自动恢复 enforce。要改回去用 `aa-enforce <profile文件>`。

#### 已实测：4.4 那个 profile 重启后仍自动拦截

2026-09-22 在开发板上做过完整闭环：建好 4.4 的路径挂载 profile → 重启板子 →
**不碰任何 AppArmor 命令**，直接执行目标二进制，即被拒绝。开机日志里的证据链：

```
17:46:20 apparmor.systemd[179]: Reloading AppArmor profiles   ← 开机服务自动执行
17:46:20 apparmor_parser(pid=193) 加载 aa-demo-attached       ← 没有人执行这条命令
17:46:27 Finished Load AppArmor profiles
```

重启后的验证结果：

```
$ /usr/local/bin/aa-demo-touch /tmp/newdenied.txt
aa-demo-touch: cannot touch '/tmp/newdenied.txt': Permission denied
$ /usr/local/bin/aa-demo-touch /tmp/allowed.txt
ALLOW OK
```

同期还验证了拦截与终端无关：有 tty 的交互 shell、`setsid` 无 tty、`nobody` 非 root 用户、
`systemd-run` 由 init 直接拉起 —— 四种场景全部被拦（第一种还是以 root 身份跑的，**root 也逃不掉**）。

---

## 五、清理

```bash
# 4.2 / 4.3 建的具名 profile
apparmor_parser -R /etc/apparmor.d/aa-demo
rm -f /etc/apparmor.d/aa-demo

# 4.4 / 4.5 建的路径挂载 profile
apparmor_parser -R /etc/apparmor.d/aa-demo-attached
rm -f /etc/apparmor.d/aa-demo-attached /usr/local/bin/aa-demo-touch
rmdir /usr/local/bin 2>/dev/null

rm -f /tmp/allowed.txt /tmp/newdenied.txt
aa-status | head -3
```

> 如果忘了卸载就先删了 profile 文件，核心里会留下一个"孤儿 profile"。用下面这条清理，
> 加 `-n` 可以先空跑看它会删哪些：
>
> ```bash
> aa-remove-unknown -n     # 空跑，只列出
> aa-remove-unknown        # 实际执行
> ```

---

## 附：在旧镜像上临时安装 apparmor

**只用于已经在跑、又不想重新烧录的旧镜像**。新镜像请走第三节的正常确认流程。

只需要**一个** deb 包，板上其余依赖（`bash`、`libc6`、`libpam`、`libatomic1`、`python3-core`、
`python3-modules`）一般都已经有了：

```bash
B=/home/myir/myd-jmx95x/sdk1.0/myd-jmx95x-yocto/build-jmx95x
scp $B/tmp/deploy/deb/armv8a/apparmor_4.0.3-r0_arm64.deb root@<板子IP>:/tmp/
```

板上执行：

```bash
dpkg -i --ignore-depends=glibc-utils /tmp/apparmor_4.0.3-r0_arm64.deb
```

装完会自动 enable 并启动 `apparmor.service`（包内 `postinst` 里带 `systemctl --no-block restart`），
不用手动重启。

> **为什么是 `--ignore-depends=glibc-utils`**：这个 distro 里 `glibc-utils` 是空包（`PACKAGES` 里有它
> 但没定义 `FILES`），被 OpenEmbedded 丢弃了，`deploy/deb` 里根本没有。而 apparmor 装的文件里
> 没有任何一处调用它（`/usr/bin/ldd` 已由独立包 `ldd` 提供）。用它而不是 `--force-depends`，
> 是为了只放行这一条失效依赖，其余真实依赖仍会校验——万一板上还缺别的，会老实报错而不是被掩盖。

> **注意**：这样装进去的 apparmor 属于包管理器的"额外安装"，不会随镜像重新烧录而保留。
> 长期方案是在镜像配方里带上它。

---

## 附：容易踩的坑

| 现象 | 原因 |
|---|---|
| profile 明明加载了，但进程还是不受限 | 挂载点写成了符号链接路径。板子上 `/usr/bin/touch` → `/usr/bin/touch.coreutils`，AppArmor 按**真实路径**挂载。用**具名 profile + `aa-exec -p`** 套用最稳 |
| 拦截生效了但 journal 里搜不到记录 | 用了显式 `deny` 规则。AppArmor 里显式 `deny` **默认不记日志**，只有"没有 allow 规则匹配"的隐式拒绝才记 |
| `dmesg` 里找不到 `apparmor="DENIED"` | 记录在 systemd journal 里，用 `journalctl` |
| `aa-complain` 报 `Warning: profile ... represents multiple programs` 且不生效 | 对具名 profile 要传 **profile 文件路径**（`/etc/apparmor.d/aa-demo`），不能传程序路径 |
| `touch` 已存在的文件没被拦 | `touch` 对已存在文件走 `utimensat`，不被 `w` 权限覆盖。测拒绝要用**创建新文件**（`operation="mknod"`） |
| `dpkg -i` 报 `glibc-utils` 未满足 | 见「附：在旧镜像上临时安装 apparmor」，加 `--ignore-depends=glibc-utils` |

---

## 附：相关文件位置

以下路径均相对于 `myd-jmx95x-yocto/`。

### 构建配置（改动过的）

| 用途 | 路径 |
|---|---|
| distro 特性开关 | `build-jmx95x/conf/local.conf` 里的 `DISTRO_FEATURES:append = " apparmor"` |
| 内核配置片段 | `sources/meta-myir/meta-myir-bsp/recipes-kernel/linux/linux-imx/apparmor.cfg` |
| 内核配方 bbappend | `sources/meta-myir/meta-myir-bsp/recipes-kernel/linux/linux-imx_%.bbappend` |
| 镜像配方（如需显式加 `apparmor`） | `sources/meta-myir/meta-myir-sdk/recipes-fsl/images/myir-image-multimedia.bb` 的 `CORE_IMAGE_EXTRA_INSTALL_COMMON` |

### 构建产物

| 用途 | 路径 |
|---|---|
| 镜像 manifest（查包用） | `build-jmx95x/tmp/deploy/images/myd-jmx95-15x15-lpddr5/myir-image-emmc-*.manifest` |
| 完整镜像 | `build-jmx95x/tmp/deploy/images/myd-jmx95-15x15-lpddr5/myir-image-emmc-*.rootfs.wic.zst` |
| 内核 | `build-jmx95x/tmp/deploy/images/myd-jmx95-15x15-lpddr5/Image` |
| apparmor deb（**仅旧镜像补装用**） | `build-jmx95x/tmp/deploy/deb/armv8a/apparmor_4.0.3-r0_arm64.deb` |

> 镜像里是否带了 apparmor，最快的确认方式：
> `grep -E "^apparmor " build-jmx95x/tmp/deploy/images/myd-jmx95-15x15-lpddr5/*.manifest`
