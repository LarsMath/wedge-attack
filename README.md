# Wedges, oil, and vinegar

This repository contains the code to run and verify the wedge attack in the paper "Wedges, oil, and vinegar"
Furthermore, code for estimating the algorithm complexity against different parameters is included as well.

The code can be found in both the MAGMA and Sage computer algebra languages.
For the paper, the MAGMA variant (`MAGMA V 2.28-8`) was used, however, to keep the code open source a Sage (`sagemath 10.6`) translation is provided.
Note that the Sage code might run significantly slower.
At the bottom of this README we provide a way to use Sage.
Since the functionality of both the MAGMA part and sage part are identical we will refer simply to the magma files in what follows.

## The codebase

The codebase consists of 3 parts
-   Full attack
-   Rank verification
-   Complexity estimates

### The full attack

### Rank verification

### Complexity estimates

## Sage Installation

There are many ways to use sage, some more painless than others.
Here we describe two ways, but you are free to use your own method.

### Using docker

In the main directory you can find a docker compose file that will start a docker container with sage pre-installed.
To start the sage REPL, simply run
```console
docker compose run --rm sage
```
From there you can freely use sage commands and to run the pre-defined tests you can run 
```sage
load("./test.sage")
```

If you would like to run the script directly without the REPL you can go with

```console
docker compose run --rm sage sage ./test.sage
```

The `--rm` makes sure that the container gets removed after exiting.

### Using conda

Follow the installation steps for Conda at [Miniforge](https://github.com/conda-forge/miniforge)

Run the following command to create a virtual environment with sage and python.
```console
conda create -n wedges python=3.12 sage=10.6
```

Activate the environment using
```console
conda activate wedges
```

Try the pre-defined tests using
```console
sage test.sage
```

When you are done using Sage you can deactivate the environment using
```
conda deactivate
```