# Claude + Codex Multi-Model Workflow

## Core Idea

Leverage **model diversity** (different providers/models) to break information cocoons. Use **Actor-Critic debate + review** to significantly improve code **correctness, safety, and robustness**.

Best for: Trading systems, DeFi, contract arbitrage — scenarios where **bugs are extremely costly**.

## Workflow

```
New Task
    ↓
Complexity Check
    ├── Trivial (≤5 lines, non-critical) → Primary model only → Done
    └── Important/Architecture/Complex → Full Flow
            ↓
Phase 0: Plan & Adversarial Debate (Max 3 rounds)
            ↓
Phase 1: Implementation + Self-Review (Primary model family)
            ↓
Phase 2: Final Boss Review (Reviewer model)
            ↓
Result?
    ├── Pass → Auto-commit (Co-Authored-By) ✅
    └── Fail → Iterate or Escalate 🛑
```

## Phase Details

### Phase 0: Plan & Adversarial Debate

**Goal**: Clarify architecture, logic, edge cases before writing code.

**Roles**:
- Lead (Primary model, e.g., `jdprovider/claude-opus-4.6`): Creates detailed blueprint
- Critic (Reviewer model, e.g., `openai/gpt-5.3-codex` @ xhigh): Challenges objective errors

**Exit Conditions**:
- Reviewer finds 0 objective errors + consensus → Lock blueprint
- 3 rounds without agreement → Escalate to human

### Phase 1: Implementation + Self-Review

**Roles** (all Primary model, e.g., Sonnet 4.6):
- blueprint-implementer: Code + tests
- claude-code-reviewer: Quick review (race conditions, leaks)
- debugger: Fix test failures, syntax, local bugs

**Checklist**:
- All tests pass (green)
- Solve architecture first, then adapt tests
- Code stable + lint passes → Ready for Reviewer

### Phase 2: Final Boss Review

**Trigger**: Phase 1 complete

**New Session** (avoid context pollution)

**Steps** (Max 3 rounds):
1. Send to Reviewer @ high: locked blueprint + git diff + intent
2. Reviewer output format: `[file:line] - [severity] - [issue] - [suggestion]`
3. Debugger fixes objective issues → Resend to Reviewer

**Exit Conditions**:
- 0 objective defects → Success ✅ → Auto git commit
- Only subjective opinions → Success + manual confirm
- 3 rounds with bugs → Escalate 🛑
- Reviewer self-contradictory → Escalate

## Model Configuration

Use `provider/model` format for full identification:

| Use Case | Primary | Reviewer |
|----------|---------|----------|
| High-stakes trading | `jdprovider/claude-opus-4.6` | `openai/gpt-5.3-codex` |
| Cost-optimized | `anthropic/claude-sonnet-4.6` | `google/gemini-2.5-pro` |
| Single model baseline | `anthropic/claude-opus-4.6` | (none) |

## Metrics to Track

| Metric | Purpose |
|--------|---------|
| Phase 0 iterations | Measure debate efficiency |
| Review critical bugs | Value of adversarial review |
| Review false positives | Noise ratio |
| Total API calls | Cost tracking |
| Total duration | Time overhead |
| Post-deploy bugs | Ultimate quality measure |
| Confidence score | Model self-assessment |

## Decision Framework

After 2 weeks / 10+ tasks:

- **Continue**: Reviewer catches >20% critical bugs primary model missed
- **Adjust**: High false positive rate → tune reviewer prompts
- **Abandon**: No significant quality improvement vs time cost
