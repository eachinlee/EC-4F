#!/bin/bash
# Free Claude Code - Stop script
# Usage: ./stop.sh

echo "=========================================="
echo "  Free Claude Code stop script"
echo "=========================================="
echo ""

# Check if any process is running
if pgrep -f "fcc-server" > /dev/null 2>&1; then
    echo "🛑 Stopping fcc-server..."
    # Find all fcc-server related processes
    pids=$(pgrep -f "fcc-server")

    for pid in $pids; do
        echo "   Stopping PID: $pid"
        kill "$pid" 2>/dev/null || true
    done

    sleep 1

    # Re-check
    if pgrep -f "fcc-server" > /dev/null 2>&1; then
        echo "⚠️  Remaining processes found, force terminating..."
        pkill -9 -f "fcc-server" 2>/dev/null || true
    fi

    echo ""
    echo "✅ fcc-server stopped"
else
    echo "ℹ️  fcc-server is not running"
fi

echo ""
echo "=========================================="