# Contributing

Thanks for your interest in contributing!

## Developer Certificate of Origin (DCO)
This project uses the DCO. By contributing, you certify that you have the right to submit your changes under the project license and you agree to the DCO terms.

Sign-off your commits with:
```
Signed-off-by: Your Name <your.email@example.com>
```

You can use:
```
git commit -s -m "your message"
```

Hardware-backed signing (YubiKey/GPG) is recommended but not required.

## How to contribute
- Fork the repo and create a feature branch
- Make your changes with tests when applicable
- Ensure `go build` and linters pass
- Open a PR explaining the change and motivation

## Code style
- Go 1.25+, modules enabled
- Keep functions small and readable
- Avoid unnecessary abstractions; prefer clear code

## Security & Secrets
- Do not commit secrets. Use placeholders like `<REDACTED>`.
- Kerberos examples use `EXAMPLE.COM`; replace with your realm locally.
