# Validation: 2026-10-15

Four Tesla V100-SXM2-16GB, CUDA12.8, NCCL, tensor split1,1,1,1. Qwen3.8-27B Uncensored HauhauCS Aggressive Q4_K_P and matching BF16 mmproj. Context8192, batch128, ubatch64, Q4_0 K/V, Flash Attention, one slot, draft length3.

Before patch: a short text request at temperature0.7 reproducibly aborted with top-k-only logits and GGML_ASSERT(logits != nullptr).

After patch: seven requests each with draft-mtp alone and draft-mtp,ngram-mod; all14 returned HTTP200. Each run covered text T0, T0.0001, T0.7, repeated T0; a red64x64PNG; cached image-dialogue follow-up; text after vision. T0 output matched across intervening temperatures. Image and follow-up answered Red. Pure MTP accepted48/48 draft tokens on the simple counting fixture. Two-token color answers accepted0/3: vision works with MTP enabled, but no vision speed gain was demonstrated.

Position-continuity warnings occurred on image transitions without request failure. No long-context stability,400K prompt, probabilistic-draft, decision/rerank, concurrency, high-ubatch or Xid-resolution claim is made.
