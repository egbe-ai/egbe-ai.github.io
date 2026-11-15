# Egbe personal-agent discovery

Companion to egbe-ai/claw-swarm#5387. These static documents identify `egbe.ai`
and delegate account authorization and APIs to `https://dashboard.egbe.ai/poppy`.
The issuer must list `https://egbe.ai` in `protected_resources`.

Merge/publish only after the Dashboard integration is deployed and enabled for
the pilot's approved client metadata URLs. The `.nojekyll` marker lets GitHub
Pages publish `.well-known`; the existing site is static HTML with no Jekyll
front matter or template directives.

Release check: the extensionless `/.well-known/oauth-protected-resource` must
return `Content-Type: application/json`, per RFC 9728. GitHub Pages may serve an
extensionless file as `application/octet-stream`; set a response-header transform
at the apex edge for exactly:

```
http.host eq "egbe.ai" and http.request.uri.path eq "/.well-known/oauth-protected-resource"
```

Set `Content-Type` to `application/json`. Do not modify other paths or hosts.
The JSON file itself is kept extensionless to match the well-known URL.

Verify both documents over HTTPS, check their response types, fetch the issuer
metadata and OpenAPI description, and complete an authorized test-client flow
before claiming live support. Muse-specific interoperability is still unverified.
Do not change DNS or merge this PR before the issuer is ready.

Rollback: remove the two discovery documents. This does not remove existing
Dashboard grants; revoke them in Dashboard if the pilot is ending.
