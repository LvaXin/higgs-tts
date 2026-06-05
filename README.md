# Higgs TTS 4B - 本地语音合成

基于 [Higgs Audio v3 TTS 4B](https://hf-mirror.com/bosonai/higgs-audio-v3-tts-4b) 的本地部署方案，支持 100+ 语言语音合成、音色克隆、情感与语音控制。

## 模型参数

| 指标 | 值 |
|------|------|
| 参数量 | 4B |
| 支持语言 | 100+ |
| 码本数 | 8 Codebooks |
| 采样率 | 24kHz |
| 帧率 | 25fps |
| 显存需求 | ~17GB+ |

## 环境要求

- GPU: NVIDIA 4090 12GB（推荐 4 卡，48GB 显存）
- 系统: Linux (WSL2 支持)
- Python 3.12+

## 快速开始

### 1. 启动服务

```bash
bash start.sh
```

自定义端口：`bash start.sh --port 23456`

模型首次加载需要几分钟，等待 GPU 显存分配完毕。

验证服务状态：

```bash
curl http://localhost:12589/health
# 返回 {"status": "healthy"} 即可用
```

### 2. 打开 Web 界面

浏览器直接打开 `web/index.html`，或启动 HTTP 服务：

```bash
cd web
python3 -m http.server 8080
# 访问 http://localhost:8080
```

### 3. 使用

#### 基础合成

在输入框输入文本，点击 **生成语音** 即可。

#### 控制标记

左侧面板提供四类控制标记，点击插入到光标位置：

| 分类 | 说明 | 示例 |
|------|------|------|
| 情感 | 21 种情绪 | `amusement`、`sadness`、`enthusiasm` |
| 风格 | 发声方式 | `singing`、`shouting`、`whispering` |
| 音效 | 非语言声音 | `laughter`、`cough`、`sigh` |
| 韵律 | 语速/音调/停顿 | `speed_slow`、`pause`、`pitch_high` |

> 情感/风格/韵律标记放句首控制整段，音效/停顿放句中需要的位置。

#### 参数调节

| 参数 | 推荐值 | 说明 |
|------|--------|------|
| Temperature | 0.8 | 越低越保守，越高越多样 |
| Top-k | 50 | 越小越确定，越大越随机 |
| Repetition Penalty | 1.0 | > 1 抑制重复 |
| Speed | 1.0 | 播放倍率 |
| Max Tokens | 2048 | 超长文本调大 |

#### 音色克隆

1. 拖放或点击上传参考音频（5-30 秒清晰人声）
2. 可选填写参考音频台词（提升克隆质量）
3. 可选保存音色到浏览器（下次直接复用）
4. 生成语音即可使用克隆音色

> Higgs TTS 无预设音色库。零样本模式使用默认音色。

### API 调用

```bash
# 基础合成
curl http://localhost:12589/v1/audio/speech \
  -H "Content-Type: application/json" \
  -d '{
    "input": "<|emotion:enthusiasm|>Hello! How are you today?",
    "temperature": 0.8,
    "top_k": 50,
    "response_format": "wav"
  }' \
  --output output.wav

# 音色克隆
curl http://localhost:12589/v1/audio/speech \
  -H "Content-Type: application/json" \
  -d '{
    "input": "用我的声音说这句话",
    "ref_audio": "参考音频.wav",
    "ref_text": "参考音频的台词",
    "response_format": "wav"
  }' \
  --output cloned.wav
```

## 项目结构

```
higgs-tts/
├── start.sh              # 服务启动脚本
├── web/
│   └── index.html        # Web 界面（单文件，支持中英切换）
├── models/               # 模型目录
│   └── higgs-audio-v3-tts-4b/
└── sglang-omni/          # SGLang-Omni 推理运行时
    └── .venv/            # Python 虚拟环境
```

## 常见问题

**启动慢？** 正常，8.7GB 模型加载需要几分钟。

**内存不足？** 模型需要 ~17GB+ GPU 显存（4x4090 = 48GB 够用）。

**合成质量差？** 降低 temperature（0.5-0.7）和 top_k（20-30），或调整控制标记位置。

## 许可证

模型: [Higgs Audio v3 TTS 4B](https://hf-mirror.com/bosonai/higgs-audio-v3-tts-4b)
推理运行时: [SGLang-Omni](https://github.com/sgl-project/sglang-omni)
