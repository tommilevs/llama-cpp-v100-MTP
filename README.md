# llama-cpp-v100-MTP

Reproducible Qwen27B host-MTP backport for Tesla V100.

Upstream: https://github.com/1115714829/llama.cpp-v100

Base: `d703d0cafa734579148fd436df1e2d6926b80731`.
Sampler fix: `627b4bdeb31cc73ce2fd6eee15c160fec14c4f5d`.
Patched source: `de805d927a4b60feb4ed0488187b38907a5e2669`.

The following upstream commit cc624994 removed host hidden-state fallback and required a device sink implemented for qwen4exp, not qwen35. This recipe retains host MTP and backports the sparse-logits sampler fix. Patch authorship and upstream MIT license are retained.

This repository contains the patch and reproducible build recipe, rather than another full source mirror.

## Build

Requires Git, CMake, C++ compiler, CUDA 12.8 with SM70 support, and NCCL development files.

```bash
git clone https://github.com/tommilevs/llama-cpp-v100-MTP.git
cd llama-cpp-v100-MTP
bash scripts/build.sh
```

Binaries appear in `build/bin`. Set JOBS to limit compile concurrency. The script does not install drivers, download models or start services. Use a compatible GGUF with embedded MTP weights and `--spec-type draft-mtp`; mixed `draft-mtp,ngram-mod` was also checked.

`GGML_CUDA_PEER_MAX_BATCH_SIZE` is absent from this CUDA source; adding it as a CMake definition has no effect. No claim is made that this sampler fix resolves GPU/NVLink Xid failures.

See [validation](VALIDATION.md).
