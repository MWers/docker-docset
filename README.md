# Docker Docset Generator



## Build Docker Docset

Create the Docker docset image

```
docker build -t docker-docset .
```

## Copy Docker.docset to local filesystem

Copy `Docker.docset` and `Docker.tgz` to `$(pwd)/release`

```
docker run --rm -it -v $(pwd)/release:/host/release "docker-docset" cp -av ./ /host/release/
```
