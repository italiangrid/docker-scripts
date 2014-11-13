# How to use this image

This container runs the script to generate the CNAF ggus ticket 
report.

```bash
docker run italiangrid:ggus-mon
```

## Env variables

| ----             | ------                                                 |
| GGUS_REPO        | The git repo from which the emi-ggus script is fetched |
| GGUS_REPO_BRANCH | Which branch should be used                            |
| REPORT_URL       | The report URL                                         |
| REPORT_DIR       | In which dir the report will be placed                 |
