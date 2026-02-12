name := env("DEVBOX_ID", "devbox")
debug := env("DEBUG", "")
debug_flag := if debug == "" { "" } else { "--debug" }
definition_name := "devbox.yaml"
project_dir := env("PROJECT_DIR", env("PWD", "."))
project_key := env("PROJECT_KEY", "project")
lima_opts := if debug == "" { "--log-level=info" } else { "--log-level=debug" }

[doc('Build the VM and starts it')]
build:
    @limactl delete -f {{name}}
    @just create
    @just start

[doc('Enter the VM shell')]
shell:
    @limactl shell {{debug_flag}} {{lima_opts}} --workdir /home/${USER}.linux/project {{name}}

[doc('Start the VM')]
start: mk-cache-dirs
    @limactl start {{debug_flag}} {{lima_opts}} --set ".param.PROJECT_DIR = \"{{project_dir}}\"" --set ".param.PROJECT_KEY = \"{{project_key}}\"" {{name}}

[doc('Stop the VM')]
stop:
    @limactl stop {{name}}

[doc('Restart the VM')]
restart:
    @just stop
    @just start

[private]
create:
    @echo ""
    @echo "> Creating VM with name: {{name}}"
    @echo "> - Using project directory: {{project_dir}}"
    @echo ""
    @echo "> ... this might take a minute ☕️ ..."
    @echo ""
    @limactl create {{debug_flag}} {{lima_opts}} --name={{name}} --set ".param.PROJECT_DIR = \"{{project_dir}}\"" --set ".param.PROJECT_KEY = \"{{project_key}}\"" -y {{definition_name}}

[doc('Delete the VM')]
clean: rm-cache-dirs
    @limactl delete -f {{name}}

[doc('List existing VMs')]
list:
    @limactl list --json | jq -r '. | select(.name | match("^devbox-")) | "\(.name)\t\(.status)\t\(.cpus) CPUs\t\(.memory/1024/1024)mb Memory\t\(.param.PROJECT_DIR)"'

[doc('Show this help message')]
help:
    @just --list

[doc('Print the command to setup the PATH environment variable for the devbox')]
setup:
    @echo "# Add the following line to your shell configuration file (e.g., ~/.bashrc or ~/.zshrc) to include the devbox in your PATH:"
    @echo "echo 'export PATH=\"{{env("PWD")}}/scripts:\$PATH\"' >> ~/.bashrc"
    @echo "echo 'export PATH=\"{{env("PWD")}}/scripts:\$PATH\"' >> ~/.zshrc"

[private]
mk-cache-dirs:
    @mkdir -p ~/.local/state/devbox/cache/base-{{project_key}}
    @mkdir -p ~/.local/state/devbox/cache/apt-cache-{{project_key}}

[private]
rm-cache-dirs:
    @rm -rf ~/.local/state/devbox/cache/base-{{project_key}}
    @rm -rf ~/.local/state/devbox/cache/apt-cache-{{project_key}}