# Docker Docset Generator

## Build Docker Docset

Create the Docker docset image

```
docker build -t "docker-docset:1.4.1" .
```

## Copy Docker.docset to local filesystem

Copy `Docker.docset` and `Docker.tgz` to `$(pwd)/release`

```
docker run --rm -it -v $(pwd)/release:/host/release "docker-docset:1.4.1" cp -av ./ /host/release/
```

## TODO

1. Add `Makefile`
1. Add section to page titles
1. Add index for select pages (like Dockerfile and CLI reference)
1. Clean up `README.md`
