# Ez Claude for Free (EC4F) go

A complete solution to use Claude Code for free, routing requests through the `free-claude-code` proxy to free providers such as NVIDIA NIM.

## 📁 Directory layout

```
EC4F/
├── docs/
│   ├── SETUP_SOP.md      # Full setup SOP (principles, steps, commands, verification)
│   └── QUICK_REFERENCE.md # Quick reference card
├── config/
│   └── .env.template     # Configuration template
│   └── apkey.cfg          # API key configuration file
├── logs/                  # Log directory (created at runtime)
├── scripts/
│   ├── start.sh          # One-click start script
│   ├── stop.sh           # Stop script
│   └── status.sh         # Status check script
└── README.md             # This file
```

## 🚀 Quick start

### 1. Start the proxy server

```bash
./scripts/start.sh
```

### 2. Launch Claude Code

```bash
fcc-claude
```

### 3. Verify operation

In Claude Code, type:

```
/model
```

You should see models such as `nvidia_nim/z-ai/glm4.7`.

## 📖 Detailed documentation

- **Full SOP**: [docs/SETUP_SOP.md](docs/SETUP_SOP.md)  
  Includes principles, requirements, setup steps, core commands, verification, and FAQ.
- **Quick reference**: [docs/QUICK_REFERENCE.md](docs/QUICK_REFERENCE.md)  

## ⚙️ Current status

| Item | Status |
|------|--------|
| fcc-server | ✅ Running (PID: 3755283) |
| Port | ✅ 8082 |
| Model | nvidia_nim/z-ai/glm4.7 |
| Available models | 160+ |
| NVIDIA NIM Key | ✅ Configured |

## 🔗 Related links

- [GitHub: free-claude-code](https://github.com/Alishahryar1/free-claude-code) (23.6k ⭐)
- [NVIDIA NIM API](https://build.nvidia.com)
- [Claude Code official repository](https://github.com/anthropics/claude-code)

## 📝 Notes

This project enables free usage of Claude Code CLI and VSCode extension by routing through free providers.

> ⚠️ Note: Free quota has a rate limit (40 req/min). For higher limits, consider local deployment with Ollama.

---

*Created on 2026-05-11*