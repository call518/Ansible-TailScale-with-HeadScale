#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

exec ansible-playbook -i inventory.lst pb-tailscale-with-headscale.yaml "$@"
