# Port Scanner (POSIX sh script)

A lightweight port scanner written in POSIX-compliant shell (`sh`). This script scans a given range of TCP ports on a target IP address using `netcat` (`nc`) and `ping`. It is designed to work in minimal Linux environments such as **Alpine Linux**, **Docker containers**, **OpenWRT**, and other systems with basic POSIX shells.

## Features
- **Minimal dependencies**: Uses `nc` (netcat), `ping`, `expr`, `grep`, and `tr`.
- **Customizable**: Scan a specific IP and port range via command-line arguments.
- **Ping check**: Warns if the target IP is unreachable.
- **POSIX-compliant**: Works in any POSIX-compatible shell (`sh`), ensuring portability to most Unix-based systems.
- **Lightweight**: Runs efficiently on resource-constrained environments like Docker or embedded systems.

## Usage

### Basic Usage
Scan all ports on the local machine (localhost):
```sh
./scan.sh

