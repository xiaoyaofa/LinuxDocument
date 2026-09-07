## 安装插件
Vscode搜索claude code后安装

## 接入deepseek
原生要登录账号，可以通过修改跳过
修改~/.claude.json或者~/.claude/settings.json
其中ANTHROPIC_AUTH_TOKEN填自己Deepseek API
```
"hasCompletedOnboarding": true,
"env": {
    "ANTHROPIC_BASE_URL": "https://api.deepseek.com/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "xxxxxxxxxxxxxxxxxxxxxx",
    "ANTHROPIC_MODEL": "deepseek-v4-pro[1m]",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "deepseek-v4-pro[1m]",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "deepseek-v4-pro[1m]",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "deepseek-v4-flash[1m]",
    "CLAUDE_CODE_EFFORT_LEVEL": "max"
  },
```
然后重新加载vscode窗口

## 添加中文回复
vi ~/.claude/CLAUDE.md
```
# 个人全局配置
- 回复使用中文

```

## 设置权限
vscode设置->拓展->Claude Code

勾选如下功能，允许开启旁路权限模式，开启后相当于给agent最高权限
```
Allow Dangerously Skip Permissions
```
初始化的权限模式，建议改到plan
```
Initial Permission Mode
```

## 本地vscode插件路径
下面的*代表版本号
```
~/.vscode-server/extensions/anthropic.claude-code-*linux-x64/resources/native-binary/claude
```

## 导出skill
