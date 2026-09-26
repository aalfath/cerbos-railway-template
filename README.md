# Cerbos on Railway

A small wrapper around the official [Cerbos](https://github.com/cerbos/cerbos) 0.55.0 image for the Railway template. The Cerbos binary is copied unchanged from `cerbos/cerbos:0.55.0` (pinned by digest) onto Alpine, so that `entrypoint.sh` can:

- hash `CERBOS_ADMIN_PASSWORD` with bcrypt, as the Admin API expects,
- write the config (HTTP on `[::]:3592`, gRPC on `[::]:3593`, SQLite policy store in `/data`),
- start Cerbos as a non-root user.

The template overview will be added here once the template is published.
