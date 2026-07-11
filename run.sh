#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
export ANSIBLE_LOCAL_TEMP="${ANSIBLE_LOCAL_TEMP:-/tmp/ansible-local}"
export ANSIBLE_REMOTE_TEMP="${ANSIBLE_REMOTE_TEMP:-/tmp/.ansible-${USER:-ansible}}"
mkdir -p "$ANSIBLE_LOCAL_TEMP"

exec ansible-playbook -i inventory.lst pb-tailscale-with-headscale.yml "$@"

