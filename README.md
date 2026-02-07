# myenv - Personal Terminal Development Environment

A streamlined terminal-based development and admin environment designed for efficient work on remote servers, Docker containers, and cloud infrastructure.

## 🎯 Features

- **Consistent tmux workflow** for persistent terminal sessions
- **Lightweight micro editor** configured for Python, Rust, and general editing
- **Easy deployment** with automated setup script
- **Portable configuration** that works across different Linux distributions and macOS

## 📦 What's Included

### Tmux Configuration

A carefully crafted tmux setup providing:

- **Intuitive prefix key** (`Ctrl-a`) for easier access
- **Vim-like navigation** for panes and windows
- **Mouse support** for quick interactions
- **Persistent sessions** to survive disconnections
- **Custom status bar** showing session, time, and hostname
- **Smart pane splitting** that preserves working directory
- **Synchronized panes** for running commands across multiple panes

### Micro Editor Configuration

A lightweight yet powerful editor setup with:

- **Syntax highlighting** for Python, Rust, and 40+ other languages
- **Auto-indentation** and smart formatting
- **Auto-save** and backup functionality
- **Mouse support** for easy text selection
- **Line numbers** and cursor highlighting
- **Incremental search** and replace
- **Useful plugins** (comment, filemanager, jump, manipulator)

## 🚀 Quick Start

### Installation

1. Clone this repository:
```bash
git clone https://github.com/noamanfaisal/myenv.git
cd myenv
```

2. Run the setup script:
```bash
./setup.sh
```

The setup script will:
- Install tmux (if not already installed)
- Install micro editor (if not already installed)
- Deploy configuration files to your home directory
- Install recommended micro plugins
- Backup any existing configurations

### Manual Installation

If you prefer to install components manually or want more control over the installation process:

1. **Install tmux:**
   ```bash
   # Debian/Ubuntu
   sudo apt-get install tmux
   
   # RHEL/CentOS
   sudo yum install tmux
   
   # macOS
   brew install tmux
   ```

2. **Install micro editor:**
   
   Using the official installer (recommended by micro):
   ```bash
   curl https://getmic.ro | bash
   sudo mv micro /usr/local/bin/
   ```
   
   For enhanced security, you can download and inspect the script first:
   ```bash
   curl -o getmicro.sh https://getmic.ro
   # Inspect the script content
   cat getmicro.sh
   # Run it after verification
   bash getmicro.sh
   sudo mv micro /usr/local/bin/
   ```
   
   Alternatively, download pre-built binaries from [GitHub releases](https://github.com/zyedidia/micro/releases).

3. **Deploy configurations:**
   ```bash
   cp .tmux.conf ~/.tmux.conf
   cp -r .config/micro ~/.config/
   ```

## 📖 Usage Guide

### Tmux Workflow

#### Starting and Managing Sessions

```bash
# Create a new named session
tmux new -s dev

# List all sessions
tmux ls

# Attach to an existing session
tmux attach -t dev

# Detach from current session (inside tmux)
Ctrl-a d

# Kill a session
tmux kill-session -t dev
```

#### Key Bindings

All tmux commands start with the prefix key: `Ctrl-a`

**Window Management:**
- `Ctrl-a c` - Create new window
- `Ctrl-a ,` - Rename current window
- `Ctrl-a n` - Next window
- `Ctrl-a p` - Previous window
- `Ctrl-a 0-9` - Switch to window by number
- `Ctrl-a Ctrl-h` - Previous window (quick)
- `Ctrl-a Ctrl-l` - Next window (quick)

**Pane Management:**
- `Ctrl-a |` - Split pane vertically
- `Ctrl-a -` - Split pane horizontally
- `Ctrl-a h/j/k/l` - Navigate between panes (vim-style)
- `Ctrl-a H/J/K/L` - Resize current pane
- `Ctrl-a x` - Close current pane
- `Ctrl-a Space` - Toggle between pane layouts
- `Ctrl-a S` - Synchronize all panes (type in all simultaneously)

**Other Useful Commands:**
- `Ctrl-a [` - Enter copy mode (use vim keys to navigate, `v` to select, `y` to copy)
- `Ctrl-a ]` - Paste from tmux buffer
- `Ctrl-a r` - Reload tmux configuration
- `Ctrl-a ?` - Show all key bindings

### Micro Editor Usage

#### Basic Commands

```bash
# Open a file
micro filename.py

# Open multiple files in splits
micro file1.py file2.rs

# Open with specific line number
micro +42 filename.py
```

#### Key Bindings

**File Operations:**
- `Ctrl-s` - Save
- `Ctrl-q` - Quit
- `Ctrl-o` - Open file
- `Ctrl-g` - Go to line number

**Editing:**
- `Ctrl-z` - Undo
- `Ctrl-y` - Redo
- `Ctrl-f` - Find
- `Ctrl-h` - Find next
- `Ctrl-r` - Find previous
- `Alt-/` or `Ctrl-_` - Toggle line comment
- `Ctrl-a` - Select all
- `Ctrl-c` - Copy
- `Ctrl-x` - Cut
- `Ctrl-v` - Paste
- `Ctrl-k` - Cut line
- `Ctrl-d` - Duplicate line

**Navigation:**
- `Ctrl-Left/Right` - Move by word
- `Home/End` - Start/End of line
- `Ctrl-Home/End` - Start/End of file
- `PageUp/PageDown` - Scroll by page

**Advanced:**
- `Ctrl-e` - Command mode (run micro commands)
- `Ctrl-b` - Move lines up
- `Ctrl-n` - Move lines down

#### Plugins

The following plugins are installed by default:

- **comment** - Toggle comments with `Alt-/`
- **filemanager** - Browse files in a tree view
- **jump** - Quick navigation to definitions
- **manipulator** - Text manipulation utilities

## 🔧 Customization

### Modifying Tmux Configuration

Edit `~/.tmux.conf` and reload with:
```bash
tmux source-file ~/.tmux.conf
# Or inside tmux: Ctrl-a r
```

### Modifying Micro Configuration

Edit `~/.config/micro/settings.json` for general settings or `~/.config/micro/bindings.json` for key bindings.

Changes take effect immediately when you open a new file in micro.

### Installing Additional Micro Plugins

```bash
# List available plugins
micro -plugin available

# Install a plugin
micro -plugin install <plugin-name>

# List installed plugins
micro -plugin list
```

## 🐳 Docker Usage

This environment is perfect for Docker containers. Example Dockerfile:

```dockerfile
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    tmux \
    curl \
    git \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install micro editor
RUN curl https://getmic.ro | bash && mv micro /usr/local/bin/

# Copy environment configuration
COPY .tmux.conf /root/.tmux.conf
COPY .config/micro /root/.config/micro

# Set working directory
WORKDIR /workspace

# Start tmux by default
CMD ["tmux", "new-session", "-s", "workspace"]
```

## 🌐 Remote Server Setup

For quick deployment to remote servers:

```bash
# Clone and setup in one line
ssh user@remote-server "git clone https://github.com/noamanfaisal/myenv.git && cd myenv && ./setup.sh"

# Or copy configs to existing server
scp .tmux.conf user@remote-server:~/
scp -r .config/micro user@remote-server:~/.config/
```

## 🤝 Contributing

This is a personal environment configuration, but feel free to fork and adapt it to your needs!

## 📝 License

MIT License - feel free to use and modify as needed.

## 🔗 Resources

- [Tmux Documentation](https://github.com/tmux/tmux/wiki)
- [Micro Editor Documentation](https://micro-editor.github.io/)
- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)

## 💡 Tips

1. **Persist sessions on server reboot**: Consider using `systemd` or `tmux-continuum` plugin
2. **Share configs across machines**: Keep this repository synced via git
3. **Language-specific setup**: Add Python/Rust linters and formatters as needed
4. **Performance on slow connections**: Disable mouse mode in tmux if needed
5. **Customize colors**: Adjust tmux color scheme in `.tmux.conf` to match your terminal

## 🐛 Troubleshooting

**Tmux shows "protocol version mismatch":**
- Kill all tmux sessions: `tmux kill-server`
- Restart tmux

**Micro plugins not working:**
- Reinstall plugins: `micro -plugin install <plugin-name>`
- Check plugin channel: `micro -plugin update`

**Colors look wrong:**
- Ensure your terminal supports 256 colors
- Set `TERM=screen-256color` in your shell profile

**Can't find micro after installation:**
- Add `~/.local/bin` to your PATH
- Or move micro to `/usr/local/bin/`