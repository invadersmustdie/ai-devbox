# Transparent AI Devbox

An agentic development environment for secure execution of AI coding agents. This project provides a reproducible Lima-based devbox and development tools.

## Features

- **Isolated Development Environment**: Debian-based Lima VM
- **Modern Tooling**: mise for version management
- **Auto-mounting**: Project directory automatically mounted for seamless file access
- **Pre-installed Agents**: claude code, opencode, gemini-cli

## Prerequisites

- macOS, linux or windows (via WSL2)
- [Lima](https://lima-vm.io/) - `brew install lima`
- [Just](https://github.com/casey/just) - `brew install just`
- [jq](https://jqlang.org/) - `brew install jq`

## Quick Start

## Using devbox (Recommended for per-project devboxes)

The `devbox` wrapper script provides a convenient way to manage per-project devbox. Each project directory gets its own isolated devbox instance, identified by a hash of the directory path.

### Setup

Add this repository directory to your PATH for easy access from any project:

run `just setup` and follow the instructions to add the `devbox` script to your PATH:

```bash
# Add to your ~/.zshrc or ~/.bashrc
export PATH="$PATH:/path/to/ai-devbox/scripts"
```

After updating your shell configuration, reload it:
```bash
source ~/.zshrc  # or source ~/.bashrc
```

### Go to your project directory and run:

```bash
devbox
```

After setup is complete, this will create a devbox instance for the project and drop you into a shell inside it. The project directory is mounted at `~/project` for easy access.

To stop the devbox, simply exit the shell and run `devbox stop`.

### Manual Lima VM Creation (for global devbox)

**NOTE**: This is mainly intended for development of the devbox itself. For per-project devboxes, use `devbox` as described above.

```bash
just build
```

This creates a Lima VM named "devbox" with all necessary tools and configurations.

### 2. Enter the devbox shell

```bash
just shell
```

Your project directory is automatically mounted at `~/project`.

### Usage

Navigate to any project directory and run:

```bash
# Enter devbox shell (creates devbox if it doesn't exist)
devbox

# Or pass any just command
devbox build
devbox restart
devbox start
```

**Benefits:**
- **Per-project isolation**: Each project gets its own devbox instance
- **Automatic management**: Creates devbox on first use, prompts for confirmation
- **Seamless workflow**: No need to remember specific devbox names or paths
- **Persistent**: Devbox persists across shell sessions until explicitly removed