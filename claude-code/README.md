# Claude Code 配置指南

## 安装 Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

## 密钥管理 — cc-switch

[cc-switch](https://github.com/farion1231/cc-switch) 是一个桌面应用，统一管理 Claude Code、Codex、Gemini CLI 等 AI 编程工具的 API 密钥。

### 安装

```bash
brew tap farion1231/ccswitch
brew install --cask cc-switch
```

### 使用

1. 打开 cc-switch
2. 首次启动时导入当前 `~/.claude/settings.json` 作为默认 provider
3. 通过图形界面添加/切换 provider（支持 50+ 预设）
4. Claude Code 支持热切换，无需重启终端

> cc-switch 直接读写 `~/.claude/settings.json`，数据存储在 `~/.cc-switch/cc-switch.db`

---

## Token 优化 — rtk

[rtk](https://github.com/rtk-ai/rtk) (Rust Token Killer) 作为 Claude Code hook 自动重写命令，节省 60-90% token。

### 安装

从 [rtk releases](https://github.com/rtk-ai/rtk) 下载安装，二进制放在 `~/.local/bin/rtk`。

### 配置 Hook

将以下配置添加到 `~/.claude/settings.json` 的 `hooks.PreToolUse` 中：

```json
{
  "matcher": "Bash",
  "hooks": [
    {
      "type": "command",
      "command": "$HOME/.claude/hooks/rtk-rewrite.sh"
    }
  ]
}
```

rtk 会在 `~/.claude/hooks/rtk-rewrite.sh` 放置 hook 脚本，无需手动创建。

### 验证

```bash
rtk --version    # 确认版本 >= 0.23.0
rtk gain         # 查看 token 节省统计
```

---

## 插件

当前启用的插件列表，通过 `claude plugins install <marketplace>/<plugin>` 安装。

### Marketplace

先添加插件源：

```bash
claude plugins add-source github:anthropics/claude-plugins-official
claude plugins add-source https://github.com/affaan-m/everything-claude-code.git
claude plugins add-source github:jarrodwatts/claude-hud
claude plugins add-source github:777genius/claude-notifications-go
```

### 安装插件

```bash
# 官方插件
claude plugins install superpowers@claude-plugins-official

# 社区插件
claude plugins install ecc@ecc
claude plugins install claude-hud@claude-hud
claude plugins install claude-notifications-go@claude-notifications-go
```

### 插件说明

| 插件 | 说明 |
|------|------|
| superpowers | Skills 系统、TDD、代码审查、头脑风暴 |
| ecc | Everything Claude Code — agents、skills、hooks |
| claude-hud | Claude Code 状态栏 |
| claude-notifications-go | 桌面通知 |

> 插件安装完成后会自动写入 `~/.claude/settings.json` 和 `~/.claude/hooks/hooks.json`，无需手动编辑。
