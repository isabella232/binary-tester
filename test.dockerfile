ARG IMAGE

# using a builder step just so we don't have to run npm i later; this may already prevent some bugs
FROM node as builder

ARG FETCH_ENGINE_VERSION=latest

WORKDIR /app

RUN node -v
RUN npm -v

RUN echo "build machine information:" && \
  lsb_release -a || true && \
  uname -a || true && \
  ls /lib/x86_64-linux-gnu | grep libssl || true && \
  openssl version || true

RUN npm i @prisma/fetch-engine@$FETCH_ENGINE_VERSION

COPY fetch.js schema.prisma ./

# start the real image and run the test script
FROM $IMAGE

WORKDIR /app

COPY --from=builder /app /app

COPY test-prisma.sh ./

CMD sh test-prisma.sh