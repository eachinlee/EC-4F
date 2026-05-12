#!/bin/bash
# Free Claude Code - One-click start script
# Usage: ./start.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/../logs"

# Create log directory
mkdir -p "$LOG_DIR"

echo "=========================================="
echo "  Free Claude Code start script"
echo "=========================================="
echo ""

# Load API key configuration (if present)
APKEY_FILE="$SCRIPT_DIR/../config/apkey.cfg"
if [ -f "$APKEY_FILE" ]; then
    # Extract API_KEY line, allowing whitespace and comments
    API_KEY=$(grep -E "^[[:space:]]*API_KEY[[:space:]]*=" "$APKEY_FILE" | cut -d'=' -f2- | tr -d '"' | tr -d ' ')
    if [ -n "$API_KEY" ]; then
        export NVIDIA_NIM_API_KEY="$API_KEY"
        echo "🔑 Loaded NVIDIA_NIM_API_KEY from apkey.cfg"
    else
        echo "⚠️ apkey.cfg does not contain API_KEY, using default environment or .env"
    fi
else
    echo "⚠️ apkey.cfg not found, please set .env or environment variables as needed"
fi

if pgrep -f "fcc-server" > /dev/null 2>&1; then
    echo "✅ fcc-server is already running"
else
    echo "🚀 Starting fcc-server proxy..."
    cd "$SCRIPT_DIR"
    nohup fcc-server > "$LOG_DIR/fcc-server.log" 2>&1 &
    sleep 2

    if pgrep -f "fcc-server" > /dev/null 2>&1; then
        echo "✅ fcc-server started successfully (PID: $(pgrep -f fcc-server))"
    else
        echo "❌ fcc-server failed to start, please check logs:"
        tail -20 "$LOG_DIR/fcc-server.log"
        exit 1
    fi
fi

echo ""
echo "📡 Proxy server URL: http://127.0.0.1:8082"
echo "🔧 Admin UI: http://127.0.0.1:8082/admin"
echo "📝 Log file: $LOG_DIR/fcc-server.log"
echo ""
echo "=========================================="
echo ""
echo "✅ Setup complete! You can now run the following commands:"
echo ""
echo "  fcc-claude          # Start Claude Code CLI"
echo "  Or use the Claude Code extension in VSCode"
echo ""
echo "Stop service: ./stop.sh"