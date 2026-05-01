# Wedges, oil, and vinegar

This repository contains the code to run and verify the wedge attack in the paper "Wedges, oil, and vinegar".
Furthermore, code for estimating the algorithm complexity against different parameters is included as well.

The code can be found in both the MAGMA and Sage computer algebra languages.
For the paper, the MAGMA variant (`MAGMA V 2.28-8`) was used, however, to keep the code open source a Sage (`sagemath 10.6`) translation is provided.
Note that the Sage code might run significantly slower.
At the bottom of this README we provide a way to use Sage.
Since the functionality of both the MAGMA part and Sage part are identical we will refer simply to the magma files in what follows.
For both languages we provide examples on possible experiments.
These code blocks can be used as input in either an interactive MAGMA session or in the Sage REPL in the corresponding directories.

## The codebase

The codebase consists of 3 parts
-   Full attack
-   Rank verification
-   Complexity estimates

### The full attack

In `wedge_attack.m` the full attack is implemented, including a projection (if possible) and recovering the complete oil space.
These experiments were used to create Table 4 and 5 in the paper.

Note that the attack can fail with a small probability.
For instance, if the system has multiple oil spaces or one chose the projection/pruning unlucky.
In practice one would rerun the algorithm with a different projection/pruning, instead we simply abort.

Example usage:
```cpp
load "./wedge_attack.m";
F := GF(256);
v := 13; o := 6; m := 13;

public, private := UOVInstance(v, o, m, F);
solution := FindOilSpace(public, v, o, m, F);
print "Found correct solution:", TestSolution(private, solution);
```
```python
load("./wedge_attack.sage")
load("./generate_problem.sage")
F = GF(16)
v, o, m = 8, 6, 8

public, private = UOVInstance(v, o, m, F)
solution = FindOilSpace(public, v, o, m, F)
print("Found correct solution:", TestSolution(private, solution))
```
Here, first a system is generated for `v, o, m, F` with public key and private key.
Then the algorithm `FindOilSpace` is performed on the public key and finally the equality of the private key and found private key is tested.

### Rank verification

In `rank_predictions.m`, we test the ranks of the matrices constructed in section 3.2 (`M`), section 5 (`MGuess`), and section 7.1 (`MOdd`).
We compare those to the rank predictions done in the paper corresponding to Tables 2, 6, and 7 and section 5.
As a sanity check, for each of the matrices it is tested whether the oil space is indeed among the kernel elements by the `TestCorrectnessXYZ` methods.
Note that `|F| = 256` in the even case and `|F| = 31` in the odd case are hard-coded for simplicity.

Also note that nullity predictions may fail for specific systems which could happen to be constructed by random.
Mathematically, generic systems (i.e. most random systems) attain the minimal nullity.

Example usage:
```cpp
load "./rank_predictions.m";
v := 9; o := 3; m := 5;

nullity := ComputeNullityEven(v, o, m);
printf "actual:%o predicted:%o\n", nullity, PredictNullityEven(v, o, m);
```
```python
load("./rank_predictions.sage")
v, o, m = 9, 3, 5

nullity = ComputeNullityEven(v, o, m)
print(f"actual: {nullity}, prediction: {PredictNullityEven(v, o, m)}")
```

### Complexity estimates

In `./magma/estimators` one can find the combinatorial estimators that generated Tables 1, 3, 8, and 9.
In the file `parameters.m` we list all parameters in the specifications of the round 2 schemes of UOV, MAYO, QR-UOV, and SNOVA.

Example usage:
```cpp
load "./estimators/parameters.m";
load "./estimators/complexity.m";
load "./estimators/odd_complexity.m";

PrintComplexities(UOVParameters());
PrintComplexities(MayoParameters());
PrintComplexitiesOdd(QRUOVParametersLifted());
```
The complexity computations do not need sage and can simply be started using
```console
python ./sage/estimators/complexity.py
```

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