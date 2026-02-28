# Claude + Codex Multi-Model Workflow

## Core Idea

Leverage **model diversity** (Claude ≠ Codex) to break information cocoons. Use **Actor-Critic debate + review** to significantly improve code **correctness, safety, and robustness**.

Best for: Trading systems, DeFi, contract arbitrage — scenarios where **bugs are extremely costly**.

## Workflow

```
New Task
    ↓
Complexity Check
    ├── Trivial (≤5 lines, non-critical) → Claude only → Done
    └── Important/Architecture/Complex → Full Flow
            ↓
Phase 0: Plan & Adversarial Debate (Max 3 rounds)
            ↓
Phase 1: Implementation + Self-Review (Claude family)
            ↓
Phase 2: Final Boss Review (Codex)
            ↓
Result?
    ├── Pass → Auto-commit (Co-Authored-By) ✅
    └── Fail → Iterate or Escalate 🛑
```

## Phase Details

### Phase 0: Plan & Adversarial Debate

**Goal**: Clarify architecture, logic, edge cases before writing code.

**Roles**:
- Lead (Claude Opus 4.6): Creates detailed blueprint
- Critic (Codex gpt-5.3-codex @ xhigh): Challenges objective errors

**Exit Conditions**:
- Codex finds 0 objective errors + consensus → Lock blueprint
- 3 rounds without agreement → Escalate to human

### Phase 1: Implementation + Self-Review

**Roles** (all Claude Sonnet 4.6):
- blueprint-implementer: Code + tests
- claude-code-reviewer: Quick review (race conditions, leaks)
- debugger: Fix test failures, syntax, local bugs

**Checklist**:
- All tests pass (green)
- Solve architecture first, then adapt tests
- Code stable + lint passes → Ready for Codex

### Phase 2: Final Boss Review

**Trigger**: Phase 1 complete

**New Session** (avoid context pollution)

**Steps** (Max 3 rounds):
1. Send to Codex @ high: locked blueprint + git diff + intent
2. Codex output format: `[file:line] - [severity] - [issue] - [suggestion]`
3. Debugger fixes objective issues → Resend to Codex

**Exit Conditions**:
- 0 objective defects → Success ✅ → Auto git commit
- Only subjective opinions → Success + manual confirm
- 3 rounds with bugs → Escalate 🛑
- Codex self-contradictory → Escalate

## Metrics to Track

| Metric | Purpose |
|--------|---------|
| Phase 0 iterations | Measure debate efficiency |
| Codex critical bugs | Value of adversarial review |
| Codex false positives | Noise ratio |
| Total API calls | Cost tracking |
| Total duration | Time overhead |
| Post-deploy bugs | Ultimate quality measure |
| Confidence score | Model self-assessment |

## Decision Framework

After 2 weeks / 10+ tasks:

- **Continue**: Codex catches >20% critical bugs Claude missed
- **Adjust**: High false positive rate → tune Codex prompts
- **Abandon**: No significant quality improvement vs time cost
