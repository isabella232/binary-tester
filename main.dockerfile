ARG IMAGE
ARG FETCH_ENGINE_VERSION=latest

# using a builder step just so we don't have to run npm i later; this may already prevent some bugs
FROM node as builder

WORKDIR /app

RUN node -v
RUN npm -v

RUN npm i @prisma/fetch-engine@$FETCH_ENGINE_VERSION

COPY fetch.js schema.prisma ./

# start the real image and run the test script
FROM base_$IMAGE

WORKDIR /app

COPY --from=builder /app /app

COPY test.sh ./

CMD sh test.sh
