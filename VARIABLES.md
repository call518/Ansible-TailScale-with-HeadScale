# Variable Reference

This document describes every project `vars-*.yaml` setting. Keep secrets only
in the Ansible Vault-encrypted `vars-vault.yaml`.

## `vars-common.yaml`

### SSH Bootstrap and common OS settings

| Variable | Default/example | Purpose |
|---|---|---|
| `ssh_bootstrap_enabled` | `true` | Deploy the controller SSH public key in parallel using Vault passwords |
| `ssh_bootstrap_identity_file` | `~/.ssh/id_rsa` | Controller SSH private-key path |
| `ssh_bootstrap_public_key_file` | `<identity>.pub` | Public key installed in target `authorized_keys` |
| `ssh_bootstrap_connect_timeout` | `10` | Bootstrap SSH connection timeout in seconds |
| `common_timezone` | `Asia/Seoul` | System timezone on all nodes |
| `common_ntp_servers` | pool list | Chrony NTP servers |
| `common_packages_redhat`, `common_packages_debian` | package lists | Common operations and diagnostic packages for each OS family |
| `common_manage_firewalld`, `common_manage_selinux` | `false`, `false` | Whether Ansible manages firewalld and SELinux settings |

### Headscale paths and service identity

| Variable | Default/example | Purpose |
|---|---|---|
| `headscale_version`, `headscale_arch` | `0.29.1`, `amd64` | Headscale release and binary architecture |
| `headscale_binary_path` | `/usr/local/bin/headscale` | CLI/daemon binary path |
| `headscale_config_dir`, `headscale_data_dir` | `/etc/headscale`, `/var/lib/headscale` | Configuration and persistent-data directories |
| `headscale_runtime_dir` | `/run/headscale` | Runtime socket directory |
| `headscale_runtime_directory_name` | derived | systemd `RuntimeDirectory` name |
| `headscale_pki_dir` | `/root/headscale-pki` | Internal CA working directory |
| `headscale_user`, `headscale_group` | `headscale` | Daemon system account and group |
| `headscale_user_name` | `site2site` | Headscale user used for router registration |
| `headscale_nologin_shell` | OS-specific | Login-disabled shell selected by the OS vars file |

### Listeners, STUN, and DERP

| Variable | Default/example | Purpose |
|---|---|---|
| `headscale_listen_address`, `headscale_listen_port` | `0.0.0.0`, `443` | HTTPS control-server listener |
| `headscale_url` | derived from inventory | Login server URL used by Tailscale clients |
| `headscale_metrics_listen_address`, `headscale_metrics_listen_port` | `127.0.0.1`, `9091` | Prometheus metrics endpoint |
| `headscale_grpc_listen_address`, `headscale_grpc_listen_port` | `127.0.0.1`, `50443` | gRPC management endpoint |
| `headscale_grpc_allow_insecure` | `false` | Allow insecure gRPC |
| `headscale_trusted_proxies` | `[]` | Trusted reverse-proxy CIDRs |
| `headscale_noise_private_key_path` | under data dir | Noise protocol private key |
| `headscale_stun_listen_address`, `headscale_stun_port` | `0.0.0.0`, `3478` | Embedded DERP STUN address/UDP port |
| `headscale_derp_enabled` | `true` | Enable Embedded DERP |
| `headscale_derp_region_id` | `999` | Unique DERP region number |
| `headscale_derp_region_code`, `headscale_derp_region_name` | code and label | DERP region code/display name |
| `headscale_derp_verify_clients` | `true` | Restrict Embedded DERP to tailnet clients |
| `headscale_derp_private_key_path` | under data dir | DERP server private key |
| `headscale_derp_auto_add_region` | `true` | Add the embedded region to the DERP map |
| `headscale_derp_ipv4`, `headscale_derp_ipv6` | head IP, empty | Published DERP IPv4/IPv6 addresses |
| `headscale_derp_urls`, `headscale_derp_paths` | `[]`, `[]` | External DERP map URLs/local files |
| `headscale_derp_auto_update_enabled`, `headscale_derp_update_frequency` | `false`, `3h` | External DERP map update switch/interval |

### Address allocation, nodes, routes, and database

| Variable | Default/example | Purpose |
|---|---|---|
| `headscale_tailnet_v4_prefix`, `headscale_tailnet_v6_prefix` | CGNAT and ULA prefixes | Tailnet IPv4/IPv6 pools |
| `headscale_ip_allocation` | `sequential` | Node IP allocation strategy |
| `headscale_disable_check_updates` | `true` | Disable Headscale's own update check |
| `headscale_node_expiry` | `0` | Default node expiry; zero means no expiry |
| `headscale_ephemeral_inactivity_timeout` | `30m` | Removal threshold for inactive ephemeral nodes |
| `headscale_route_probe_interval`, `headscale_route_probe_timeout` | `10s`, `5s` | Subnet-route probe interval/timeout |
| `headscale_database_type` | `sqlite` | Database backend |
| `headscale_database_debug` | `false` | Database debug logging |
| `headscale_database_prepare_stmt` | `true` | Use prepared statements |
| `headscale_database_parameterized_queries` | `true` | Use parameterized queries |
| `headscale_database_skip_not_found` | `true` | Suppress record-not-found logging |
| `headscale_database_slow_threshold` | `1000` | Slow-query threshold in milliseconds |
| `headscale_database_path` | data dir SQLite file | SQLite database path |
| `headscale_database_write_ahead_log` | `true` | Enable SQLite WAL mode |
| `headscale_database_wal_autocheckpoint` | `1000` | WAL auto-checkpoint page count |

### TLS, logging, policy, and DNS

| Variable | Default/example | Purpose |
|---|---|---|
| `headscale_letsencrypt_hostname` | empty | Let's Encrypt hostname; empty for the internal CA |
| `headscale_letsencrypt_cache_dir` | under data dir | ACME certificate cache |
| `headscale_letsencrypt_challenge_type`, `headscale_letsencrypt_listen` | `HTTP-01`, `:http` | ACME challenge type/listener |
| `headscale_tls_cert_path`, `headscale_tls_key_path` | under config dir | Headscale TLS certificate/private key |
| `headscale_log_level`, `headscale_log_format` | `info`, `text` | Log level and format |
| `headscale_policy_mode` | `database` | Authoritative policy source: `file` template or database |
| `headscale_policy_path` | `/etc/headscale/policy.hujson` | Deployed seed/recovery policy path |
| `headscale_router_tags_enabled` | `true` | Enable router tagOwner reconciliation and node tag assignment |
| `headscale_magic_dns`, `headscale_dns_domain` | `true`, `tailnet.internal` | MagicDNS switch/base domain |
| `headscale_override_local_dns` | `false` | Replace client-local DNS settings |
| `headscale_dns_global_nameservers` | `[]` | Global resolver list |
| `headscale_dns_split_nameservers` | `{}` | Domain-to-resolver split-DNS map |
| `headscale_dns_search_domains` | `[]` | Search domains distributed to clients |
| `headscale_dns_extra_records` | `[]` | Additional DNS records |
| `headscale_unix_socket_path`, `headscale_unix_socket_permission` | socket path, `0770` | Local CLI socket and permissions |
| `headscale_logtail_enabled`, `headscale_taildrop_enabled` | `false`, `true` | Logtail and file-transfer features |
| `headscale_auto_update_enabled` | `false` | Permit automatic version updates by the role |
| `headscale_firewall_additional_ports` | `[]` | Extra `port/proto` entries when firewalld is managed |
| `headscale_binary_checksum` | empty | Expected binary SHA-256; recommended in production |

Each host in the inventory `[headscale_tagged_nodes]` group defines
`headscale_node_tags` as a non-empty list. These host-specific tags are the
source for node assignment and policy `tagOwners`; multiple tags are supported.
Tagged hosts managed by this Role must also belong to `[tailscale_routers]`.
Each `[tailscale_routers]` host can set `exit_node=true` to request Exit Node
advertisement; the effective value is forced to false unless that host's
`tailscale_snat_subnet_routes` is also true.

### Internal CA and Headplane

| Variable | Default/example | Purpose |
|---|---|---|
| `headscale_ca_days`, `headscale_cert_days` | `36500`, `18250` | Root CA/server-certificate validity in days |
| `headscale_ca_dn` | DN map | CA country, state, locality, organization, OU, and common name |
| `headplane_enabled` | `true` | Install Docker CE and Headplane; false does not remove it |
| `headplane_version`, `headplane_image` | `0.7.0`, GHCR image | Image version and full image reference |
| `headplane_container_name` | `headplane` | Container name |
| `headplane_listen_address`, `headplane_port` | management IP, `3000` | Published Web UI address/port |
| `headplane_base_url` | derived | Public Headplane base URL |
| `headplane_headscale_url` | head HTTPS URL | Headscale API URL used by the container |
| `headplane_config_dir`, `headplane_config_path` | `/opt/headplane`, YAML path | Configuration directory/file |
| `headplane_cookie_secret_path` | under config dir | Generated cookie-secret path |
| `headplane_data_volume` | `headplane-data` | Persistent Docker volume name |

### Tailscale routers and netns validation

| Variable | Default/example | Purpose |
|---|---|---|
| `tailscale_package` | `tailscale` | Package name |
| `tailscale_udp_port` | `41641` | Direct WireGuard transport UDP port |
| `tailscale_accept_routes` | `true` | Accept remote subnet routes |
| `tailscale_accept_dns` | `false` | Accept Headscale DNS settings |
| `tailscale_snat_subnet_routes` | `false` | Subnet-route SNAT. When false, original Site IPs are preserved and Site-to-Site ACLs must use Site CIDRs rather than router tags |
| `tailscale_ssh_enabled` | `false` | Enable the Tailscale SSH server on managed routers |
| `tailscale_manage_ipv6_forwarding` | `true` | Manage IPv6 forwarding sysctl |
| `tailscale_manage_mss_clamping` | `true` | Manage persistent TCP MSS-clamping rules |
| `tailscale_site_public_internet_masquerade_enabled` | `true` | Persistently masquerade each Site CIDR through its inventory `mgmt_nic`; set false when upstream NAT or return routing already exists |
| `tailscale_interface` | `tailscale0` | Tailscale interface name |
| `tailscale_site_test_enabled` | `true` | Run temporary netns Site-to-Site validation |
| `tailscale_site_test_cleanup_after_validation` | `false` | Remove the netns/veth after validation |
| `tailscale_site_test_namespace` | `ns-test` | Test network namespace name |
| `tailscale_site_test_veth_host`, `tailscale_site_test_veth_namespace` | `veth-host`, `veth-ns` | Router/test-namespace veth names |

## OS-specific files

| Variable | `vars-OS-RedHat.yaml` | `vars-OS-Debian.yaml` | Purpose |
|---|---|---|---|
| `common_supported_distributions` | `[Rocky]` | `[Ubuntu]` | Allowed distributions |
| `common_supported_distribution_version_pattern` | Rocky 10 regex | Ubuntu 26.04 regex | Supported-version validation |
| `common_os_packages` | RedHat list | Debian list | Selected common package list |
| `common_chrony_config_path` | `/etc/chrony.conf` | `/etc/chrony/chrony.conf` | Chrony config path |
| `common_chrony_service` | `chronyd` | `chrony` | Chrony service name |
| `common_ca_trust_directory` | PKI anchors | local CA certificates | Internal CA trust directory |
| `common_ca_update_command` | `update-ca-trust` | `update-ca-certificates` | Trust-store update argv |
| `headscale_nologin_shell` | `/sbin/nologin` | `/usr/sbin/nologin` | Service-account shell |
| `tailscale_repository_type` | `rpm` | `apt` | Repository mechanism |
| `tailscale_apt_key_url` | n/a | Tailscale GPG URL | APT signing-key source |
| `tailscale_apt_key_path` | n/a | keyring path | APT signing-key destination |
| `tailscale_repo_url` | RHEL repo | Ubuntu repo | Repository source URL |
| `tailscale_repo_path` | yum repo path | apt source path | Repository file path |

## `vars-vault.yaml`

The repository includes an encrypted sample whose default Vault password is
`changeme`. Rekey it with your own password or recreate it before adding real
secrets.

| Variable | Purpose |
|---|---|
| `vault_ssh_common_password` | Shared fallback password for initial SSH login |
| `vault_ssh_passwords` | Per-inventory-host SSH password map; overrides the shared value |
| `vault_ansible_become_password` | sudo password referenced by `ansible_become_password` for non-root accounts |

Restrict the Vault file and its master-password file to mode `0600`.
