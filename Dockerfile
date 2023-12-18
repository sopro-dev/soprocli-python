ARG TAG ${TAG:-v1.54.2}
FROM --platform=linux/amd64 sopro-dev/sopro-grpc:${TAG}

# Install dependencies
RUN apt-get update && apt-get -y install \
    tree

# Create dir and copy files
WORKDIR /app
COPY . .

# Run compiler
RUN chmod +x ./scripts/* ;\
    ./scripts/compiler.sh
