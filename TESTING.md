# Testing Guide

This document describes how to test the development environment setup.

## Prerequisites

- A Linux or macOS system
- sudo access (for installing packages)
- Internet connection

## Testing the Setup Script

### 1. Clean Installation Test

```bash
# Clone the repository
git clone https://github.com/noamanfaisal/myenv.git
cd myenv

# Run the setup script
./setup.sh
```

**Expected Results:**
- Tmux is installed (or detected if already present)
- Micro editor is installed
- Configuration files are deployed to home directory
- Micro plugins are installed
- No errors during installation

### 2. Verify File Deployment

```bash
# Check if configuration files exist
ls -la ~/.tmux.conf
ls -la ~/.config/micro/settings.json
ls -la ~/.config/micro/bindings.json

# Verify backups were created (if configs existed before)
ls -la ~/.tmux.conf.backup.* 2>/dev/null || echo "No previous config to backup"
```

**Expected Results:**
- All configuration files exist in home directory
- Previous configurations are backed up with timestamp

## Testing Tmux Configuration

### 1. Start a New Session

```bash
tmux new -s test
```

**Expected Results:**
- New tmux session starts
- Status bar is visible at the bottom
- Session name "test" is displayed in status bar
- Current time and hostname are shown

### 2. Test Key Bindings

Inside the tmux session:

```
# Test prefix key (should be Ctrl-a, not Ctrl-b)
Ctrl-a ?    # Should show help with all keybindings

# Test pane splitting
Ctrl-a |    # Should split vertically
Ctrl-a -    # Should split horizontally

# Test pane navigation
Ctrl-a h    # Move to left pane
Ctrl-a l    # Move to right pane
Ctrl-a j    # Move to pane below
Ctrl-a k    # Move to pane above

# Test window management
Ctrl-a c    # Create new window
Ctrl-a n    # Next window
Ctrl-a p    # Previous window

# Test config reload
Ctrl-a r    # Should show "Config reloaded!" message
```

**Expected Results:**
- All keybindings work as described
- Panes split correctly
- Navigation is smooth
- Config reloads without errors

### 3. Test Mouse Support

```bash
# Start tmux session
tmux new -s mouse_test
```

Inside the session:
- Click on panes to switch between them
- Click and drag pane borders to resize
- Scroll mouse wheel to scroll through terminal history
- Double-click to select words
- Triple-click to select lines

**Expected Results:**
- Mouse interactions work smoothly
- No issues with selection or scrolling

### 4. Test Session Persistence

```bash
# Create a new session
tmux new -s persistent

# Inside tmux, start a long-running process
top

# Detach from session
Ctrl-a d

# List sessions
tmux ls

# Reattach to session
tmux attach -t persistent
```

**Expected Results:**
- Session persists after detaching
- Process (top) is still running when reattached
- No data loss

## Testing Micro Editor

### 1. Basic Functionality

```bash
# Create a test file
micro test.txt
```

Inside micro:
```
# Type some text
Hello, World!

# Save with Ctrl-s
Ctrl-s

# Quit with Ctrl-q
Ctrl-q

# Verify file was saved
cat test.txt
```

**Expected Results:**
- File opens in micro
- Text can be typed
- File saves successfully
- Content is preserved

### 2. Test Python Editing

```bash
# Create a Python file
micro test.py
```

Type this code:
```python
def hello(name):
    """Say hello to someone."""
    print(f"Hello, {name}!")

if __name__ == "__main__":
    hello("World")
```

**Expected Results:**
- Python syntax is highlighted
- Keywords (def, if, etc.) are colored
- Strings are colored
- Indentation is automatic (4 spaces)
- Comments can be toggled with Alt-/

### 3. Test Rust Editing

```bash
# Create a Rust file
micro test.rs
```

Type this code:
```rust
fn main() {
    let message = "Hello, World!";
    println!("{}", message);
}
```

**Expected Results:**
- Rust syntax is highlighted
- Keywords (fn, let) are colored
- Strings are colored
- Braces are matched
- Auto-indentation works

### 4. Test Key Bindings

In micro editor:
```
Ctrl-f      # Open find dialog
Ctrl-h      # Find next
Ctrl-g      # Go to line (type line number)
Alt-/       # Toggle comment
Ctrl-z      # Undo
Ctrl-y      # Redo
Ctrl-a      # Select all
Ctrl-c      # Copy
Ctrl-v      # Paste
Ctrl-k      # Cut line
Ctrl-d      # Duplicate line
```

**Expected Results:**
- All keybindings work as expected
- Find/replace functions correctly
- Comment toggling works
- Undo/redo stack works properly

### 5. Test Plugins

```bash
# List installed plugins
micro -plugin list

# Expected plugins:
# - comment
# - filemanager
# - jump
# - manipulator
```

**Expected Results:**
- All plugins are listed
- No error messages

## Testing Integration (Tmux + Micro)

### 1. Complete Workflow Test

```bash
# Start tmux
tmux new -s dev

# Split into multiple panes
Ctrl-a |    # Vertical split
Ctrl-a -    # Horizontal split (in right pane)

# Open editor in one pane
micro example.py

# In another pane, test Python
python3 example.py

# Navigate between panes
Ctrl-a h/j/k/l
```

**Expected Results:**
- Smooth integration between tmux and micro
- No display issues
- No keybinding conflicts
- Colors render correctly

### 2. Test in Docker

```bash
# Build Docker image
docker build -t myenv:test .

# Run container
docker run -it myenv:test

# Inside container, verify setup
tmux -V
which micro
cat ~/.tmux.conf
cat ~/.config/micro/settings.json
```

**Expected Results:**
- Docker image builds successfully
- Container starts with tmux
- All configurations are present
- Everything works as expected

## Performance Testing

### 1. Large File Handling

```bash
# Create a large file
seq 1 10000 > large.txt

# Open in micro
micro large.txt
```

**Expected Results:**
- File opens quickly
- Scrolling is smooth
- No lag when navigating

### 2. Multiple Panes

```bash
# Create many panes in tmux
tmux new -s stress

# Create 4 panes
Ctrl-a |
Ctrl-a -
Ctrl-a h
Ctrl-a -

# Open different files in each pane
micro file1.py
micro file2.rs
micro file3.txt
top
```

**Expected Results:**
- All panes function correctly
- No slowdown
- Switching between panes is instant

## Troubleshooting Tests

### 1. Configuration Conflicts

```bash
# Test with existing tmux config
mv ~/.tmux.conf ~/.tmux.conf.test
./setup.sh
# Verify backup was created
ls -la ~/.tmux.conf.backup.*
```

### 2. Network Issues

```bash
# Test with curl unavailable
# Verify script handles errors gracefully
```

### 3. Permission Issues

```bash
# Test without sudo access
# Verify script installs to ~/.local/bin
```

## Acceptance Criteria

The implementation is successful if:

- [x] Tmux configuration deploys and loads without errors
- [x] All tmux keybindings work as documented
- [x] Status bar displays correctly
- [x] Mouse support functions properly
- [x] Pane navigation is vim-like (h/j/k/l)
- [x] Micro editor configuration deploys successfully
- [x] Python syntax highlighting works
- [x] Rust syntax highlighting works
- [x] All custom keybindings work
- [x] Setup script runs without errors
- [x] Documentation is clear and complete
- [x] Docker image builds and runs successfully
- [x] Configurations are portable across systems

## Notes

- Some tests require manual interaction and cannot be fully automated
- Network connectivity is required for initial setup (downloading micro)
- Root/sudo access may be required for system-wide installation
- Test on a clean system or VM for best results
