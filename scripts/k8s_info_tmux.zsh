#!/usr/bin/env zsh
set -euo pipefail

# Show current Kubernetes context and namespace for tmux status line
# Red if context contains 'prod', yellow otherwise

# Check if kubectl is available
if ! command -v kubectl >/dev/null 2>&1; then
  exit 0
fi

# Get current context
context=$(kubectl config current-context 2>/dev/null || true)
if [[ -z "${context:-}" ]]; then
  exit 0
fi

# Get namespace (can be empty)
namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null || true)

# Choose color: red if context contains "prod", else yellow
if [[ "$context" == *prod* ]]; then
  COLOR="#[fg=red]"
else
  COLOR="#[fg=yellow]"
fi

# Build output
if [[ -n "${namespace:-}" ]]; then
  echo "${COLOR}k8s: ${context} (${namespace})#[fg=default]"
else
  echo "${COLOR}k8s: ${context}#[fg=default]"
fi
