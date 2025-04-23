#!/usr/bin/env zsh

# Tmux color for orange foreground
ORANGE="#[fg=colour214]"

# Check if kubectl is available
if ! command -v kubectl >/dev/null 2>&1; then
  exit 0
fi

# Get current context
context=$(kubectl config current-context 2>/dev/null)
if [[ -z "$context" ]]; then
  exit 0
fi

# Get current namespace (can be empty)
namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)

# Output based on presence of namespace
if [[ -n "$namespace" ]]; then
  echo "${ORANGE}k8s: ${context} (${namespace})#[fg=default]"
else
  echo "${ORANGE}k8s: ${context}#[fg=default]"
fi
