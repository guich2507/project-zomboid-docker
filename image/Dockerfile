# ============================================================
# Project Zomboid Dedicated Server – Docker Environment Shell
# Base: Debian bookworm-slim (amd64)
# ============================================================

FROM debian:bookworm-slim

LABEL org.opencontainers.image.title="Project Zomboid Dedicated Server Environment"
LABEL org.opencontainers.image.description="Generic Docker environment for Project Zomboid Dedicated Server (SteamCMD, runtime install)"
LABEL org.opencontainers.image.source="https://github.com/<your-repo>"
LABEL org.opencontainers.image.licenses="MIT"

# ------------------------------------------------------------
# Environment (internal defaults only)
# ------------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    ZOMBOID_HOME=/pz/Zomboid

# ------------------------------------------------------------
# Enable i386 architecture (SteamCMD requirement)
# ------------------------------------------------------------
RUN dpkg --add-architecture i386

# ------------------------------------------------------------
# System dependencies
# ------------------------------------------------------------
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    tar \
    bash \
    openjdk-17-jre-headless \
    libglib2.0-0 \
    libxi6 \
    libxrender1 \
    libxtst6 \
    libxrandr2 \
    libxinerama1 \
    procps \
    tzdata \
    vim \
    mc \
    libc6:i386 \
    libstdc++6:i386 \
    libgcc-s1:i386 \
 && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------
# Create required directory structure (contractual)
# ------------------------------------------------------------
RUN mkdir -p \
    /pz/systeme/steamcmd \
    /pz/systeme/server \
    /pz/systeme/logs \
    /pz/Zomboid

# ------------------------------------------------------------
# Working directory
# ------------------------------------------------------------
WORKDIR /pz

# ------------------------------------------------------------
# Entrypoint
# (script will be provided in next step)
# ------------------------------------------------------------
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
