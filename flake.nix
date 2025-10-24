{
  description = "EmailAI Go project with Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  nixConfig = {
    # Binary cache configuration for arm64 (Apple Silicon)
    # Note: Removed blind3dd.cachix.org as it may not support arm64
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    # Enable experimental features
    experimental-features = [ "nix-command" "flakes" ];
    # Allow unfree packages for development
    allowUnfree = true;
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Go development tools - try to match runtime go1.25.0 exactly
        goTools = with pkgs; [
          # Try exact matches first, then fallbacks
          (if (builtins.hasAttr "go_1_25_0" pkgs) then go_1_25_0 else
           if (builtins.hasAttr "go_1_25" pkgs) then go_1_25 else
           if (builtins.hasAttr "go_1_24_9" pkgs) then go_1_24_9 else
           go)
          gopls
          go-tools
          golangci-lint
          delve
          gotools
        ];

        # Terraform tools - Using OpenTofu (Open Source Community Edition)
        terraformTools = with pkgs; [
          opentofu
          terraform-ls
        ];

        # Ansible tools
        ansibleTools = with pkgs; [
          ansible
          ansible-lint
        ];

        # React/Node.js tools (for frontend if needed)
        nodeTools = with pkgs; [
          nodejs_20
          yarn
          typescript
        ];

        # Security and Authentication tools
        securityTools = with pkgs; (
          [
            gnupg
            yubikey-manager
            yubikey-personalization
            pcsctools
            openssl
            opensc
            krb5
            libkrb5
          ]
          ++ (if pkgs.stdenv.isDarwin then [ pinentry_mac ] else [ pinentry ])
        );

        # Additional development tools
        devTools = with pkgs; [
          git
          curl
          jq
          yq
          ripgrep
          fd
          fzf
          watchman
          direnv
        ];

      in
      {
        devShells.default = pkgs.mkShell {
          name = "emailai-dev";

          buildInputs = goTools ++ terraformTools ++ ansibleTools ++ nodeTools ++ securityTools ++ devTools;

          shellHook = ''
            echo "🚀 Entering EmailAI development environment"
            echo "Go version: $(go version)"
            echo "OpenTofu version: $(terraform --version 2>/dev/null | head -1 || echo 'not available')"
            echo "Node.js version: $(node --version)"
            echo "Git version: $(git --version)"
            echo "YubiKey Manager version: $(ykman --version 2>/dev/null || echo 'not available')"

            # Setup dotfiles if not already installed
            if [ ! -f ~/.gitconfig.bak ] && [ -d dotfiles ]; then
              echo "Installing dotfiles..."
              mkdir -p ~/.config

              # Backup existing configs
              [ -f ~/.gitconfig ] && cp ~/.gitconfig ~/.gitconfig.bak
              [ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.bak
              [ -f ~/.gnupg/gpg.conf ] && cp ~/.gnupg/gpg.conf ~/.gnupg/gpg.conf.bak

              # Install new configs
              cp dotfiles/git/gitconfig ~/.gitconfig
              cp dotfiles/shell/zshrc ~/.zshrc
              mkdir -p ~/.gnupg && cp dotfiles/security/gpg.conf ~/.gnupg/gpg.conf
              mkdir -p ~/.config && cp dotfiles/ide/vscode-settings.json ~/.config/cursor-settings.json

              echo "Dotfiles installed. Backups created with .bak extension."
            fi

            # Setup git configuration if not already set (redacted defaults)
            if ! git config user.name >/dev/null 2>&1; then
              echo "Setting up git configuration..."
              git config user.name "<REDACTED>"
              git config user.email "<REDACTED>"
              git config user.signingkey "<REDACTED>"
              git config commit.gpgsign true
              git config tag.gpgsign true
              git config core.editor "$(which nano)"
              git config core.hookspath "$PWD/.git-hooks"
              git config core.autocrlf input
              git config gpg.program "$(which gpg)"
              echo "Git configuration applied for this project"
            fi

            # Setup Kerberos if needed
            if [ -f /etc/krb5.conf ]; then
              echo "✅ Kerberos configuration found at /etc/krb5.conf"
              echo "Realm: $(grep 'default_realm' /etc/krb5.conf | cut -d'=' -f2 | tr -d ' ')"
            elif [ -f dotfiles/security/krb5.conf ]; then
              echo "Setting up Kerberos configuration for EXAMPLE.COM..."
              sudo mkdir -p /etc && sudo cp dotfiles/security/krb5.conf /etc/krb5.conf
              echo "Kerberos configuration installed to /etc/krb5.conf"
            else
              echo "ℹ️  No Kerberos configuration found. Set up manually if needed."
            fi

            # Ensure tools are available in PATH
            export PATH="$PATH:/nix/var/nix/profiles/default/bin"

            # Set Go environment for proper tooling and navigation
            export GOPATH="$HOME/Development/go"
            export GO111MODULE="on"
            export CGO_ENABLED="0"

            # Go cache configuration (separate from workspace)
            export GOMODCACHE="$HOME/.cache/go/mod"
            export GOCACHE="$HOME/.cache/go/build"

            # Add OpenTofu to PATH for terraform compatibility
            if command -v tofu >/dev/null 2>&1; then
                export PATH="$(dirname $(which tofu)):$PATH"
                alias terraform='tofu'
                echo "✅ OpenTofu available (terraform commands work)"
            fi

            # Ensure gopls can find Go source
            echo "✅ Go environment configured for development"
          '';

          # Environment variables
          env = {
            GOPROXY = "https://proxy.golang.org,direct";
            GOSUMDB = "sum.golang.org";
            GOTOOLCHAIN = "local";
            GPG_TTY = "$(tty)";
            # Go paths are set in shellHook for portability across OSes
            GO111MODULE = "on";
            CGO_ENABLED = "0";
            # Git configuration
            GIT_AUTHOR_NAME = "<REDACTED>";
            GIT_AUTHOR_EMAIL = "<REDACTED>";
            GIT_COMMITTER_NAME = "<REDACTED>";
            GIT_COMMITTER_EMAIL = "<REDACTED>";
          };
        };
      });
}
