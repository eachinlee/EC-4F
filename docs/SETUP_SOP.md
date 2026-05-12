# Ez Claude for Free Full Setup SOP

> Use the Repository Source: https://github.com/Alishahryar1/free-claude-code

---

## 📋 Table of Contents

1. [Principles](#principles)
2. [Requirements](#requirements)
3. [Setup Steps](#setup-steps)
4. [Core Commands](#core-commands)
5. [Verification](#verification)
6. [FAQ](#faq)

---

## Principles

### Core concept

```
Original: Claude Code → Anthropic API (paid) 
Now: Claude Code → free-claude-code proxy → NVIDIA NIM / OpenRouter (free) 
```

### How it works

```
┌─────────────────────┐      Anthropic API format       ┌──────────────────────┐
│   Claude Code CLI   │ ─────────────────────────▶ │   Free Claude Code    │
│   or VSCode ext.   │      /v1/messages            │   Proxy (localhost)   │
└─────────────────────┘                              └──────────┬───────────┘
                                                      │
                         ┌───────────────────────┼───────────────────────┐
                         │                       │                       │
                         ▼                       ▼                       ▼
                ┌──────────────┐      ┌──────────────┐      ┌──────────────┐
                │ NVIDIA NIM   │      │ OpenRouter   │      │   Ollama     │
                │ (free 40/min)│      │ (free models)│      │ (local)      │
                └──────────────┘      └──────────────┘      └──────────────┘
```

### Why it's free

1. **NVIDIA NIM** offers a free quota (40 req/min) that we route Claude Code requests through.
2. **free-claude-code** converts Anthropic messages to OpenAI‑compatible format.
3. Claude Code only sees the `ANTHROPIC_BASE_URL` endpoint, unaware of the underlying provider.

### Supported providers

| Provider | Cost | Rate limit | Suitable for |
|----------|------|-----------|--------------|
| **NVIDIA NIM** | Free | 40 req/min | Everyday development (default) |
| **OpenRouter** | Free / paid | Varies | Model diversity |
| **DeepSeek** | Cheap | Varies | Direct Anthropic compatibility |
| **LM Studio** | Free (local) | Unlimited | Privacy, offline |
| **llama.cpp** | Free (local) | Unlimited | Lightweight local inference |
| **Ollama** | Free (local) | Unlimited | Full‑local deployment |
| **Kimi** | Tiered | Tiered | Moonshot AI models |
| **Wafer** | Tiered | Tiered | Anthropic‑compatible endpoints |

---

## Requirements

### Software

| Software | Version | Notes |
|----------|---------|-------|
| Python | 3.14+ | Runtime for the proxy server |
| uv | latest | Python package manager |
| Claude Code | 2.1+ | Official AI coding assistant |
| NVIDIA NIM API Key | – | Free registration required |

### Obtaining a NVIDIA NIM API Key

1. Visit https://build.nvidia.com/settings/api-keys
2. Sign in (Google/GitHub)
3. Click **Get API Key**
4. Copy the key

### Hardware

- Linux/macOS/Windows
- Internet connection (to call NVIDIA NIM API)

---

## Setup Steps

### Step 1: Install Python 3.14 and uv

```bash
# Install uv (if not already installed)
curl -LsSf https://astral.sh/uv/install.sh | sh
uv self update

# Install Python 3.14
uv python install 3.14
```

### Step 2: Install free-claude-code proxy

```bash
uv tool install "git+https://github.com/Alishahryar1/free-claude-code.git"
```

### Step 3: Configure API key

Create or edit `./config/apkey.cfg`:

```bash
cat > ./config/apkey.cfg <<'EOF'
API_KEY=YOUR_NVIDIA_NIM_API_KEY
EOF
```

### Step 4: Optional additional environment variables

If you need custom model selection or other variables, edit `~/.config/free-claude-code/.env` or export them before running scripts.

### Step 5: Start the proxy server

```bash
# Foreground (for testing)
fcc-server

# Background
nohup fcc-server > logs/fcc-server.log 2>&1 &
```

After starting you should see:

```
Server URL: http://127.0.0.1:8082
Admin UI: http://127.0.0.1:8082/admin
```

### Step 6: Launch Claude Code

```bash
fcc-claude
```

### Step 7: VSCode integration (optional)

Add to VSCode `settings.json`:

```json
"claudeCode.environmentVariables": [
  { "name": "ANTHROPIC_BASE_URL", "value": "http://localhost:8082" },
  { "name": "ANTHROPIC_AUTH_TOKEN", "value": "freecc" },
  { "name": "CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY", "value": "1" }
]
```

---

## Core Commands

- `fcc-server` – start the proxy (default port 8082)
- `fcc-claude` – launch Claude Code CLI
- `fcc-init` – create the initial `.env` file (optional)
- `free-claude-code` – alias for `fcc-server`

---

## Verification

### 1. Check if the proxy server is running

```bash
./scripts/status.sh
```

### 2. Verify model list

```bash
curl -s http://127.0.0.1:8082/v1/models -H "Authorization: Bearer freecc"
```

You should receive a JSON list of available models.

### 3. Test a simple API call

```bash
curl -X POST http://127.0.0.1:8082/v1/messages \
  -H "Authorization: Bearer freecc" \
  -H "Content-Type: application/json" \
  -d '{"model":"nvidia_nim/z-ai/glm4.7","max_tokens":50,"messages":[{"role":"user","content":"Hi"}]}'
```

---

## FAQ

### Q1: Rate limiting?

NVIDIA NIM free quota is 40 req/min. `free-claude-code` already applies protection (default 1 req/3 sec). For higher limits, you can:
- Register multiple NVIDIA NIM accounts
- Use OpenRouter free models
- Deploy local providers (Ollama)

### Q2: Model responses are slow?

- NVIDIA NIM servers are overseas, leading to higher latency.
- Switch to a local provider (Ollama) for faster responses.
- Use a smaller model.

### Q3: How to change the model?

Edit `~/.config/free-claude-code/.env`:

```bash
MODEL="nvidia_nim/minimaxai/minimax-m2.5"
```

Or use the Admin UI at http://127.0.0.1:8082/admin.

### Q4: How to configure multi‑model routing?

```bash
MODEL_OPUS="nvidia_nim/moonshotai/kimi-k2.6"    # Opus tier uses Kimi
MODEL_SONNET="nvidia_nim/deepseek-ai/deepseek-v4-flash"  # Sonnet tier uses DeepSeek
MODEL_HAIKU="nvidia_nim/google/gemma-3-4b-it"  # Haiku tier uses Gemma
```

### Q5: How to add Discord bot integration?

Add to `.env`:

```bash
MESSAGING_PLATFORM="discord"
DISCORD_BOT_TOKEN="your-bot-token"
ALLOWED_DISCORD_CHANNELS="123456789"
```

### Q6: How to add Telegram bot integration?

```bash
MESSAGING_PLATFORM="telegram"
TELEGRAM_BOT_TOKEN="123456789:ABC..."
ALLOWED_TELEGRAM_USER_ID="your-user-id"
```

### Q7: How to run local models?

#### Ollama

```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama pull llama3.1
OLLAMA_BASE_URL="http://localhost:11434"
MODEL="ollama/llama3.1"
```

#### LM Studio

Set `LM_STUDIO_BASE_URL="http://localhost:1234/v1"` in `.env`.

---

## Advanced usage

- Create a systemd service to start `fcc-server` on boot.
- Use `fcc-init` to generate a default `.env` (optional).
- Enable logging flags in `.env` for deeper debugging.

---

*Created on 2026-05-11*
