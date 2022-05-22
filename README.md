# secret-json-secrets
Hide secrets defined in a secret JSON.

GitHub Actions secrets are limited to 100 per repository. Using a single JSON secret which contains multiple secrets allows to extend the number of available secrets, but each sub-secret will not be obfuscated in the workflow logs. To solve this issue, use secret-json-secrets to add a single step to your job which hides all of the relevant sub-secrets (based on pattern matching) and use them freely in the following steps.
