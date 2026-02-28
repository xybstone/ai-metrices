#!/bin/bash
# Record a workflow run to the metrics database

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DB_PATH="$PROJECT_ROOT/data/ai-metrics.db"

# Required args
TASK_ID="${1:-}"
PROJECT="${2:-}"
WORKFLOW_TYPE="${3:-}"

if [[ -z "$TASK_ID" || -z "$PROJECT" || -z "$WORKFLOW_TYPE" ]]; then
  echo "Usage: $0 <task_id> <project> <workflow_type>"
  echo "  workflow_type: single_model | multi_model"
  exit 1
fi

# Optional args (defaults to 0)
PHASE_0_ITER="${4:-0}"
PHASE_2_ITER="${5:-0}"
CODEX_ISSUES="${6:-0}"
CODEX_CRITICAL="${7:-0}"
CODEX_SUGGESTIONS="${8:-0}"
API_CALLS="${9:-0}"
DURATION="${10:-0}"
STATUS="${11:-success}"
CONFIDENCE="${12:-0}"
GITHUB_URL="${13:-}"

sqlite3 "$DB_PATH" << SQL
INSERT OR REPLACE INTO workflow_runs (
  task_id, project, workflow_type,
  phase_0_iterations, phase_2_iterations,
  codex_issues_found, codex_critical, codex_suggestions,
  total_api_calls, total_duration_minutes,
  final_status, confidence_score,
  github_issue_url
) VALUES (
  '$TASK_ID', '$PROJECT', '$WORKFLOW_TYPE',
  $PHASE_0_ITER, $PHASE_2_ITER,
  $CODEX_ISSUES, $CODEX_CRITICAL, $CODEX_SUGGESTIONS,
  $API_CALLS, $DURATION,
  '$STATUS', $CONFIDENCE,
  '$GITHUB_URL'
);
SQL

echo "✅ Recorded: $TASK_ID ($WORKFLOW_TYPE)"
