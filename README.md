# Deploy and Host Cerbos on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/cerbos?utm_medium=integration&utm_source=button&utm_campaign=cerbos)

Cerbos is an open-source authorization engine. You describe who can do what in YAML or JSON policies, and your application asks Cerbos whether a principal may perform an action on a resource. Decisions take milliseconds and support roles, attributes and conditions, which keeps access rules out of application code.

## About Hosting Cerbos

This template deploys Cerbos 0.55.0 from a small public wrapper repository. The wrapper copies the official binary, pinned by digest, onto Alpine, so a startup script can hash the admin password and write the config. Policies are stored in SQLite on a Railway volume and managed through the Admin API, which needs the generated admin password. The check API and the Admin API share a public HTTPS domain on port 3592, while gRPC stays on the private network on port 3593. The check API itself has no authentication. The server runs as an unprivileged user and fits the Hobby plan.

## Common Use Cases

- Role- and attribute-based access control for SaaS apps and APIs
- One policy decision point shared by services written in different languages
- Changing permissions by updating policies instead of redeploying code

## Dependencies for Cerbos Hosting

- [aalfath/cerbos-railway-template](https://github.com/aalfath/cerbos-railway-template) (official `cerbos/cerbos:0.55.0` binary)
- A Railway volume at `/data` for the SQLite policy store

### Deployment Dependencies

- [Cerbos documentation](https://docs.cerbos.dev/)
- [Cerbos 0.55.0 release](https://github.com/cerbos/cerbos/releases/tag/v0.55.0)
- [Wrapper repository](https://github.com/aalfath/cerbos-railway-template)

### Implementation Details

| Service | Source | Networking | Storage |
| --- | --- | --- | --- |
| cerbos | `aalfath/cerbos-railway-template` | public HTTPS (3592), private gRPC (3593) | volume at `/data` |

| Variable | Purpose |
| --- | --- |
| `CERBOS_ADMIN_USERNAME`, `CERBOS_ADMIN_PASSWORD` | Admin API credentials (hashed with bcrypt at boot) |
| `CERBOS_URL` | Public HTTPS URL |
| `CERBOS_PRIVATE_HTTP_URL`, `CERBOS_PRIVATE_GRPC_ADDR` | Addresses for services in the project |

Add a policy and check a request:

```bash
curl -u admin:$CERBOS_ADMIN_PASSWORD -XPOST "$CERBOS_URL/admin/policy" -d @policies.json
curl -XPOST "$CERBOS_URL/api/check/resources" -d @request.json
```

`cerbosctl put policy` and the Cerbos SDKs' admin clients work with the same credentials. Anyone who knows the public URL can ask for decisions, which reveals what your policies allow; remove the public domain if only your own services need Cerbos.

This is a community-maintained deployment package and does not imply affiliation with or endorsement by Cerbos.

## Why Deploy Cerbos on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Cerbos on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
