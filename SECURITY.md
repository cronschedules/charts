# Security Policy

## Supported Versions

We release patches for security vulnerabilities for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 0.3.x   | :white_check_mark: |
| 0.2.x   | :x:                |
| < 0.2   | :x:                |

## Reporting a Vulnerability

Please report security vulnerabilities by emailing zakaria@elbazi.co.

Do not report security vulnerabilities through public GitHub issues.

We will acknowledge your email within 48 hours and provide a detailed response within 96 hours indicating the next steps in handling your report.

## Security Features

The charts in this repository implement several security best practices:

- **Non-root containers**: All containers run as non-root users
- **Read-only filesystems**: Containers use read-only root filesystems
- **Security contexts**: Proper security contexts with dropped capabilities
- **RBAC**: Minimal required permissions following least-privilege principle
- **Network policies**: Support for network policy restrictions (configurable)
