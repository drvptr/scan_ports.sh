#!/bin/sh

show_help() {
    echo "Usage: $0 [IP] [START_PORT] [END_PORT]"
    echo
    echo "Parameters:"
    echo "  IP           Target IP address (default: 127.0.0.1)"
    echo "  START_PORT   Start of the port range (default: 1)"
    echo "  END_PORT     End of the port range (default: 65535)"
    echo
    echo "Examples:"
    echo "  $0                     — scan all ports on localhost"
    echo "  $0 192.168.1.10        — scan all ports on 192.168.1.10"
    echo "  $0 192.168.1.10 5900   — scan ports from 5900 to 65535"
    echo "  $0 192.168.1.10 5900 6000 — scan ports from 5900 to 6000"
    echo
}

case "$1" in
    -h|-help|--help)
        show_help
        exit 0
        ;;
esac

# Defaults
TARGET="${1:-127.0.0.1}"
START_PORT="${2:-1}"
END_PORT="${3:-65535}"

# Validate IP format (very basic check)
echo "$TARGET" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}$' || {
    echo "Error: Invalid IP address: $TARGET"
    show_help
    exit 1
}

# Check octets range
OCTETS=$(echo "$TARGET" | tr '.' ' ')
set -- $OCTETS
for octet in "$@"; do
    [ "$octet" -ge 0 ] 2>/dev/null && [ "$octet" -le 255 ] 2>/dev/null || {
        echo "Error: IP octet out of range: $TARGET"
        show_help
        exit 1
    }
done

# Validate ports
expr "$START_PORT" + 0 >/dev/null 2>&1 || {
    echo "Error: START_PORT is not numeric."
    show_help
    exit 1
}
expr "$END_PORT" + 0 >/dev/null 2>&1 || {
    echo "Error: END_PORT is not numeric."
    show_help
    exit 1
}

if [ "$START_PORT" -lt 1 ] || [ "$END_PORT" -gt 65535 ] || [ "$START_PORT" -gt "$END_PORT" ]; then
    echo "Error: Invalid port range (1–65535, and START <= END)."
    show_help
    exit 1
fi

# Ping check
ping -c 1 -W 1 "$TARGET" >/dev/null 2>&1 || echo "Warning: Host $TARGET is not responding to ping."

echo "Scanning ports from $START_PORT to $END_PORT on $TARGET..."

PORT=$START_PORT
while [ "$PORT" -le "$END_PORT" ]; do
    nc -vz -w 1 "$TARGET" "$PORT" 2>&1 | grep -q 'succeeded' && echo "Port $PORT is open"
    PORT=$(expr "$PORT" + 1)
done

echo "Scan complete."

