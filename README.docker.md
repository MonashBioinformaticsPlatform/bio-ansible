# Building a Docker image of bio-ansible

`bio-ansible` can be used to build a container with a subset of tools.

To build using your current clone of `bio-ansible` (eg for testing):
```bash
docker build -t bioansible -f docker/Dockerfile-local .
```

Several of the slower steps (`r_core`, `r_extras`, `blast`) are executed as 
separate `RUN` commands so that these get cached as intermediate Docker layers.
This allows a single task to be tested quickly (by tag) by adding it at the 
end of the `Dockerfile-local`. If you want to run all steps from scratch, run
with the `--no-cache` option:

```bash
docker build --no-cache -t bioansible:latest -f docker/Dockerfile-local .
```

To test a specific tag(s) in the `bio.yml` playbook (eg hisat2 and muscle):
```bash
docker build --build-arg TASK_TAGS=hisat2,muscle -t bioansible -f docker/Dockerfile-bio-tags .
```

To build a production image by pulling the master branch:
```bash
docker build -t bioansible:latest -f docker/Dockerfile-repo .
```

We also have a Dockerfile for building a lighter-weight container than only
runs the RNAsik pipeline:

```bash
docker build -t rnasik:latest -f docker/Dockerfile-rnasik .
docker run -t rnasik:latest -help
```
