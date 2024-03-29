
# Dockerfile
FROM node:16-alpine

ARG SUPABASE_URL
ENV SUPABASE_URL=https://kxbzixfkcjexfwfacnzq.supabase.co

ARG SUPABASE_KEY
ENV SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt4YnppeGZrY2pleGZ3ZmFjbnpxIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODQ5NTQzODEsImV4cCI6MjAwMDUzMDM4MX0.Jl5GMoQSyVVgOFAHRIyCEFFgsGe1YahNVCaCjehO0hw

ARG API_KEY
ENV API_KEY=amogus

# create destination directory
RUN mkdir -p /usr/src/nuxt-app
WORKDIR /usr/src/nuxt-app

# update and install dependency
RUN apk update && apk upgrade
RUN apk add git

# Install pnpm
RUN npm install -g pnpm

# copy the app, note .dockerignore
COPY . /usr/src/nuxt-app/

RUN pnpm i
RUN pnpm build

EXPOSE 3000

ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3000

CMD [ "pnpm", "start" ]
