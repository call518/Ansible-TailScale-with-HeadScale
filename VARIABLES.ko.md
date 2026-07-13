# 변수 참조

이 문서는 프로젝트의 `vars-*.yaml` 변수와 사용 목적을 설명한다. 비밀값은
`vars-common.yaml`에 넣지 말고 Ansible Vault로 암호화한 `vars-vault.yaml`에만 둔다.

## `vars-common.yaml`

### SSH Bootstrap과 공통 OS

| 변수 | 기본값/예시 | 용도 |
|---|---|---|
| `ssh_bootstrap_enabled` | `true` | Vault 비밀번호를 사용한 최초 SSH 공개키 병렬 배포 여부 |
| `ssh_bootstrap_identity_file` | `~/.ssh/id_rsa` | Controller의 SSH 개인키 경로 |
| `ssh_bootstrap_public_key_file` | `<identity>.pub` | 대상 계정의 `authorized_keys`에 넣을 공개키 |
| `ssh_bootstrap_connect_timeout` | `10` | Bootstrap SSH 연결 제한시간(초) |
| `common_timezone` | `Asia/Seoul` | 모든 노드의 시스템 시간대 |
| `common_ntp_servers` | pool 목록 | Chrony가 사용할 NTP 서버 목록 |
| `common_packages_redhat` | 패키지 목록 | RedHat 계열 공통 진단·운영 패키지 |
| `common_packages_debian` | 패키지 목록 | Debian 계열 공통 진단·운영 패키지 |
| `common_manage_firewalld` | `false` | Ansible의 firewalld 설치·zone·port 관리 여부 |
| `common_manage_selinux` | `false` | Ansible의 SELinux 관련 설정 관리 여부 |

### Headscale 기본 경로와 서비스

| 변수 | 기본값/예시 | 용도 |
|---|---|---|
| `headscale_version` | `0.29.1` | 설치할 Headscale 버전 |
| `headscale_arch` | `amd64` | 다운로드 바이너리 아키텍처 |
| `headscale_binary_path` | `/usr/local/bin/headscale` | Headscale CLI/daemon 경로 |
| `headscale_config_dir` | `/etc/headscale` | 설정 및 TLS 파일 디렉터리 |
| `headscale_data_dir` | `/var/lib/headscale` | DB와 영속 데이터 디렉터리 |
| `headscale_runtime_dir` | `/run/headscale` | Unix socket 등 런타임 디렉터리 |
| `headscale_runtime_directory_name` | runtime 경로에서 계산 | systemd `RuntimeDirectory` 이름 |
| `headscale_pki_dir` | `/root/headscale-pki` | 내부 CA 작업 파일 보관 경로 |
| `headscale_user`, `headscale_group` | `headscale` | daemon 실행 시스템 계정/그룹 |
| `headscale_user_name` | `site2site` | Router 등록용 Headscale 사용자명 |
| `headscale_nologin_shell` | OS별 파일 | 서비스 계정의 로그인 금지 shell; OS vars에서 설정 |

### Headscale Listener, STUN, DERP

| 변수 | 기본값/예시 | 용도 |
|---|---|---|
| `headscale_listen_address`, `headscale_listen_port` | `0.0.0.0`, `443` | HTTPS control server listen 주소/포트 |
| `headscale_url` | inventory에서 계산 | Tailscale client가 사용하는 login server URL |
| `headscale_metrics_listen_address`, `headscale_metrics_listen_port` | `127.0.0.1`, `9091` | Prometheus metrics endpoint |
| `headscale_grpc_listen_address`, `headscale_grpc_listen_port` | `127.0.0.1`, `50443` | gRPC 관리 endpoint |
| `headscale_grpc_allow_insecure` | `false` | 비보안 gRPC 허용 여부 |
| `headscale_trusted_proxies` | `[]` | 신뢰할 reverse proxy CIDR 목록 |
| `headscale_noise_private_key_path` | data dir 아래 | Noise protocol 개인키 경로 |
| `headscale_stun_listen_address`, `headscale_stun_port` | `0.0.0.0`, `3478` | Embedded DERP STUN listen 주소/UDP 포트 |
| `headscale_derp_enabled` | `true` | Embedded DERP 활성화 |
| `headscale_derp_region_id` | `999` | DERP region 고유 숫자 ID |
| `headscale_derp_region_code`, `headscale_derp_region_name` | `headscale`, 표시명 | DERP region 코드/표시명 |
| `headscale_derp_verify_clients` | `true` | Tailnet client만 Embedded DERP 사용 허용 |
| `headscale_derp_private_key_path` | data dir 아래 | DERP server 개인키 경로 |
| `headscale_derp_auto_add_region` | `true` | 자체 DERP region을 map에 자동 추가 |
| `headscale_derp_ipv4`, `headscale_derp_ipv6` | Head node IP, 빈 값 | DERP 공개 IPv4/IPv6 주소 |
| `headscale_derp_urls`, `headscale_derp_paths` | `[]` | 외부 DERP map URL/로컬 파일 목록 |
| `headscale_derp_auto_update_enabled` | `false` | 외부 DERP map 자동 갱신 여부 |
| `headscale_derp_update_frequency` | `3h` | DERP map 갱신 주기 |

### 주소 할당, 노드와 Route

| 변수 | 기본값/예시 | 용도 |
|---|---|---|
| `headscale_tailnet_v4_prefix` | `100.64.0.0/10` | Tailnet IPv4 주소 풀 |
| `headscale_tailnet_v6_prefix` | `fd7a:115c:a1e0::/48` | Tailnet IPv6 주소 풀 |
| `headscale_ip_allocation` | `sequential` | 노드 IP 할당 방식 |
| `headscale_disable_check_updates` | `true` | Headscale 자체 update 확인 비활성화 |
| `headscale_node_expiry` | `0` | 생성 노드 만료 기본값; `0`은 만료 없음 |
| `headscale_ephemeral_inactivity_timeout` | `30m` | Ephemeral node 비활성 제거 기준 |
| `headscale_route_probe_interval`, `headscale_route_probe_timeout` | `10s`, `5s` | Subnet route 상태 probe 주기/제한시간 |

### Database

| 변수 | 기본값/예시 | 용도 |
|---|---|---|
| `headscale_database_type` | `sqlite` | Headscale DB backend |
| `headscale_database_debug` | `false` | DB debug logging |
| `headscale_database_prepare_stmt` | `true` | Prepared statement 사용 |
| `headscale_database_parameterized_queries` | `true` | Parameterized query 사용 |
| `headscale_database_skip_not_found` | `true` | Record not found 로그 억제 |
| `headscale_database_slow_threshold` | `1000` | Slow query 기준(ms) |
| `headscale_database_path` | `/var/lib/headscale/db.sqlite` | SQLite DB 경로 |
| `headscale_database_write_ahead_log` | `true` | SQLite WAL 모드 사용 |
| `headscale_database_wal_autocheckpoint` | `1000` | WAL 자동 checkpoint page 수 |

### TLS, Log, Policy와 DNS

| 변수 | 기본값/예시 | 용도 |
|---|---|---|
| `headscale_letsencrypt_hostname` | 빈 값 | Let's Encrypt hostname; 내부 CA 사용 시 비움 |
| `headscale_letsencrypt_cache_dir` | data dir 아래 | ACME 인증서 cache 경로 |
| `headscale_letsencrypt_challenge_type`, `headscale_letsencrypt_listen` | `HTTP-01`, `:http` | ACME challenge 방식/listen 주소 |
| `headscale_tls_cert_path`, `headscale_tls_key_path` | config dir 아래 | Headscale TLS 인증서/개인키 경로 |
| `headscale_log_level`, `headscale_log_format` | `info`, `text` | Headscale 로그 수준/형식 |
| `headscale_policy_mode` | `database` | `file`은 템플릿, `database`는 DB를 운영 policy 원본으로 사용 |
| `headscale_policy_path` | `/etc/headscale/policy.hujson` | 배포·seed·복구용 policy 파일 경로 |
| `headscale_router_tags_enabled` | `true` | Router tagOwner 병합 및 노드 tag 할당 여부 |
| `headscale_magic_dns` | `true` | MagicDNS 활성화 |
| `headscale_dns_domain` | `tailnet.internal` | Tailnet MagicDNS base domain |
| `headscale_override_local_dns` | `false` | Client local DNS를 Headscale 설정으로 대체할지 여부 |
| `headscale_dns_global_nameservers` | `[]` | 모든 query에 사용할 global resolver 목록 |
| `headscale_dns_split_nameservers` | `{}` | Domain별 split DNS resolver map |
| `headscale_dns_search_domains` | `[]` | Client에 배포할 search domain 목록 |
| `headscale_dns_extra_records` | `[]` | 추가 DNS record 목록 |
| `headscale_unix_socket_path`, `headscale_unix_socket_permission` | socket 경로, `0770` | Local CLI용 Unix socket 경로/권한 |
| `headscale_logtail_enabled`, `headscale_taildrop_enabled` | `false`, `true` | Logtail/파일 전송 기능 활성화 |
| `headscale_auto_update_enabled` | `false` | 배포 role의 자동 버전 갱신 허용 여부 |
| `headscale_firewall_additional_ports` | `[]` | firewalld 관리 시 추가 개방할 `port/proto` 목록 |
| `headscale_binary_checksum` | 빈 값 | 다운로드 바이너리 SHA-256 검증값; 운영 환경 설정 권장 |

Inventory의 `[headscale_tagged_nodes]` 그룹에 속한 각 호스트는 비어 있지 않은
`headscale_node_tags` 목록을 정의한다. 이 호스트별 tag는 노드 할당과 policy
`tagOwners`의 원본이며, 하나 이상의 tag를 지정할 수 있다. 이 Role이 tag를 관리할
호스트는 `[tailscale_routers]`에도 속해야 한다.
각 `[tailscale_routers]` 호스트는 `exit_node=true`로 Exit Node 광고를 요청할 수
있다. 해당 호스트의 `tailscale_snat_subnet_routes`도 `true`일 때만 실제
활성화하며, 그렇지 않으면 안전을 위해 `false`로 강제한다.

### 내부 CA

| 변수 | 기본값/예시 | 용도 |
|---|---|---|
| `headscale_ca_days` | `36500` | Root CA 유효기간(일) |
| `headscale_cert_days` | `18250` | Headscale server 인증서 유효기간(일) |
| `headscale_ca_dn` | DN map | CA의 `country`, `state`, `locality`, `organization`, `organizational_unit`, `common_name` |

### Headplane

| 변수 | 기본값/예시 | 용도 |
|---|---|---|
| `headplane_enabled` | `true` | Docker CE와 Headplane 설치 여부; `false`는 기존 설치를 제거하지 않음 |
| `headplane_version` | `0.7.0` | Headplane image tag |
| `headplane_image` | GHCR image | 실행할 container image |
| `headplane_container_name` | `headplane` | Container 이름 |
| `headplane_listen_address`, `headplane_port` | Head 관리 IP, `3000` | Web UI publish 주소/포트 |
| `headplane_base_url` | listen 값에서 계산 | Headplane public base URL |
| `headplane_headscale_url` | Head 관리 IP의 HTTPS URL | Container가 호출할 Headscale API URL |
| `headplane_config_dir`, `headplane_config_path` | `/opt/headplane`, 하위 YAML | Headplane 설정 디렉터리/파일 |
| `headplane_cookie_secret_path` | config dir 아래 | 자동 생성 cookie secret 경로 |
| `headplane_data_volume` | `headplane-data` | Headplane 영속 Docker volume 이름 |

### Tailscale Router와 netns 검증

| 변수 | 기본값/예시 | 용도 |
|---|---|---|
| `tailscale_package` | `tailscale` | 설치할 package 이름 |
| `tailscale_udp_port` | `41641` | Direct WireGuard transport UDP 포트 |
| `tailscale_accept_routes` | `true` | 다른 Router의 subnet route 수락 여부 |
| `tailscale_accept_dns` | `false` | Headscale DNS 설정 수락 여부 |
| `tailscale_snat_subnet_routes` | `false` | Subnet route SNAT 여부. `false`이면 원본 Site IP가 보존되므로 Site-to-Site ACL은 Router tag가 아닌 실제 Site CIDR을 사용해야 함 |
| `tailscale_ssh_enabled` | `false` | 관리 대상 Router의 Tailscale SSH server 활성화 여부 |
| `tailscale_manage_ipv6_forwarding` | `true` | IPv6 forwarding sysctl 관리 여부 |
| `tailscale_manage_mss_clamping` | `true` | VPN 경로 TCP MSS clamping rule/service 관리 여부 |
| `tailscale_site_public_internet_masquerade_enabled` | `true` | 각 Site CIDR을 inventory의 `mgmt_nic`으로 영구 masquerade할지 여부. 상위 NAT 또는 반환 route가 있으면 `false` |
| `tailscale_interface` | `tailscale0` | Tailscale network interface 이름 |
| `tailscale_site_test_enabled` | `true` | 임시 netns Site-to-Site 검증 실행 여부 |
| `tailscale_site_test_cleanup_after_validation` | `false` | 검증 후 netns/veth 자동 삭제 여부 |
| `tailscale_site_test_namespace` | `ns-test` | 테스트 network namespace 이름 |
| `tailscale_site_test_veth_host` | `veth-host` | Router namespace의 veth 이름 |
| `tailscale_site_test_veth_namespace` | `veth-ns` | Test namespace의 veth 이름 |

## OS별 변수

| 변수 | `vars-OS-RedHat.yaml` | `vars-OS-Debian.yaml` | 용도 |
|---|---|---|---|
| `common_supported_distributions` | `[Rocky]` | `[Ubuntu]` | 허용 배포판 이름 |
| `common_supported_distribution_version_pattern` | Rocky 10 regex | Ubuntu 26.04 regex | 지원 버전 검증 정규식 |
| `common_os_packages` | `common_packages_redhat` | `common_packages_debian` | 해당 OS에 설치할 공통 package 목록 |
| `common_chrony_config_path` | `/etc/chrony.conf` | `/etc/chrony/chrony.conf` | Chrony 설정 경로 |
| `common_chrony_service` | `chronyd` | `chrony` | Chrony systemd service 이름 |
| `common_ca_trust_directory` | pki anchors | local CA certificates | 내부 CA 설치 디렉터리 |
| `common_ca_update_command` | `update-ca-trust` | `update-ca-certificates` | OS trust store 갱신 명령 argv |
| `headscale_nologin_shell` | `/sbin/nologin` | `/usr/sbin/nologin` | Headscale 시스템 계정 shell |
| `tailscale_repository_type` | `rpm` | `apt` | Repository 구성 방식 |
| `tailscale_apt_key_url` | 해당 없음 | Tailscale GPG URL | APT repository signing key URL |
| `tailscale_apt_key_path` | 해당 없음 | keyring 경로 | 저장할 APT signing key 경로 |
| `tailscale_repo_url` | RHEL repo URL | Ubuntu repo URL | Tailscale repository 원본 |
| `tailscale_repo_path` | yum repo 경로 | apt source 경로 | 배포할 repository 파일 경로 |

## `vars-vault.yaml`

이 파일은 사용자가 생성하며 Git에 포함하지 않는다.

| 변수 | 용도 |
|---|---|
| `vault_ssh_common_password` | 대부분 노드가 공유하는 최초 SSH 로그인 비밀번호 fallback |
| `vault_ssh_passwords` | Inventory hostname별 SSH 로그인 비밀번호 map; 공통값보다 우선 |
| `vault_ansible_become_password` | 비-root SSH 계정의 sudo 비밀번호; inventory의 `ansible_become_password`에서 참조 |

비밀값과 Vault master password 파일은 반드시 권한을 `0600`으로 제한한다.
