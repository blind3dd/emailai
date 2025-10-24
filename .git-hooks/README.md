# Git Security Hooks

This directory contains security-focused git hooks that enforce secure development practices.

## Hooks Overview

### 1. `pre-commit` - YubiKey Authentication
- **Purpose**: Ensures commits are only allowed when a YubiKey is present and authenticated
- **Security**: Blocks commits if YubiKey is not detected or authentication fails
- **Features**:
  - Multiple detection methods (ykman, system_profiler, lsusb, ioreg, dmesg)
  - Touch authentication support
  - Detailed logging and error messages

### 2. `commit-msg` - Commit Message Security
- **Purpose**: Validates commit messages for security best practices
- **Security**: Prevents sensitive information from being included in commit messages
- **Features**:
  - Scans for sensitive patterns (passwords, keys, tokens, etc.)
  - Validates commit message format
  - Enforces minimum length requirements

### 3. `post-commit` - Security Logging
- **Purpose**: Logs security events after successful commits
- **Security**: Maintains audit trail of all commits
- **Features**:
  - Logs commit details (hash, author, date, branch, message)
  - Writes to security log file (`~/.git-security.log`)
  - Provides security event notifications

## Installation

The hooks are automatically configured via the git config file:
```bash
[core]
    hooksPath = ~/.git-hooks
```

## Requirements

- **YubiKey**: Physical YubiKey device for authentication
- **ykman**: YubiKey Manager (optional, for enhanced authentication)
- **macOS**: Optimized for macOS with system_profiler and ioreg support

## Usage

### Normal Workflow
1. Insert YubiKey into USB port
2. Run `git commit` as usual
3. Touch YubiKey when prompted for authentication
4. Commit proceeds if authentication succeeds

## Security Features

- **Hardware Authentication**: Requires physical YubiKey presence
- **Touch Authentication**: Prevents unattended commits
- **Message Validation**: Prevents sensitive data in commit messages
- **Audit Logging**: Maintains complete commit history
- **Multiple Detection**: Uses various methods to detect YubiKey

## Troubleshooting

### YubiKey Not Detected
1. Ensure YubiKey is properly inserted
2. Check USB connection
3. Try different USB port
4. Verify YubiKey is not locked

### Authentication Failed
1. Touch YubiKey when prompted
2. Ensure YubiKey is not in sleep mode
3. Check YubiKey battery (if applicable)
4. Verify YubiKey is not locked

### Installation Issues
1. Ensure hooks are executable: `chmod +x ~/.git-hooks/*`
2. Verify git config: `git config --get core.hooksPath`
3. Check hook permissions: `ls -la ~/.git-hooks/`

## Security Log

All commits are logged to `~/.git-security.log` with the following format:
```
YYYY-MM-DD HH:MM:SS: COMMIT - <hash> - <author> - <branch> - <message>
```

## Customization

You can modify the hooks to:
- Add additional YubiKey detection methods
- Customize sensitive pattern detection
- Modify security logging format
- Add additional validation rules
