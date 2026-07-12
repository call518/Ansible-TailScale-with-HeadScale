#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

vault_password_file="${ANSIBLE_VAULT_PASSWORD_FILE:-${HOME}/.ansible_vault_pass_tailscale}"
ansible_args=(-i inventory.ini pb-tailscale-with-headscale.yaml)

if [[ -f vars-vault.yaml ]]; then
  if [[ ! -r "${vault_password_file}" ]]; then
    echo "Vault vars exist but the password file is not readable: ${vault_password_file}" >&2
    exit 1
  fi
  ansible_args=(--vault-password-file "${vault_password_file}" "${ansible_args[@]}")
fi

exec ansible-playbook "${ansible_args[@]}" "$@"
