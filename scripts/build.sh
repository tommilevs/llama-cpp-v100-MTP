#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
SRC="$ROOT/.work/llama.cpp"
BASE=d703d0cafa734579148fd436df1e2d6926b80731
if [[ ! -d "$SRC" ]]; then
    mkdir -p "$ROOT/.work"
    git clone --filter=blob:none --no-checkout https://github.com/1115714829/llama.cpp-v100.git "$SRC"
    git -C "$SRC" checkout --detach "$BASE"
    git -C "$SRC" apply --check "$ROOT/patches/0001-mtp-sampling.patch"
    git -C "$SRC" apply "$ROOT/patches/0001-mtp-sampling.patch"
else
    [[ "$(git -C "$SRC" rev-parse HEAD)" == "$BASE" ]] || exit 1
    git -C "$SRC" apply --reverse --check "$ROOT/patches/0001-mtp-sampling.patch"
fi
cmake -S "$SRC" -B "$ROOT/build" \
    -DCMAKE_BUILD_TYPE=Release -DCMAKE_CUDA_ARCHITECTURES=70 \
    -DGGML_CUDA=ON -DGGML_CUDA_NCCL=ON -DLLAMA_BUILD_TESTS=OFF
cmake --build "$ROOT/build" --parallel "${JOBS:-$(nproc)}" \
    --target llama-server llama-cli llama-quantize
echo "Built: $ROOT/build/bin"
