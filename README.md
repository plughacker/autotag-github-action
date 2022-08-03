Autotag GitHub Actions

<hr>

## Example

```hcl
on: [push]

jobs:
  autotag:
    name: 'Auto tag'
    runs-on: ubuntu-latest
    steps:
      - name: Auto tag
        uses: plughacker/autotag-github-action@main
        with:
          repository: <company>/<repository>
          gh_token: ${{ secrets.GH_TOKEN }}
          git_username: "infra"
          git_user_email: "infra@example.com"
```

## Inputs

| Input name       | Description                                         | Required |
|------------------|-----------------------------------------------------|----------|
| repository       | The path of the GitHub repository                   | Yes      |
| gh_token         | The GitHub Token with repo access                   | Yes      |
| git_username     | GitHub account user name                            | Yes      |
| git_user_email   | GitHub account user email                           | Yes      |

