#!/bin/bash
# Initialize SQLite database for AI workflow metrics

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DB_PATH="$PROJECT_ROOT/data/ai-metrics.db"

mkdir -p "$(dirname "$DB_PATH")"

sqlite3 "$DB_PATH" << 'SQL'
CREATE TABLE IF NOT EXISTS workflow_runs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  task_id TEXT UNIQUE NOT NULL,
  project TEXT NOT NULL,
  workflow_type TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  phase_0_iterations INTEGER DEFAULT 0,
  phase_1_duration_minutes INTEGER DEFAULT 0,
  phase_2_iterations INTEGER DEFAULT 0,
  
  codex_issues_found INTEGER DEFAULT 0,
  codex_critical INTEGER DEFAULT 0,
  codex_suggestions INTEGER DEFAULT 0,
  codex_false_positives INTEGER DEFAULT 0,
  
  total_api_calls INTEGER DEFAULT 0,
  total_duration_minutes INTEGER DEFAULT 0,
  estimated_cost_cents REAL DEFAULT 0,
  
  final_status TEXT NOT NULL,
  confidence_score REAL DEFAULT 0,
  post_deploy_bugs INTEGER DEFAULT 0,
  
  github_issue_url TEXT,
  phase_0_comment_url TEXT,
  phase_1_comment_url TEXT,
  phase_2_comment_url TEXT
);

CREATE INDEX IF NOT EXISTS idx_workflow_type ON workflow_runs(workflow_type);
CREATE INDEX IF NOT EXISTS idx_project ON workflow_runs(project);
CREATE INDEX IF NOT EXISTS idx_created_at ON workflow_runs(created_at);
SQL

echo "✅ Database initialized at $DB_PATH"
