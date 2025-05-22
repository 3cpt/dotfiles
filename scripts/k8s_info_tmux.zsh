#!/usr/bin/env zsh

# Check if kubectl is available
if ! command -v kubectl >/dev/null 2>&1; then
  exit 0
fi

# Get current context
context=$(kubectl config current-context 2>/dev/null)
if [[ -z "$context" ]]; then
  exit 0
fi

# Get namespace (can be empty)
namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)

# Choose color: red if context contains "prod", else orange
if [[ "$context" == *prod* ]]; then
  COLOR="#[fg_bold=red]"
else
  COLOR="#[fg=white]"
fi

# Build output
if [[ -n "$namespace" ]]; then
  echo "${COLOR}k8s: ${context} (${namespace})#[fg=default]"
else
  echo "${COLOR}k8s: ${context}#[fg=default]"
fi
