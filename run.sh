#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

vault_password_file="${ANSIBLE_VAULT_PASSWORD_FILE:-${HOME}/.ansible_vault_pass}"

if [[ ! -f vars-vault.yaml ]]; then
  echo "Required encrypted vars file is missing: vars-vault.yaml" >&2
  echo "Create it with: ansible-vault create --vault-password-file ${vault_password_file} vars-vault.yaml" >&2
  exit 1
fi

if [[ ! -r "${vault_password_file}" ]]; then
  echo "Vault password file is not readable: ${vault_password_file}" >&2
  exit 1
fi

exec ansible-playbook \
  --vault-password-file "${vault_password_file}" \
  -i inventory.ini \
  pb-tailscale-with-headscale.yaml \
  "$@"
