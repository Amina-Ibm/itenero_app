# Build stage
FROM dart:3.8.0 AS build

WORKDIR /app

# Copy everything
COPY . .

# Get dependencies and compile
RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/server

# Runtime stage
FROM debian:bookworm-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy compiled server
COPY --from=build /app/bin/server ./server

# Copy all necessary files
COPY --from=build /app/config ./config
COPY --from=build /app/migrations ./migrations
COPY --from=build /app/web ./web
COPY --from=build /app/lib ./lib

# Make executable
RUN chmod +x ./server

# Expose all three ports
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# Start server
CMD ["./server", "--mode", "production", "--apply-migrations"]