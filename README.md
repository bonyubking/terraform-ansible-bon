## 시스템 아키텍쳐

<img width="1775" height="892" alt="diagram" src="https://github.com/user-attachments/assets/73d8aff9-ea47-4cbe-ad44-9f1b334e7d90" />

## InfraStructure VS DevOps VS CI/CD

### Infrastructure  

서비스가 돌아가기 위한 시설 ( EC2, RDS, NAT, IGW 등 )

### DevOps  

Develop + Opertions 개발과 운영을 하나의 흐름으로 만드는 방법론
Jira / Slack / IaC 등이 DevOps 활동에 속한다.

### CI/CD  

Continuous Integration(통합), Continuous Deployment(배포)
파이프 라인을 구축해서 프로젝트 전반에 지속적/연결성 있는 통합과 배포를 가능하게 하는 과정

GitHub Actions 를 통해 Git push -> docker build -> docker pull -> docker run 과정을 일원화하는 것이 Myce 내의 CI/CD

## IAC ( Intrastructure as Code )

수동으로 인프라를 설정하는 기존 방식에서 벗어나 코드를 사용해서 프로젝트의 전체 환경을 프로비저닝 및 관리 하는 방식
기존 방식에 비해 자동화, 일관성, 효율성 측면에서 강점을 가진다.

## HashiCorp Terraform

클라우드 및 온프레미스 리소스를 정의하는 코드형 인프라 관리 도구
인프라 수명주기 관리 / 프로비저닝이 주 목적이다.

Terraform은 최종 상태를 파악하기 때문에 과거의 상태를 인식 할수 있고 이를 통해 변경사항도 파악이 가능하다.

Myce 에서는 클라우드 리소스로 AWS를 사용한다.
인프라 내의 하드웨어 생성 및 환경 설정을 담당한다. (EC2, RDS, S3, VPC, SG 등)

** Myce 프로비져닝 **
네트워크 
  - VPC
  - Public / Private Subnet
  - IGW (Internet Gateway)
  - Route Table

보안
  - Security Group

컴퓨팅 리소스
  - EC2
    - Private Instance
    - Public Instance
    - NAT Instance
    - Bastion Instance
      
데이터베이스
  - RDS

## Ansible

엔터프라이즈 환경에서 클라우드 리소스들을 일괄적으로 관리하기 위한 코드형 관리 도구
Python module / SSH 를 사용하여 원격 클라우드 리소스에 명령을 수행시키는 것이 주 목적이다.

Myce 인프라 내에서 하드웨어 내 시스템 설정, 소프트웨어 설정 및 설치를 담당한다. ( NginX, Docker, NAT IP Forwarding 등) 

** Myce 프로비저닝 **

- 컴퓨팅 리소스
  - EC2 NAT Instance
    - IP Forwarding (0 -> 1) 
    - Masquerading Configuration
    - Source Destination Check 비활성화

  - EC2 Public Instance
    - Nginx 설치 및 가동
    - Nginx Config 설정

  - EC2 Private Instance
    - Docker 및 Docker Compose 설치
    - Docker 로그인 및 가동
    - Docker-Compose 및 .env 전송/배포















