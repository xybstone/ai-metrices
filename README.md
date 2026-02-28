# AI Metrices

AI Coding Workflow Metrics - Track and compare single-model vs multi-model workflows.

## Purpose

Quantify the value of adversarial multi-model workflows:
- **Single Model**: Primary model only (baseline)
- **Multi Model**: Primary + Reviewer model (Actor-Critic debate)

## Quick Start

```bash
# 1. Initialize database
./scripts/init-db.sh

# 2. Record a workflow run
./scripts/record-run.sh \
  "issue-26" \
  "team-os" \
  "multi_model" \
  2    # phase_0_iterations
  3    # phase_2_iterations
  5    # review_issues_found
  3    # review_critical
  2    # review_suggestions
  8    # total_api_calls
  45   # total_duration_minutes
  "success"
  0.85 # confidence_score
  "https://github.com/..."

# 3. Compare workflows
./scripts/query-compare.sh

# 4. Export for Excel analysis
./scripts/export-csv.sh
```

## Database Schema

Tracks `provider/model` format for full model identification:

```sql
CREATE TABLE workflow_runs (
  id INTEGER PRIMARY KEY,
  task_id TEXT UNIQUE,
  project TEXT,
  workflow_type TEXT,  -- single_model / multi_model
  
  -- Workflow configuration
  primary_provider TEXT DEFAULT 'anthropic',
  primary_model TEXT DEFAULT 'claude-opus-4.6',
  review_provider TEXT DEFAULT '',
  review_model TEXT DEFAULT '',
  workflow_variant TEXT DEFAULT 'standard',
  
  -- Phase metrics
  phase_0_iterations INTEGER,
  phase_1_duration_minutes INTEGER,
  phase_2_iterations INTEGER,
  
  -- Review findings
  review_issues_found INTEGER,
  review_critical INTEGER,
  review_suggestions INTEGER,
  review_false_positives INTEGER,
  
  -- Cost & Quality
  total_api_calls INTEGER,
  total_duration_minutes INTEGER,
  estimated_cost_cents REAL,
  final_status TEXT,
  confidence_score REAL,
  post_deploy_bugs INTEGER,
  
  -- Audit links
  github_issue_url TEXT,
  phase_0_comment_url TEXT,
  phase_1_comment_url TEXT,
  phase_2_comment_url TEXT
);
```

## Scripts

| Script | Purpose |
|--------|---------|
| `init-db.sh` | Create SQLite database with schema |
| `record-run.sh` | Manual recording of workflow metrics |
| `query-compare.sh` | Compare single vs multi-model performance |
| `export-csv.sh` | Export data for Excel analysis |

## Documentation

- [METHODOLOGY.md](./docs/METHODOLOGY.md) - Complete workflow framework

## License

MIT
