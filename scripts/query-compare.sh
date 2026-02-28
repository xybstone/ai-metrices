#!/bin/bash
# Compare single-model vs multi-model workflow metrics

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DB_PATH="$PROJECT_ROOT/data/ai-metrics.db"

if [[ ! -f "$DB_PATH" ]]; then
  echo "❌ Database not found. Run init-db.sh first."
  exit 1
fi

sqlite3 "$DB_PATH" << 'SQL'
.mode column
.headers on
.width 15 10 15 15 15 10

SELECT 
  workflow_type,
  COUNT(*) as tasks,
  ROUND(AVG(total_duration_minutes), 1) as avg_minutes,
  ROUND(AVG(codex_critical), 2) as avg_critical_bugs,
  ROUND(AVG(confidence_score), 2) as avg_confidence,
  SUM(post_deploy_bugs) as post_bugs
FROM workflow_runs 
WHERE created_at > date('now', '-30 days')
GROUP BY workflow_type;
SQL

echo ""
echo "--- Detailed View ---"
sqlite3 "$DB_PATH" << 'SQL'
.mode column
.headers on
SELECT 
  task_id,
  workflow_type,
  phase_0_iterations,
  codex_critical,
  total_duration_minutes,
  final_status
FROM workflow_runs 
ORDER BY created_at DESC
LIMIT 10;
SQL
