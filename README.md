# Thumbnailer DevOps Sandbox

This repository contains a lightweight local **DevOps sandbox** for developing and validating the `thumbnailer` Maven project with a full internal toolchain:

- **GitLab CE** for source control and CI repository hosting
- **Jenkins** for pipeline execution
- **JFrog Artifactory OSS** for Maven artifacts (release/snapshot)
- **Maven-based dev container** for local build and test work

It is intended for local/intranet experimentation where teams need to simulate a production-like CI/CD flow without external SaaS dependencies.

## Repository Structure

- `docker-compose.yml` – orchestrates all local infrastructure services.
- `Dockerfile` – custom Jenkins image with Docker CLI + docker-compose installed (Docker-outside-of-Docker using host socket).
- `settings.xml` – Maven settings pointing to Artifactory repositories and credentials.
- `.env.example` – environment variable template for configurable versions/ports.

## Quick Start

1. Copy environment template:

```bash
cp .env.example .env
```

2. (Optional) Edit `.env` values for custom ports or image tags.

3. Start all core services:

```bash
docker compose up -d --build
```

4. Initial credentials:

- GitLab root password:
  ```bash
  docker compose exec gitlab cat /etc/gitlab/initial_root_password
  ```
- Jenkins admin password:
  ```bash
  docker compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
  ```
- Artifactory default admin password: `password`

## Recommended CI Flow

1. Developer works in `dev` container (Maven + mounted project).
2. Code is pushed to GitLab.
3. Jenkins pipeline is triggered from GitLab webhook or SCM polling.
4. Jenkins builds/tests with Maven and deploys to Artifactory using `settings.xml` credentials.
5. Snapshot/release repositories separate unstable and stable outputs.

## Operational Notes

- Jenkins and dev container mount `/var/run/docker.sock`; they can control host Docker daemon.
- `HOST_DOCKER_GID` must match host docker group id for Jenkins container socket access.
- Data is persisted via named volumes (`gitlab_*`, `jenkins_home`, `artifactory_data`, `m2repo`).

## Useful Commands

- Check container health/state:
  ```bash
  docker compose ps
  ```
- Follow all logs:
  ```bash
  docker compose logs -f
  ```
- Stop services:
  ```bash
  docker compose down
  ```

## Safety / Limitations

- This setup is not hardened for internet exposure.
- Credentials in `settings.xml` are static placeholders and should be replaced for real usage.
- Artifactory and GitLab are resource-intensive; host sizing matters.
