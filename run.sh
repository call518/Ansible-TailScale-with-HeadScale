#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

exec ansible-playbook -i inventory.ini pb-tailscale-with-headscale.yaml "$@"
