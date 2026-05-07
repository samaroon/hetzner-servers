---
name: Bug report
about: Something broken with provisioning, workflows, or cloud-init
labels: bug
---

## Describe the bug

<!-- A clear description of what went wrong. -->

## Steps to reproduce

1. Workflow / action triggered: <!-- server-up / server-down / local terraform -->
2. Inputs used: <!-- region, server_type, server_name_prefix — omit username/password -->
3. Error seen:

## Expected behaviour

<!-- What should have happened. -->

## Logs

<!-- Paste the relevant section from the GitHub Actions run log or /var/log/provision.log. Redact any secrets. -->

<details>
<summary>Log output</summary>

```
paste here
```

</details>

## Environment

- Server type: <!-- cax11 / cpx21 / etc. -->
- Region: <!-- hel1 / nbg1 / etc. -->
- Triggered via: <!-- GitHub Actions / Backstage / local terraform -->
