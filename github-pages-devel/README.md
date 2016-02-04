# Usage

## Create docker image

```bash
sh build-image.sh
```

Image name: `italiangrid/github-pages`

## Run jekyll on docker

From your site directory run:

```bash
docker run -v "$PWD:/site" -p 4000:4000 italiangrid/github-pages serve -w -H 0.0.0 -b /storm
```

StoRMìs website will be at available at http://localhost:4000/storm
