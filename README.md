# Headscale + Tailscale Site-to-Site Ansible

Rocky Linux 10 노드 3대에 내부 CA 기반 Headscale와 Tailscale subnet router 2대를
구성한다. 첨부 절차서의 3장부터 24.3장까지 필요한 설치·설정 작업을 Role로
자동화했으며, 테스트 VM 자체의 OS 설정은 관리 대상에 포함하지 않는다.

## 파일 구조

- `vars-common.yaml`: 모든 노드에 공통인 버전, 경로, 인증서 DN, 포트 및 동작 변수
- `inventory.lst`: Ansible 접속 대상과 관리 IP
- `roles/ssh_bootstrap`: 선택적 `ssh-copy-id` 기반 SSH 키 초기 배포
- `roles/common`: 공통 OS, 시간 동기화, hosts, 패키지, firewalld
- `roles/headscale`: CA/TLS, Headscale binary/config/policy/systemd/user
- `roles/tailscale_router`: CA trust, Tailscale, forwarding, 방화벽, 노드 등록
- `pb-tailscale-with-headscale.yaml`: 전체 실행 순서와 subnet route 승인
- `run.sh`: 플레이북 실행 진입점

## 실행 전 준비

제어 노드에 Ansible이 설치되어 있고 세 노드에 SSH 접속 및 `become`이 가능해야
한다. 기본값은 `root` 접속이다. 다른 계정이나 SSH 키를 쓰면 `inventory.lst`의
`ansible_user` 및 필요 접속 변수를 조정한다.

Passwordless SSH가 준비되지 않은 환경에서는 `vars-common.yaml`에서 다음 값을
설정한다. 개인키와 같은 이름의 `.pub` 공개키가 있어야 하며, 비밀번호는 파일에
저장하지 않고 `ssh-copy-id`가 실행 중 터미널에서 직접 요청한다.

```yaml
ssh_copy_id_enabled: true
ssh_copy_id_identity_file: /root/.ssh/id_rsa
ssh_copy_id_public_key_file: "{{ ssh_copy_id_identity_file }}.pub"
```

첫 Play는 모든 inventory 호스트에 `ssh-copy-id`를 실행한다. 원격
`authorized_keys`에 동일한 공개키가 이미 있으면 `ssh-copy-id` 자체 검사로 중복
추가하지 않으며, 지정 키가 바뀌었거나 없을 때만 비밀번호 인증 후 추가한다. 초기
키 배포가 끝난 뒤에는 다음 실행부터 `ssh_copy_id_enabled: false`로 되돌려도 된다.

실제 환경에 맞게 `inventory.lst`를 수정한다. 호스트명은 inventory의 호스트 이름으로,
관리 IP는 `ansible_host`로 지정한다. `host_alias`, `site_nic`, `site_cidr`, 인증서
SAN처럼 호스트마다 다른 값도 해당 호스트 행에 지정한다.

```ini
[headscale]
my-head.example.com ansible_host=192.168.156.100 host_alias=head cert_dns_sans='["my-head.example.com", "head"]' cert_ip_sans='["192.168.156.100"]'

[tailscale_routers]
site-a.example.com ansible_host=192.168.156.101 host_alias=site-a site_nic=ens224 site_cidr=10.10.10.0/24
site-b.example.com ansible_host=192.168.156.102 host_alias=site-b site_nic=ens224 site_cidr=10.10.20.0/24
```

NIC 주소 자체는 이미 구성된 상태를 전제로 하며 이 플레이북이 NetworkManager
연결 프로파일을 변경하지 않는다. `site_nic`은 각 Site LAN NIC 이름,
`site_cidr`은 해당 라우터가 광고할 LAN 대역이다.

Firewalld와 SELinux 관련 설정은 기본적으로 적용하지 않는다. 대상 환경에서 해당
기능을 사용할 때만 `vars-common.yaml`에서 활성화한다.

```yaml
common_manage_firewalld: true
common_manage_selinux: true
```

`common_manage_firewalld: false`이면 firewalld 패키지 설치, 서비스 시작, 포트 및
zone 변경을 모두 건너뛴다. 기존 firewalld를 중지하거나 제거하지는 않는다.
`common_manage_selinux: false`이면 Headscale 파일의 SELinux context 복원을
건너뛰며, SELinux 자체의 enforcing/permissive/disabled 상태는 변경하지 않는다.

Site-to-Site TCP의 터널 MTU 문제를 예방하기 위한 MSS Clamping은 Firewalld와
독립적으로 기본 적용한다.

```yaml
tailscale_manage_mss_clamping: true
tailscale_interface: tailscale0
```

라우터의 mangle/FORWARD 체인에 `tailscale0` 출력 및 입력 방향 TCP SYN 규칙을
각각 하나씩 유지하며, `tailscale-mss-clamping.service`로 재부팅 후에도 적용한다.
특수한 환경에서 외부 방화벽 관리 도구가 같은 규칙을 전담할 때만
`tailscale_manage_mss_clamping: false`로 비활성화한다.

## 실행

```bash
./run.sh
```

SSH 키를 지정하는 등 일반 `ansible-playbook` 옵션을 그대로 전달할 수 있다.

```bash
./run.sh --private-key ~/.ssh/id_ed25519
./run.sh --limit tailscale-head
./run.sh --check --diff
```

Role 또는 단계별 단독 실행은 태그를 사용한다.

```bash
./run.sh --tags ssh_bootstrap
./run.sh --tags common
./run.sh --tags headscale
./run.sh --tags tailscale_router
./run.sh --tags route_approval
```

비활성화된 SSH Bootstrap을 일회성으로 실행하려면 vars 파일을 수정하지 않고도
추가 변수로 활성화할 수 있다.

```bash
./run.sh --tags ssh_bootstrap -e ssh_copy_id_enabled=true
```

호스트까지 제한하려면 `--limit`을 함께 사용한다.

```bash
./run.sh --tags tailscale_router --limit tailscale-01 -vv
```

태그와 실행 task 목록은 다음 명령으로 확인할 수 있다.

```bash
./run.sh --list-tags
./run.sh --tags headscale --list-tasks
```

최초 전체 구성에서는 `--limit`을 사용하지 않는다. Headscale 구성, 라우터 등록,
광고 route 승인 순서가 필요하기 때문이다.

## 재실행과 변수 변경

플레이북은 반복 실행을 전제로 한다. 이미 등록된 Tailscale 노드는 새 pre-auth key를
만들지 않고 `tailscale up`으로 원하는 설정을 재조정한다. 미등록 노드에만 Headscale가
일회용 키를 생성하며 Ansible 출력에는 키를 숨긴다.

- 설정/policy/systemd/TLS 배치 변경: Headscale 재시작
- CA 변경: CA와 서버 인증서 재발급, trust store 갱신, 관련 서비스 재시작
- 서버 SAN/IP 변경: 서버 인증서 재발급
- forwarding 변경: `sysctl --system` 적용
- site CIDR 변경: router 광고 설정 재적용 후 Headscale에서 승인
- site NIC 변경: 새 NIC를 firewalld trusted zone에 추가

기존 NIC를 trusted zone에서 자동 제거하지는 않는다. 한 노드에 trusted NIC가 여러
개일 수 있고, Ansible이 소유하지 않은 방화벽 설정을 임의 삭제하면 장애가 날 수 있기
때문이다. 교체 후 기존 NIC를 제거해야 한다면 명시적으로 실행한다.

```bash
firewall-cmd --permanent --zone=trusted --remove-interface=<기존-NIC>
firewall-cmd --reload
```

CA DN을 변경하면 새 루트 CA가 발급되므로 이미 등록된 모든 클라이언트에 전체
플레이북을 적용해야 한다. `headscale_data_dir`을 변경할 때 기존 DB/키의 자동 이전은
데이터 손실 방지를 위해 수행하지 않는다. 기존 상태를 유지해야 한다면 실행 전에
DB와 noise/DERP key를 새 경로로 계획적으로 이관한다.

## 확인

```bash
ansible tailscale -b -m command -a 'systemctl is-active firewalld'
ansible headscale -b -m command -a 'headscale nodes list-routes'
ansible tailscale_routers -b -m command -a 'tailscale status'
ansible tailscale_routers -b -m command -a 'sysctl net.ipv4.ip_forward'
```

최종 데이터 경로는 각 Site 테스트 단말에서 상대편 단말로 `ping`, `traceroute`를
수행하고 두 subnet router의 site NIC와 `tailscale0`에서 `tcpdump`하여 검증한다.
