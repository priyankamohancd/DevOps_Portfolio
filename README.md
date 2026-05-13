# CI/CD Demo - Build & Deploy a Dockerized App Locally

A complete, hands-on CI/CD lab. Students will build a Python web app, containerize it with Docker, push it through an automated pipeline, and deploy it locally.

## Learning Objectives

By the end of this lab, students will be able to:
1. Explain what CI/CD is and why it matters
2. Write a `Dockerfile` using multi-stage builds and best practices
3. Configure a CI pipeline (GitHub Actions **or** Jenkins)
4. Run automated lint, test, build, scan, and deploy stages
5. Deploy a container locally using `docker compose`

## Prerequisites

Each student machine needs:
- Docker Desktop (or Docker Engine + Compose)
- Git
- A code editor (VS Code recommended)
- *(Optional)* A GitHub account if doing the GitHub Actions path

Verify setup:
```bash
docker --version
docker compose version
git --version
```

## Project Structure

```
cicd-demo/
├── app/                       # The application
│   ├── app.py                 # Flask web service
│   ├── requirements.txt       # Python dependencies
│   └── test_app.py            # Unit tests
├── Dockerfile                 # Multi-stage build definition
├── .dockerignore              # Files excluded from build context
├── docker-compose.yml         # Local deployment definition
├── Makefile                   # Convenience commands
├── .github/workflows/
│   └── ci-cd.yml              # GitHub Actions pipeline
├── Jenkinsfile                # Jenkins pipeline (alternative)
├── jenkins/
│   └── docker-compose.yml     # Local Jenkins server
└── docs/
    └── TEACHING_GUIDE.md      # Instructor notes
```

---

## Part 1: Run It Manually (10 min)

Get a feel for the app before automating anything.

```bash
# 1. Build the image
docker build -t cicd-demo:latest .

# 2. Run the container
docker run -d --name app -p 5000:5000 cicd-demo:latest

# 3. Hit the endpoints
curl http://localhost:5000/
curl http://localhost:5000/health
curl http://localhost:5000/api/add/4/5

# 4. Clean up
docker rm -f app
```

**Discussion:** What did Docker just do? What were the layers?

---

## Part 2: Use docker-compose (5 min)

Same outcome, but the deployment is now codified in a file.

```bash
docker compose up -d --build
curl http://localhost:5000/
docker compose logs
docker compose down
```

**Discussion:** Why is `docker-compose.yml` better than typing `docker run` flags?

---

## Part 3: Run the Pipeline Locally with Make (5 min)

```bash
make pipeline    # runs lint -> test -> build -> deploy
```

This is essentially what a CI server will do, just on your machine.

---

## Part 4 (Path A): GitHub Actions

1. Create a new GitHub repo and push this code.
2. Push a commit to `main`.
3. Open the **Actions** tab on GitHub - watch the pipeline run.
4. Try breaking a test or introducing a lint error - watch the pipeline fail.

The workflow file: `.github/workflows/ci-cd.yml`.

Stages:
- **lint** → `test` → `build` → `scan` → `deploy`

---

## Part 4 (Path B): Jenkins (Fully Local)

If you want zero cloud dependencies:

```bash
# 1. Start Jenkins locally
cd jenkins && docker compose up -d
# Open http://localhost:8080
# Get the initial admin password:
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

2. Install the suggested plugins.
3. Create a new **Pipeline** job.
4. Point it at your local repo (or fork on GitHub).
5. Set the pipeline definition to **Pipeline script from SCM** → `Jenkinsfile`.
6. Click **Build Now**.

---

## Part 5: Break Things on Purpose

Best way to teach pipelines. Have students:
- Delete a test assertion → pipeline still passes (why is that bad?)
- Change a test to fail → see the pipeline halt at the test stage
- Add a trailing space line → see lint fail
- Change the Dockerfile base image to a non-existent tag → see build fail
- Introduce a vulnerable dependency → see the scan stage flag it

---

## Concepts to Cover at the Whiteboard

See `docs/TEACHING_GUIDE.md` for a full instructor walkthrough.

## Troubleshooting

| Problem | Fix |
|---|---|
| `port is already allocated` | `docker rm -f app` or change the host port in compose |
| Jenkins can't run `docker` | Make sure `/var/run/docker.sock` is mounted (it is in our compose file) |
| `flake8: command not found` in CI | The workflow installs it; locally run `make install` |
| Tests can't import `app` | Run pytest from inside the `app/` directory |
