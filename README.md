# DVWA on Cloudflare Workers (Serverless Containers)

This repository contains a proof-of-concept for hosting the **Damn Vulnerable Web Application (DVWA)** on Cloudflare's serverless edge network using the Cloudflare Containers platform.

## 🏗️ Architecture & Challenges
Deploying legacy "fat" containers (like the official DVWA image) to serverless environments is notoriously difficult. Serverless microVMs are highly restrictive and often lack the standard Linux filesystem capabilities that legacy init scripts expect. 

This project solves the resulting race conditions and silent crashes by implementing:
* A custom `Dockerfile` explicitly built for the `linux/amd64` architecture required by Cloudflare's edge.
* A robust `start.sh` script that cleans up stale PID locks left over from container sleep cycles.
* Foreground execution of Apache to prevent the microVM from terminating prematurely.
* A synchronized boot sequence ensuring the internal MySQL database fully initializes before Apache attempts to bind to port 80.
* Because Cloudflare Containers use ephemeral storage, the internal MySQL database will wipe whenever the container scales down to zero due to inactivity.
Upon cold boot, navigate to your deployment URL, log in with the default credentials (admin / password), and click "Create / Reset Database" to initialize the lab for your current session.

## ⚠️ CRITICAL SECURITY WARNING
**DVWA is intentionally insecure and built to be exploited.** Deploying this container directly to the public internet (via a `*.workers.dev` URL or custom domain) without an authentication layer creates a massive security risk. Attackers can use remote code execution (RCE) vulnerabilities within DVWA to hijack the container and pivot to other targets.

**Do not deploy this without putting it behind a Zero Trust proxy.** It is highly recommended to secure the Worker route using **Cloudflare Access** with strict email or SSO authentication rules.

## 🚀 Deployment Instructions

### Prerequisites
* A Cloudflare account with a Paid Workers plan (required for Containers).
* Docker Desktop installed and running locally.
* Cloudflare Wrangler CLI (`npm install wrangler@latest -g`).

### 1. Clone and Install
```bash
git clone [https://github.com/yourusername/dvwa-cloudflare-workers.git](https://github.com/yourusername/dvwa-cloudflare-workers.git)
cd dvwa-cloudflare-workers
npm install @cloudflare/containers
