#!/bin/bash
# Higgs TTS 服务启动脚本
# 用法: bash start.sh [--port PORT]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PORT="${2:-12589}"

MODEL_PATH="/home/lvze/models/higgs-tts-4b"

echo "=== Higgs TTS 启动 ==="
echo "模型: ${MODEL_PATH}"
echo "端口: ${PORT}"

# 加载凭据
source ~/.claude/secrets.env 2>/dev/null || true

# 设置镜像源
export HF_ENDPOINT=https://hf-mirror.com

# 激活环境
cd "${SCRIPT_DIR}/sglang-omni"
source .venv/bin/activate

# 启动服务
sgl-omni serve \
  --model-path "${MODEL_PATH}" \
  --port "${PORT}"
