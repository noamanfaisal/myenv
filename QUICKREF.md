# Quick Reference Guide

## Tmux Quick Commands

### Session Management
```bash
tmux new -s <name>          # Create new named session
tmux ls                     # List sessions
tmux attach -t <name>       # Attach to session
tmux kill-session -t <name> # Kill session
```

### Key Bindings (Prefix: Ctrl-a)
```
Ctrl-a |        Split vertically
Ctrl-a -        Split horizontally
Ctrl-a h/j/k/l  Navigate panes (vim-style)
Ctrl-a c        New window
Ctrl-a n/p      Next/Previous window
Ctrl-a d        Detach from session
Ctrl-a [        Copy mode
Ctrl-a ]        Paste
Ctrl-a r        Reload config
Ctrl-a S        Synchronize panes
```

## Micro Editor Quick Commands

### Essential Keys
```
Ctrl-s          Save
Ctrl-q          Quit
Ctrl-f          Find
Ctrl-z          Undo
Ctrl-y          Redo
Ctrl-a          Select all
Ctrl-c/x/v      Copy/Cut/Paste
Alt-/           Comment/Uncomment line
Ctrl-g          Go to line
Ctrl-e          Command mode
```

### Language Support

#### Python
- Syntax highlighting enabled
- Auto-indent with 4 spaces
- Comment with Alt-/

#### Rust
- Syntax highlighting enabled
- Auto-indent with 4 spaces
- Brace matching

### Plugins
```bash
micro -plugin available     # List available plugins
micro -plugin install <name> # Install plugin
micro -plugin list          # List installed plugins
```

## Common Workflows

### Starting a Development Session
```bash
# Start tmux session
tmux new -s dev

# Split into panes
Ctrl-a |  # Vertical split
Ctrl-a -  # Horizontal split

# Navigate between panes
Ctrl-a h/j/k/l

# Open files with micro
micro main.py
```

### Working on Remote Server
```bash
# Connect with SSH
ssh user@server

# Start or attach to tmux session
tmux attach -t dev || tmux new -s dev

# Session persists even if SSH disconnects
```

### Multi-pane Development
```bash
# In tmux:
# - Top pane: editor (micro)
# - Bottom-left: tests running
# - Bottom-right: server/logs

# Layout:
# Ctrl-a |  # Split vertically
# Ctrl-a -  # Split horizontally (in right pane)
# Ctrl-a h  # Navigate to left pane
# micro app.py  # Start editing
```

## Configuration Files

```
~/.tmux.conf                    # Tmux configuration
~/.config/micro/settings.json   # Micro editor settings
~/.config/micro/bindings.json   # Micro key bindings
~/.config/micro/backups/        # Micro file backups
```

## Useful Tips

1. **Persistent sessions**: Tmux sessions survive SSH disconnections
2. **Synchronize panes**: `Ctrl-a S` to type in all panes simultaneously
3. **Copy mode**: `Ctrl-a [` then use vim keys to navigate and select text
4. **Mouse support**: Click to switch panes, select text, resize panes
5. **Backups**: Micro automatically backs up files to `~/.config/micro/backups/`
