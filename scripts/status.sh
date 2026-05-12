#!/bin/bash
# Free Claude Code - Status check script
# Usage: ./status.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/../logs"

echo "=========================================="
echo "  Free Claude Code status check"
echo "=========================================="
echo ""

# 1. Check fcc-server process
echo "1️⃣  Proxy server status:"
if pgrep -f "fcc-server" > /dev/null 2>&1; then
    pid=$(pgrep -f "fcc-server" | head -1)
    uptime=$(ps -p "$pid" -o etime= 2>/dev/null | tr -d ' ')
    echo "   ✅ Running (PID: $pid, uptime: $uptime)"
else
    echo "   ❌ Not running"
fi

# 2. Check port 8082
echo ""
echo "2️⃣  Port 8082 listening status:"
if lsof -i :8082 > /dev/null 2>&1; then
    echo "   ✅ Port 8082 is listening"
else
    echo "   ❌ Port 8082 is not listening"
fi

# 3. Check API health
echo ""
echo "3️⃣  API health check:"
if curl -s --max-time 5 http://127.0.0.1:8082/v1/models -H "Authorization: Bearer freecc" > /dev/null 2>&1; then
    model_count=$(curl -s http://127.0.0.1:8082/v1/models -H "Authorization: Bearer freecc" | python3 -c "import sys, json; print(len(json.load(sys.stdin).get('data', [])))" 2>/dev/null || echo "?")
    echo "   ✅ API is healthy (available models: $model_count)"
else
    echo "   ❌ API is unreachable"
fi

# 4. Show recent logs
echo ""
echo "4️⃣  Recent log (last 5 lines):"
if [ -f "$LOG_DIR/fcc-server.log" ]; then
    echo "   ---"
    tail -5 "$LOG_DIR/fcc-server.log" | sed 's/^/   /'
else
    echo "   ℹ️  Log file does not exist"
fi

# 5. Check configuration
echo ""
echo "5️⃣  Current configuration:"
CONFIG_PATH="$SCRIPT_DIR/../config"
APKEY_FILE="$CONFIG_PATH/apkey.cfg"
if [ -f "$APKEY_FILE" ]; then
    nim_key=$(grep -E "^[[:space:]]*API_KEY[[:space:]]*=" "$APKEY_FILE" | cut -d'=' -f2- | tr -d '"' )
    if [ -n "$nim_key" ]; then
        echo "   🔑 NVIDIA NIM API Key: ✅ Set"
    else
        echo "   🔑 NVIDIA NIM API Key: ❌ Not set"
    fi
else
    echo "   ❌ apkey.cfg not found"
fi

echo ""
echo "=========================================="
echo ""
echo "🚀 Start Claude Code: fcc-claude"
echo "🛑 Stop service: ./stop.sh"