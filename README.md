# my-dev-flow

开发环境配置集中管理，一键部署。

## 包含的工具

| 工具 | 配置文件 | 说明 |
|------|----------|------|
| Ghostty | `ghostty/config` | 终端模拟器 |
| Zsh | `zsh/zshrc` | Shell |
| Oh-My-Zsh | 通过 `install.sh` 安装 | Zsh 框架 + 插件 |
| Zoxide | 通过 `install.sh` 安装 | 智能目录跳转 |
| Yazi | `yazi/*.toml` | 终端文件管理器 |
| Claude Code | `claude-code/README.md` | 配置指南文档 |

## 快速开始

### 1. 安装前置依赖

```bash
# macOS (Homebrew)
brew install zoxide               # 智能目录跳转
brew install yazi                 # 终端文件管理器

# Ghostty 从官网安装: https://ghostty.org
# Claude Code 见 claude-code/README.md
```

### 2. 部署配置

```bash
# 克隆仓库
git clone <repo-url> ~/Code/my-dev-flow
cd ~/Code/my-dev-flow

# 运行安装脚本（创建符号链接 + 安装 oh-my-zsh 插件）
./install.sh
```

### 3. Claude Code

Claude Code 的配置（密钥、插件、rtk）涉及多个工具联动，不适合脚本化安装。请按照 `claude-code/README.md` 中的指南手动配置。

### 4. 其他配置

```bash
# 代理设置（首次运行 install.sh 会自动创建模板）
vim ~/.config/proxy.env
```

### 5. 重启 shell

```bash
exec zsh
```

## 项目结构

```
my-dev-flow/
├── install.sh                  # 一键安装脚本（Ghostty/Zsh/Yazi 符号链接）
├── .gitignore
├── ghostty/
│   └── config                  # Ghostty 终端配置
├── claude-code/
│   └── README.md               # Claude Code 配置指南
├── zsh/
│   ├── zshrc                   # Zsh 配置（含 oh-my-zsh、zoxide）
│   └── proxy.env.example       # 代理配置模板
└── yazi/
    ├── yazi.toml               # Yazi 主配置
    ├── keymap.toml             # 快捷键映射
    ├── theme.toml              # 主题配色
    └── package.toml            # 插件依赖
```

## 符号链接映射

`install.sh` 会创建以下符号链接：

| 源（仓库） | 目标 |
|-------------|------|
| `ghostty/config` | `~/.config/ghostty/config` |
| `zsh/zshrc` | `~/.zshrc` |
| `yazi/yazi.toml` | `~/.config/yazi/yazi.toml` |
| `yazi/keymap.toml` | `~/.config/yazi/keymap.toml` |
| `yazi/theme.toml` | `~/.config/yazi/theme.toml` |
| `yazi/package.toml` | `~/.config/yazi/package.toml` |

修改仓库中的文件即可同步生效（部分需重载：Ghostty 用 `Cmd+Shift+,`，Zsh 用 `exec zsh`）。
