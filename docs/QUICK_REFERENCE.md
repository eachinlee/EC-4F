# Free Claude Code - Quick Reference Card

## Common Commands

| Command | Description |
|---------|-------------|
| `fcc-server` | Start the proxy server (foreground) |
| `fcc-claude` | Start Claude Code CLI |
| `fcc-init` | Initialize configuration file |
| `pkill -f fcc-server` | Stop the proxy server |

## Quick start/stop

```bash
# Start
./scripts/start.sh

# Check status
./scripts/status.sh

# Stop
./scripts/stop.sh
```

## API verification

```bash
# List models
curl -s http://127.0.0.1:8082/v1/models -H "Authorization: Bearer freecc" | python3 -c "import sys,json; [print(m['display_name']) for m in json.load(sys.stdin)['data'][:5]]"

# Test API call
curl -X POST http://127.0.0.1:8082/v1/messages \
  -H "Authorization: Bearer freecc" \
  -H "Content-Type: application/json" \
  -d '{"model":"nvidia_nim/z-ai/glm4.7","max_tokens":50,"messages":[{"role":"user","content":"Hi"}]}'
```

## Popular model IDs

| Model Name | Model ID |
|------------|----------|
| GLM 4.7 | `nvidia_nim/z-ai/glm4.7` |
| MiniMax M2.5 | `nvidia_nim/minimaxai/minimax-m2.5` |
| MiniMax M2.7 | `nvidia_nim/minimaxai/minimax-m2.7` |
| Kimi K2 | `nvidia_nim/moonshotai/kimi-k2-instruct` |
| DeepSeek V4 | `nvidia_nim/deepseek-ai/deepseek-v4-pro` |
| Qwen3 Coder | `nvidia_nim/qwen/qwen3-coder-480b-a35b-instruct` |
| Llama 3.3 70B | `nvidia_nim/meta/llama-3.3-70b-instruct` |

## Configuration file locations

| File | Path |
|------|------|
| Main config file | `./config/apkey.cfg` |
| Log file | `/tmp/fcc-server.log` |
| Template document | `./docs/SETUP_SOP.md` |

## Switching models

Edit `./config/apkey.cfg`:

```bash
MODEL="nvidia_nim/minimaxai/minimax-m2.5"
```

Then restart the proxy:

```bash
pkill -f fcc-server && fcc-server &
```

## VSCode integration

Add to VSCode `settings.json`:

```json
"claudeCode.environmentVariables": [
  { "name": "ANTHROPIC_BASE_URL", "value": "http://localhost:8082" },
  { "name": "ANTHROPIC_AUTH_TOKEN", "value": "freecc" },
  { "name": "CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY", "value": "1" }
]
```

## URL shortcuts

| Service | URL |
|---------|-----|
| Proxy server | http://127.0.0.1:8082 |
| Admin UI | http://127.0.0.1:8082/admin |
| NVIDIA NIM | https://build.nvidia.com |
| Model explorer | https://build.nvidia.com/explore/discover |
