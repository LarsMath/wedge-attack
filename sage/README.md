# Sage version

This directory contains the sage version of the implementation.
It is a lot slower than the MAGMA version, but it is open source. 
Below we provide a way to use Sage.

## Sage Installation

Here we will present one of the many ways to use Sage.

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