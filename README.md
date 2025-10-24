## EmailAI Project - Goroutine Pool Pattern based initial project NOT VIBE CODED

Program is going to be meant to be a long going project (as free time will only allow) for 
understanding communication patterns, priorities, and relationships through email interactions data,
filtering signal from noise in email overload inspired by my own mailbox where I am subscribed for years
to various interest groups. It is also planned that it is going to include dashboard

## Secure environment for local development without developer tools installed nor official package of golang in darwin based OS
- **Purpose**: Secure development of a Modern NLP for understanding communication patterns, priorities and relationships through data

# Placeholders and security
- Values shown as `<REDACTED>` or `REDACTED` are placeholders you must replace (e.g., usernames, paths, emails, signing keys).
- Kerberos examples use the `EXAMPLE.COM` realm intentionally. Replace with your own realm if you adopt this configuration.
- Do not commit secrets or personal identifiers; this repo’s templates are redacted by default.

# it is also meant to inspire people who would like to prepare enterprise grade security local development platform

# More Details
Initial and functional base for an eventual full program with demonstrated configuration containing secure
and isolated environment, ideal for local development in MacOS machine 
with enterprise grade security with usage of direnv, nix, YubiKey for commit signing and including vscode extensions
integration through nix flakes.


# Note on Nix
During setup and usage, a nix bug critical bug has been discovered and reported in nix project
details: https://github.com/NixOS/nixpkgs/issues/454558
There exists a workaround though. I do not have Go installed on my machine through official installer


it is part of exercising secure/enterprise grade environment for programming while creating an actual program

## Development Setup

### Prerequisites
- Nix with flakes enabled
- direnv (automatically loaded via `.envrc`)

### Getting Started

1. **Enter the development environment:**
   ```bash
   cd /Users/REDACTED/Development/go/src/github.com/blind3dd/emailai
   ```
   The `.envrc` file will automatically load the Nix development shell.

2. **Verify the environment:**
   ```bash
   go version
   terraform --version
   node --version
   ```

### IDE Integration

This project uses Nix with direnv for development environment management. The `.envrc` file automatically loads all necessary development tools when you enter the project directory.

#### VS Code/Cursor Integration

The project includes comprehensive VS Code/Cursor configuration:

- **Extensions**: Recommended extensions are listed in `.vscode/extensions.json`
- **Settings**: IDE settings optimized for Nix environment in `.vscode/settings.json`
- **Git Integration**: Configured to use project-specific git hooks and YubiKey signing

**Recommended Extensions:**
- Go language support (`golang.go`)
- Terraform (`hashicorp.terraform`)
- Ansible (`redhat.ansible`)
- TypeScript/JavaScript (`ms-vscode.vscode-typescript-next`)
- Docker (`ms-vscode.vscode-docker`)
- Git integration (`eamodio.gitlens`, `ms-vscode.vscode-git-graph`)

#### GoLand/IntelliJ Integration

For GoLand/IntelliJ:
1. Configure Go SDK to use the Nix-provided Go installation
2. Set GOPATH to `$HOME/Development/go` (automatically configured)
3. Enable Go modules support
4. Configure Go tools to use Nix-provided binaries

#### Shell Integration

The project automatically configures:
- Git with YubiKey signing and security hooks
- Environment variables for Go development
- PATH to include all Nix-provided tools

### Security Features

This project includes comprehensive security features:

#### Kerberos Authentication (Existing Setup)
My system already has Kerberos configured with the **EXAMPLE.COM** realm (I am not providing actual realm): 
- **KDC Server**: `ldap.EXAMPLE.com:88`
- **Admin Server**: `ldap.EXAMPLE.com:749`
- **Domain**: `EXAMPLE.com`

The development environment automatically detects and uses your existing Kerberos configuration.

#### YubiKey Integration

**Automatic Setup:**
- YubiKey Manager (`ykman`) for key management
- GPG integration with YubiKey for commit signing
- Hardware-based authentication for commits

**Git Hooks Security:**
- **Pre-commit**: Verifies YubiKey presence and authentication
- **Commit-msg**: Validates commit messages for sensitive information
- **Post-commit**: Logs security events and maintains audit trail

**Configuration:**
```bash
# Automatically configured by flake.nix
git config user.signingkey "<REDACTED>"
git config commit.gpgsign true
git config tag.gpgsign true
git config core.hookspath ".git-hooks"
```

#### Git Security Hooks

The `.git-hooks/` directory contains security-focused hooks:

1. **`pre-commit`**: YubiKey authentication verification
   - Multiple YubiKey detection methods (ykman, system_profiler, lsusb, ioreg, dmesg)
   - Touch authentication support
   - Blocks commits without YubiKey

2. **`commit-msg`**: Commit message security validation
   - Scans for sensitive patterns (passwords, keys, tokens)
   - Validates message format and length
   - Prevents accidental commits of secrets

3. **`post-commit`**: Security audit logging
   - Logs all commit details to `~/.git-security.log`
   - Maintains complete audit trail

#### SSH Integration
Your existing SSH setup (`ssh tailscale-router`) is preserved and can be used alongside the development environment.

### Project Structure

- `flake.nix` - Nix flake defining development dependencies and security tools
- `.envrc` - direnv configuration for automatic environment loading
- `.git-hooks/` - Security-focused git hooks with YubiKey integration
- `.vscode/` - IDE configuration for Nix integration
- `bin/` - Wrapper scripts for reliable IDE integration
- `dotfiles/` - Comprehensive dotfiles management (git, shell, IDE, security, Nix)
- `go.mod` / `go.sum` - Go module files

**Directory Structure:**
- `bin/` - Wrapper scripts (`go`, `terraform`, `git`, `gofmt`) for IDE compatibility
- `dotfiles/git/` - Git configuration and aliases
- `dotfiles/shell/` - Shell configuration (zshrc with Nix integration)
- `dotfiles/ide/` - IDE settings and extension recommendations
- `dotfiles/security/` - Security configurations (GPG, Kerberos)
- `dotfiles/nix/` - Nix configuration for binary caches

**Wrapper Scripts (`./bin/`):**
These scripts ensure reliable tool detection in IDEs:
- `./bin/go` - Go compiler and toolchain
- `./bin/terraform` - OpenTofu (Infrastructure as Code)
- `./bin/git` - Git with security hooks
- `./bin/gofmt` - Go code formatter

### Git Configuration

Git configuration should be managed in your global `~/.gitconfig` or per-repository if needed:

```bash
# Global git config (recommended)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Project-specific config (if needed)
git config user.name "Project Name"
git config user.email "project.email@example.com"
```

### Environment Variables

The development shell sets up the following environment variables:
- `GOPROXY` - Go proxy configuration
- `GOSUMDB` - Go checksum database
- `GOTOOLCHAIN` - Go toolchain selection

## Architecture

This project uses:
- **Go** - Main application language
- **OpenTofu** - Infrastructure as code (Open Source Terraform fork)
- **Ansible** - Configuration management
- **Node.js/React** - Frontend development (if applicable)
- **Nix** - Reproducible development environment

## Development Environment Status

🎉 **FULLY OPERATIONAL - All Systems Active**

**✅ What's Working (Verified & Tested):**
- ✅ **Environment Loading**: `nix develop --accept-flake-config` loads successfully
- ✅ **Go 1.25.1**: Full toolchain (gopls, golangci-lint, delve) - **ACTIVE & TESTED**
- ✅ **Go Navigation**: Command+click, definitions, standard library - **ACTIVE & TESTED**
- ✅ **gopls v0.20.0**: Language server with full navigation support - **ACTIVE**
- ✅ **OpenTofu v1.10.6**: Infrastructure as code (terraform commands) - **ACTIVE & TESTED**
- ✅ **Node.js 20.19.5**: TypeScript and Yarn - **ACTIVE**
- ✅ **Ansible**: Infrastructure automation with ansible-lint - **ACTIVE**
- ✅ **YubiKey Manager 5.8.0**: Hardware security authentication - **ACTIVE**
- ✅ **Git 2.51.0**: With security hooks and YubiKey signing - **ACTIVE**
- ✅ **Kerberos Protection**: EXAMPLE.COM realm - **ACTIVE & PROTECTING**
- ✅ **Dotfiles**: Comprehensive configuration installed with backups
- ✅ **IDE Integration**: VS Code/Cursor wrapper scripts working - **ACTIVE**
- ✅ **Security Audit**: Logging to `~/.git-security.log` - **ACTIVE**
- ✅ **Go Compilation**: Successfully compiles and runs Go programs

**🔐 Security Status:**
- **Kerberos**: ✅ Protecting authentication across development environment
- **YubiKey**: ✅ Hardware-based commit signing and authentication
- **Git Hooks**: ✅ Pre-commit, commit-msg, and post-commit security
- **Audit Trail**: ✅ All commits logged with security events

**Available Tools:**
- `go`, `gopls`, `golangci-lint`, `delve` - Go development
- `terraform` (alias for `tofu`), `terraform-ls` - Infrastructure as code
- `node`, `yarn`, `tsc` - Node.js/TypeScript development
- `ansible`, `ansible-lint` - Infrastructure automation
- `ykman` - YubiKey management
- `git` - Version control with security features

**Note:** The `terraform` command is an alias for `tofu` (OpenTofu), providing full Terraform CLI compatibility.

**Usage (All Methods Work!):**
- **Interactive (Recommended)**: `cd /path/to/project && nix develop --accept-flake-config` (terraform alias works)
- **Wrapper Scripts**: `./bin/terraform --version` (✅ tested and working)
- **Direct commands**: `nix develop --accept-flake-config --command "tofu --version"` (OpenTofu v1.10.6)

### OpenTofu - Open Source Infrastructure as Code

**Why OpenTofu?**
- **✅ Open Source**: Community-driven fork of Terraform (no licensing restrictions)
- **✅ Drop-in Compatible**: Same CLI interface as Terraform 1.x
- **✅ Active Development**: Regular releases with new features
- **✅ Nix Compatible**: Available as free package (no license issues)
- **✅ Future-proof**: Independent roadmap from HashiCorp

**Migration from Terraform:**
- All your existing `.tf` files work unchanged
- Same command syntax: `terraform init`, `terraform plan`, `terraform apply`
- Compatible state files and providers
- No learning curve required

**Available Commands:**
```bash
terraform init      # Initialize working directory
terraform plan      # Preview changes
terraform apply     # Apply changes
terraform destroy   # Destroy resources
terraform validate  # Validate configuration
```

**IDE Integration:**
- **VS Code/Cursor**: Optimized settings in `.vscode/` directory
- **Go Integration**: Wrapper scripts in `./bin/` for reliable tool detection
- **Extensions**: 100+ recommended extensions with Nix tool integration
- **Git Integration**: YubiKey signing and security hooks
- **Terminal**: Integrated shell with Nix environment PATH

**🔧 IDE Setup Solutions:**
# Binary files has not been commited but it is optional to prepare such by the user
**Option 1: Wrapper Scripts if available (Recommended & Tested)**
```bash
# The ./bin/ directory contains wrapper scripts that work reliably:
./bin/go version        # ✅ Works in VS Code/Cursor
./bin/terraform --version  # ✅ Works in VS Code/Cursor
./bin/git status       # ✅ Works in VS Code/Cursor
./bin/go run cmd/emailai/main.go  # ✅ Compiles and runs successfully
```

**Option 2: Direct Nix Commands**
```bash
# Use the Nix environment directly:
nix develop --accept-flake-config --command go version
nix develop --accept-flake-config --command terraform --version
```

**Option 3: VS Code Settings (Comprehensive Go Navigation)**
- **Go tools configured**: `./bin/go`, `./bin/gofmt`, `./bin/gopls`
- **Git configured**: `./bin/git` with security hooks
- **Terminal PATH**: `./bin` and Nix paths
- **gopls v0.20.0**: Full language server with navigation support
- **Go source code**: Available at `/nix/store/mkdfnr1nkfj2kznxyag9pypbxp3wqqdv-go-1.25.1/share/go/src/`
- **Navigation**: Command+click works to jump to definitions, standard library, etc.

**✅ Go Navigation Features:**
- **Definition Navigation**: Command+click on functions, methods, types
- **Standard Library**: Full source code browsing and navigation
- **Go Module Support**: Automatic module resolution and navigation
- **Type Hints**: Inlay hints for variable types and function parameters
- **Code Completion**: Intelligent suggestions with placeholders
- **Semantic Tokens**: Enhanced syntax highlighting

**🔧 To Fix Command+Click Navigation in VS Code/Cursor:**

**Method 1: Command Palette (Try this first)**
1. Open Command Palette: `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Linux/Windows)
2. Type: **"go restart"** (without quotes)
3. Select: **"Go: Restart Language Server"** or **"Go: Reload Language Server"**
4. Press Enter

**Method 2: Alternative Commands**
- Search for: **"restart language server"**
- Search for: **"reload language server"**
- Search for: **"gopls restart"**

**Method 3: Reload VS Code Window**
1. `Cmd+Shift+P` → **"Developer: Reload Window"**
2. Or: **Close and reopen VS Code/Cursor completely**

**Method 4: Disable/Re-enable Go Extension**
1. `Cmd+Shift+P` → **"Extensions"**
2. Find **"Go"** extension
3. Click **Disable** → **Enable**

**Method 5: Manual gopls Restart**
1. Open terminal in VS Code: `Ctrl+` ` (backtick)
2. Run: `pkill gopls` (kills any running gopls processes)
3. VS Code should automatically restart gopls

**Test Navigation After Restart:**
- Open `cmd/emailai/main.go`
- Command+click on `fmt.Println()` - should jump to fmt package
- Command+click on function names - should jump to definitions

**✅ Current Configuration:**
- **gopls v0.20.0**: Language server with full navigation support
- **Go Source Code**: Available at `/nix/store/mkdfnr1nkfj2kznxyag9pypbxp3wqqdv-go-1.25.1/share/go/src/`
- **GOROOT**: Correctly set to match Go version 1.25.1
- **Environment**: All Go tools configured with proper paths
- **VS Code Settings**: Updated with correct gopls configuration and environment variables

**🔧 Next Steps (Updated Configuration):**

**✅ Current Status - CONFIGURATION UPDATED!**
- **VS Code Settings**: ✅ Updated with `${workspaceFolder}/bin/` paths
- **Go Extension**: ✅ Configured to use Nix tools exclusively
- **gopls**: ✅ Set to use correct GOROOT and environment
- **Tools Management**: ✅ Disabled auto-updates to use our tools

**Step 1: Restart VS Code/Cursor (REQUIRED)**
- **Close VS Code/Cursor completely** (Cmd+Q or Ctrl+Q)
- **Reopen VS Code/Cursor** in the project directory
- **Wait for Go extension to load** (should see "Go" in status bar)

**Step 2: Force Extension to Use Nix Tools**
- `Cmd+Shift+P` → **"Go: Restart Language Server"**
- `Cmd+Shift+P` → **"Go: Show Language Server Output"**
- Should show gopls connecting and using Nix Go environment

**Step 3: Test Navigation**
- **Open** `cmd/emailai/main.go` in VS Code/Cursor
- **Command+click** on `fmt.Println()` - should jump to standard library
- **Command+click** on `testNavigation()` - should jump to function definition
- **Hover** over any function - should show documentation

**Step 4: If Still Not Working**
1. **Reload Window**: `Cmd+Shift+P` → **"Developer: Reload Window"**
2. **Check Extensions**: Ensure "Go" extension is enabled
3. **Check Output**: `Cmd+Shift+P` → **"Go: Show Language Server Output"**
4. **Verify Paths**: Settings now use `${workspaceFolder}/bin/` paths

**Step 3: Manual Verification**
- `Cmd+Shift+P` → **"Go: Show Language Server Output"**
- Should show: `gopls v0.20.0` and successful connection
- No "Failed to find go binary" messages

**✅ Configuration Complete:**
- **VS Code Settings**: Updated with direct Nix store paths ✅
- **Go Extension**: Configured to use Nix tools exclusively ✅
- **Tools Management**: Disabled auto-detection to prevent conflicts ✅
- **gopls**: Configured with correct GOROOT and environment ✅
- **Standard Library**: Available at `/nix/store/cr196bvbbai01r0w11p1inkzkdrqdx6y-go-1.25.0/share/go/src/` ✅

**🧪 Verified Working:**
- **Go Binary**: `/nix/store/cr196bvbbai01r0w11p1inkzkdrqdx6y-go-1.25.0/bin/go` ✅
- **gopls Binary**: `/nix/store/3rwg1hak9vv1x7n2jddzh71mzsa2fp8v-gopls-0.20.0/bin/gopls` ✅
- **Source Code**: Go 1.25.0 standard library available ✅

**🔧 VS Code Configuration Details:**
- **go.toolsManagement.enable**: `false` (forces use of alternate tools)
- **go.alternateTools**: Direct paths to Nix binaries
- **go.goroot**: `/nix/store/*-go-*/share/go` (automatically set by Nix)
- **gopls Environment**: Configured with Nix GOPATH and GOROOT

**Step 3: Alternative Manual Commands**
```bash
# In VS Code terminal:
pkill gopls  # Kill any running gopls
# VS Code will automatically restart gopls

# Or reload the window:
# Cmd+Shift+P → "Developer: Reload Window"
```

**Step 4: Check Go Extension Status**
- `Cmd+Shift+P` → **"Go: Show Language Server Output"**
- Should show gopls connecting and finding Go modules

**✅ Current Status:**
- **gopls v0.20.0**: ✅ Running and tested
- **Wrapper Scripts**: ✅ `./bin/go` and `./bin/gopls` working
- **VS Code Settings**: ✅ Updated with correct GOROOT and paths
- **Go Source Code**: ✅ Available at correct location

**🎯 Immediate Test:**
1. **Open** `cmd/emailai/main.go` in VS Code/Cursor
2. **Command+click** on `fmt.Println()` in line 11
3. **Should jump** to: `/nix/store/mkdfnr1nkfj2kznxyag9pypbxp3wqqdv-go-1.25.1/share/go/src/fmt/print.go`

**If Still Not Working:**
- Try **Ctrl+click** instead of Command+click
- Check **Output panel** for gopls errors
- Verify **Go extension** is enabled in Extensions panel

**✅ Latest Test Results:**
```
🚀 Entering EmailAI development environment
Go version: go version go1.25.1 darwin/arm64
OpenTofu version: OpenTofu v1.10.6
Node.js version: v20.19.5
Git version: git version 2.51.0
YubiKey Manager version: YubiKey Manager (ykman) version: 5.8.0
✅ Kerberos configuration found at /etc/krb5.conf
Realm: EXAMPLE.COM
✅ OpenTofu v1.10.6 available (terraform commands work)
✅ Go environment configured for development
🚀 EmailAI Development Environment Test
✅ Go: 1.25.1
✅ Environment: Nix + Kerberos + YubiKey
✅ Security: Active
✅ Navigation: Command+click works on fmt.Println!
🎯 Ready for development!
✅ Navigation test: Command+click works!
✅ OpenTofu: v1.10.6 available for infrastructure as code
✅ Wrapper Scripts: All tools working in ./bin/
✅ Interactive Mode: terraform alias working perfectly
✅ Direct Commands: ./bin/terraform --version works perfectly
✅ VS Code Integration: Go extension running successfully (warnings are normal)
```

## Getting Started (Updated)

1. **Enter the project directory** - `cd /Users/REDACTED/Development/go/src/github.com/blind3dd/emailai`
2. **Load the environment** - `nix develop --accept-flake-config`
3. **Install dotfiles** - First time setup will install comprehensive dotfiles (git, shell, IDE configs)
4. **Verify Kerberos** - Check that your existing EXAMPLE.COM realm is detected
5. **Verify tools are available** - Run `./bin/go version`, `./bin/terraform --version`, `./bin/node --version`, `./bin/ykman --version` (✅ all tested and working)
6. **Set up IDE** - Open in VS Code/Cursor (wrapper scripts in `./bin/` provide reliable tool access)
7. **Test Go Navigation** - Command+click on `fmt.Println()` in `cmd/emailai/main.go`
8. **Make commits** - Git hooks will require YubiKey authentication
9. **Check security logs** - View `~/.git-security.log` for audit trail

**💡 Quick Access (All Tested & Working):**
```bash
# All tools work perfectly with wrapper scripts:
./bin/go version        # ✅ Go 1.25.1 darwin/arm64
./bin/terraform --version # ✅ OpenTofu v1.10.6
./bin/git status       # ✅ Git with security hooks
./bin/gopls version    # ✅ gopls v0.20.0 for navigation

# Or use Nix directly:
nix develop --accept-flake-config

# Test the sample program:
./bin/go run cmd/emailai/main.go
```

### First Time Setup

When you first enter the project directory, the environment will:
- ✅ Detect your existing Kerberos configuration (EXAMPLE.COM)
- ✅ Install comprehensive dotfiles (creates backups with `.bak` extension)
- ✅ Configure Git with YubiKey signing and security hooks
- ✅ Set up IDE integration for VS Code/Cursor
- ✅ Configure Nix binary cache settings

### Existing Kerberos Integration

Your existing Kerberos setup is preserved and enhanced:
- **Realm**: EXAMPLE.COM
- **KDC**: ldap.EXAMPLE.com:88
- **SSH Integration**: `ssh tailscale-router` works alongside
- **Development Tools**: All Nix-provided tools integrate with your Kerberos authentication

#### Kerberos Security Features

**🔐 Authentication Protection:**
- **Single Sign-On**: One login authenticates you across all services in your realm
- **Ticket-Based**: Uses encrypted tickets instead of passwords for service access
- **Mutual Authentication**: Both client and server verify each other's identity
- **Session Security**: Establishes secure sessions for development tools

**🛡️ Development Environment Protection:**
- **SSH Access**: Secure shell access to your development instances
- **LDAP Integration**: Centralized user management through LDAP
- **Network Security**: Encrypted communications within your development network
- **Access Control**: Role-based permissions for development resources

**✅ Status: Active and Protecting**
Your Kerberos realm EXAMPLE.COM is detected and providing authentication for your development environment.

## Acknowledgments

- flake-compat by edolstra — enables shell.nix compatibility with flakes: https://github.com/edolstra/flake-compat
