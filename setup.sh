#!/usr/bin/env bash

# Installation script for personal development environment
# Sets up tmux and micro editor with custom configurations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apt-get; then
            echo "debian"
        elif command_exists yum; then
            echo "rhel"
        elif command_exists apk; then
            echo "alpine"
        elif command_exists pacman; then
            echo "arch"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Function to install tmux
install_tmux() {
    local os="$1"
    
    if command_exists tmux; then
        print_info "tmux is already installed ($(tmux -V))"
        return 0
    fi
    
    print_info "Installing tmux..."
    
    case "$os" in
        debian)
            sudo apt-get update && sudo apt-get install -y tmux
            ;;
        rhel)
            sudo yum install -y tmux
            ;;
        alpine)
            sudo apk add tmux
            ;;
        arch)
            sudo pacman -S --noconfirm tmux
            ;;
        macos)
            if command_exists brew; then
                brew install tmux
            else
                print_error "Homebrew not found. Please install Homebrew first."
                return 1
            fi
            ;;
        *)
            print_error "Unsupported OS for automatic tmux installation"
            print_info "Please install tmux manually and run this script again"
            return 1
            ;;
    esac
    
    if command_exists tmux; then
        print_success "tmux installed successfully ($(tmux -V))"
    else
        print_error "Failed to install tmux"
        return 1
    fi
}

# Function to install micro editor
install_micro() {
    if command_exists micro; then
        print_info "micro editor is already installed ($(micro -version | head -n1))"
        return 0
    fi
    
    print_info "Installing micro editor..."
    
    # Use the official micro installer script
    if command_exists curl; then
        curl https://getmic.ro | bash
        
        # Move micro to a location in PATH
        if [[ -f "micro" ]]; then
            if [[ -w "/usr/local/bin" ]] || sudo -n true 2>/dev/null; then
                sudo mv micro /usr/local/bin/
            else
                mkdir -p "$HOME/.local/bin"
                mv micro "$HOME/.local/bin/"
                
                # Add to PATH if not already there
                if [[ ! ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
                    print_warning "Please add $HOME/.local/bin to your PATH"
                    echo "Add this line to your ~/.bashrc or ~/.zshrc:"
                    echo "export PATH=\"\$HOME/.local/bin:\$PATH\""
                fi
            fi
        fi
    else
        print_error "curl is not installed. Please install curl and try again."
        return 1
    fi
    
    if command_exists micro; then
        print_success "micro editor installed successfully ($(micro -version | head -n1))"
    else
        print_error "Failed to install micro editor"
        return 1
    fi
}

# Function to backup existing configuration
backup_config() {
    local file="$1"
    
    if [[ -f "$file" ]] || [[ -d "$file" ]]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Backing up existing $file to $backup"
        mv "$file" "$backup"
    fi
}

# Function to deploy tmux configuration
deploy_tmux_config() {
    print_info "Deploying tmux configuration..."
    
    backup_config "$HOME/.tmux.conf"
    
    cp "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
    
    print_success "tmux configuration deployed to ~/.tmux.conf"
}

# Function to deploy micro configuration
deploy_micro_config() {
    print_info "Deploying micro editor configuration..."
    
    mkdir -p "$HOME/.config/micro"
    mkdir -p "$HOME/.config/micro/backups"
    
    # Backup existing configs if they exist
    if [[ -f "$HOME/.config/micro/settings.json" ]]; then
        backup_config "$HOME/.config/micro/settings.json"
    fi
    
    if [[ -f "$HOME/.config/micro/bindings.json" ]]; then
        backup_config "$HOME/.config/micro/bindings.json"
    fi
    
    # Deploy new configs
    cp "$SCRIPT_DIR/.config/micro/settings.json" "$HOME/.config/micro/settings.json"
    cp "$SCRIPT_DIR/.config/micro/bindings.json" "$HOME/.config/micro/bindings.json"
    
    print_success "micro editor configuration deployed to ~/.config/micro/"
}

# Function to install micro plugins
install_micro_plugins() {
    if ! command_exists micro; then
        print_warning "micro editor not found, skipping plugin installation"
        return 0
    fi
    
    print_info "Installing recommended micro plugins..."
    
    # Install useful plugins
    local plugins=("comment" "filemanager" "jump" "manipulator")
    
    for plugin in "${plugins[@]}"; do
        print_info "Installing plugin: $plugin"
        micro -plugin install "$plugin" 2>/dev/null || print_warning "Could not install $plugin plugin"
    done
    
    print_success "Micro plugins installation complete"
}

# Main installation function
main() {
    echo ""
    echo "=========================================="
    echo "  Development Environment Setup"
    echo "=========================================="
    echo ""
    
    # Detect OS
    local os
    os=$(detect_os)
    print_info "Detected OS: $os"
    echo ""
    
    # Check for required tools
    if ! command_exists curl && ! command_exists wget; then
        print_error "Either curl or wget is required for installation"
        exit 1
    fi
    
    # Install tmux
    install_tmux "$os"
    echo ""
    
    # Install micro editor
    install_micro
    echo ""
    
    # Deploy configurations
    deploy_tmux_config
    echo ""
    
    deploy_micro_config
    echo ""
    
    # Install micro plugins
    install_micro_plugins
    echo ""
    
    # Final instructions
    echo "=========================================="
    print_success "Installation complete!"
    echo "=========================================="
    echo ""
    print_info "Next steps:"
    echo "  1. Start a new tmux session: tmux new -s dev"
    echo "  2. Open micro editor: micro filename"
    echo "  3. Reload tmux config in existing session: <prefix> + r"
    echo "     (prefix is Ctrl-a by default)"
    echo ""
    print_info "For more information, see the README.md file"
    echo ""
}

# Run main function
main "$@"
