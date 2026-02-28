#!/bin/bash
# Export workflow metrics to CSV for Excel analysis

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DB_PATH="$PROJECT_ROOT/data/ai-metrics.db"
OUTPUT="${1:-$PROJECT_ROOT/data/export-$(date +%Y%m%d).csv}"

if [[ ! -f "$DB_PATH" ]]; then
  echo "❌ Database not found. Run init-db.sh first."
  exit 1
fi

sqlite3 -header -csv "$DB_PATH" << SQL > "$OUTPUT"
SELECT 
  task_id, project, workflow_type, created_at,
  phase_0_iterations, phase_1_duration_minutes, phase_2_iterations,
  codex_issues_found, codex_critical, codex_suggestions, codex_false_positives,
  total_api_calls, total_duration_minutes, estimated_cost_cents,
  final_status, confidence_score, post_deploy_bugs,
  github_issue_url
FROM workflow_runs
ORDER BY created_at DESC;
SQL

echo "✅ Exported to $OUTPUT"
