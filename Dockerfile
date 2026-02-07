# Example Dockerfile for Development Environment
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install essential tools
RUN apt-get update && apt-get install -y \
    tmux \
    curl \
    git \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    rustc \
    cargo \
    && rm -rf /var/lib/apt/lists/*

# Install micro editor
RUN curl https://getmic.ro | bash && \
    mv micro /usr/local/bin/ && \
    chmod +x /usr/local/bin/micro

# Copy environment configuration
COPY .tmux.conf /root/.tmux.conf
COPY .config/micro /root/.config/micro

# Create workspace directory
WORKDIR /workspace

# Set up tmux as default shell
ENV SHELL=/bin/bash

# Start tmux by default
CMD ["tmux", "new-session", "-s", "workspace"]
