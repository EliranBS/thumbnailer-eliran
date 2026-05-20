# Generic DevOps Sandbox (Ubuntu-based dev container)

This repository provides a lightweight local **DevOps sandbox** for **any project**, with an Ubuntu-based development container and a full internal CI/CD toolchain:

- **Ubuntu dev container** for generic project development
- **GitLab CE** for source control and CI repository hosting
- **Jenkins** for pipeline execution
- **JFrog Artifactory OSS** for artifact storage

It is designed for local/intranet experimentation where teams need production-like CI/CD behavior without external SaaS dependencies.

## Repository Structure

- `docker-compose.yml` – orchestrates all local infrastructure services.
- `Dockerfile` – custom Jenkins image with Docker CLI + docker-compose installed (Docker-outside-of-Docker using host socket).
- `settings.xml` – Maven-oriented example settings for Artifactory credentials/repositories.
- `.env.example` – environment variable template for container images, paths, and ports.
- `Makefile` – convenience commands for init/validate/up/down/logs workflows.

## Quick Start

1. Initialize environment file:

```bash
make init
```

2. Optionally edit `.env` values, especially:

- `PROJECT_PATH` – host path of the project you want to mount
- `DEV_WORKDIR` – mount point inside the dev container
- `DEV_BASE_IMAGE` – default is `ubuntu:22.04`

3. Start all core services:

```bash
make up
```

4. Open shell in the Ubuntu dev container:

```bash
docker compose exec dev bash
```

## Default Service Endpoints

- GitLab: `http://localhost:${GITLAB_HTTP_PORT}`
- Jenkins: `http://localhost:${JENKINS_PORT}`
- Artifactory: `http://localhost:${ARTIFACTORY_PORT}`

## Initial Credentials

- GitLab root password:
  ```bash
  docker compose exec gitlab cat /etc/gitlab/initial_root_password
  ```
- Jenkins admin password:
  ```bash
  docker compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
  ```
- Artifactory default admin password: `password`

## Makefile Commands

- Validate setup and compose syntax:
  ```bash
  make validate
  ```
- Print resolved compose config:
  ```bash
  make config
  ```
- Start services:
  ```bash
  make up
  ```
- Stop services:
  ```bash
  make down
  ```
- Restart services:
  ```bash
  make restart
  ```
- Show status:
  ```bash
  make ps
  ```
- Tail logs:
  ```bash
  make logs
  ```

## Operational Notes

- Jenkins and dev container mount `/var/run/docker.sock`; they can control host Docker daemon.
- `HOST_DOCKER_GID` must match host docker group id for Jenkins container socket access.
- Data is persisted via named volumes (`gitlab_*`, `jenkins_home`, `artifactory_data`).

## Safety / Limitations

- This setup is not hardened for internet exposure.
- Credentials in `settings.xml` are static placeholders and should be replaced for real usage.
- Artifactory and GitLab are resource-intensive; host sizing matters.
