# AI Metrices

AI Coding Workflow Metrics - Track and compare single-model vs multi-model (Claude+Codex) workflows.

## Purpose

Quantify the value of adversarial multi-model workflows:
- **Single Model**: Claude only
- **Multi Model**: Claude + Codex (Actor-Critic debate)

## Metrics Tracked

- Phase iterations (0: Plan, 1: Implement, 2: Review)
- Codex findings (critical bugs vs suggestions vs false positives)
- API call costs
- Total duration
- Post-deploy bug rate

## Methodology

See [METHODOLOGY.md](./docs/METHODOLOGY.md) for the complete Claude+Codex workflow framework.
