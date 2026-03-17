## 内核配置
CONFIG_FTRACE=y
CONFIG_ENABLE_DEFAULT_TRACERS=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_UPROBE_EVENTS=y

## 使用
内核函数调用跟踪
进入 ftrace 目录
```
cd /sys/kernel/debug/tracing
```
设置 tracer 类型为function
```
echo function > current_tracer
```
设置要追踪的函数
```
set_ftrace_filter	- echo function name in here to only trace these
			  functions
	     accepts: func_full_name or glob-matching-pattern
	     modules: Can select a group via module
	      Format: :mod:<module-name>
	     example: echo :mod:ext3 > set_ftrace_filter
	    triggers: a command to perform when function is hit
	      Format: <function>:<trigger>[:count]
	     trigger: traceon, traceoff
		      enable_event:<system>:<event>
		      disable_event:<system>:<event>
		      stacktrace
		      dump
		      cpudump
	     example: echo do_fault:traceoff > set_ftrace_filter
	              echo do_trap:traceoff:3 > set_ftrace_filter
	     The first one will disable tracing every time do_fault is hit
	     The second will disable tracing at most 3 times when do_trap is hit
	       The first time do trap is hit and it disables tracing, the
	       counter will decrement to 2. If tracing is already disabled,
	       the counter will not decrement. It only decrements when the
	       trigger did work
	     To remove trigger without count:
	       echo '!<function>:<trigger> > set_ftrace_filter
	     To remove trigger with a count:
	       echo '!<function>:<trigger>:0 > set_ftrace_filter
```
```
echo xxx > set_ftrace_filter
```
开启全局的 tracer
```
echo 1 > tracing_on
```
查看trace结果
```
cat trace
```
关闭跟踪
```
echo 0 > /sys/kernel/debug/tracing/tracing_on
echo nop > /sys/kernel/debug/tracing/current_tracer
```

## 知乎介绍
[ftrace内核跟踪](https://zhuanlan.zhihu.com/p/659390893)

## 官方文档
[kernel官方文档](https://www.kernel.org/doc/html/latest/trace/ftrace.html)