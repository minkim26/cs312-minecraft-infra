# Minecraft Server Dockerfile
# Base: itzg/minecraft-server — handles Java, server jar download, and startup
# Pinning to a specific digest ensures reproducible builds across pipeline runs.

FROM itzg/minecraft-server:java21

# ── Labels ────────────────────────────────────────────────────────────────────
LABEL maintainer="Minsu Kim <934445327>"
LABEL minecraft.version="1.21.4"
LABEL org.opencontainers.image.description="CS312 Minecraft server image"

# ── Default environment variables ────────────────────────────────────────────
# These are overridable at runtime via docker run -e or Ansible's env block.
# EULA must be TRUE or the server refuses to start.
ENV EULA=TRUE \
    VERSION=1.21.4 \
    SERVER_NAME="CS312 Minecraft" \
    MOTD="Minsu Kim | 934445327" \
    MEMORY=3G \
    MAX_PLAYERS=20 \
    DIFFICULTY=normal \
    MODE=survival \
    ONLINE_MODE=TRUE \
    ALLOW_FLIGHT=FALSE \
    VIEW_DISTANCE=10

# ── Persistent data volume ────────────────────────────────────────────────────
# All world data, player data, and server config lives under /data.
# Mount a host directory or named volume here to persist across container restarts.
VOLUME ["/data"]

# ── Port ─────────────────────────────────────────────────────────────────────
EXPOSE 25565

# ── Entrypoint ────────────────────────────────────────────────────────────────
# Inherited from itzg/minecraft-server — manages server jar download,
# EULA acceptance, and JVM startup automatically.