import math
import itertools
load("./generate_problem.sage")
load("./construct_M.sage")

############################################################
# correctness tests
############################################################

def TestCorrectnessEven(M, O, n, v, o, idx, F):

    sol = [F(0) for _ in range(math.comb(n, v))]

    for s in itertools.combinations(range(n), v):
        sol[idx[s]] = O[:, [i for i in range(n) if i not in s]].det()

    solution = vector(F, sol)

    assert M * solution == 0


def TestCorrectnessOdd(M, O, n, v, o, idx, F):

    get_index = lambda idx1, idx2: min(idx1, idx2) + math.comb(max(idx1, idx2)+1, 2)

    sol = [F(0) for _ in range(math.comb(n, v))]

    for s in itertools.combinations(range(n), v):
        sol[idx[frozenset(s)]] = O.transpose()[[i for i in range(n) if i not in s], :].det()

    sol2 = [F(0) for _ in range(math.comb(math.comb(n, v) + 1, 2))]

    for x in range(math.comb(n, v)):
        for y in range(x, math.comb(n, v)):
            sol2[get_index(x,y)] = sol[x] * sol[y]

    solution = vector(F, sol2)

    assert M * solution == 0


def TestCorrectnessGuess(M, O, n, v, o, idx, g, F):

    sol = [F(0) for _ in range(math.comb(n, v) - math.comb(v - 1 + g, v))]

    for s in itertools.combinations(range(n), v):
        if frozenset(s) in idx:
            sol[idx[frozenset(s)]] = O[:, [i for i in range(n) if i not in s]].det()

    solution = vector(F, sol)

    assert M * solution == 0


############################################################
# nullity experiments
############################################################

def ComputeNullityEven(v, o, m):

    F = GF(256)
    n = v + o

    Ps, O = UOVInstance(v, o, m, F)
    Qs = [P + P.transpose() for P in Ps]

    M, idx = ConstructM(Qs, v, o, m, F)
    TestCorrectnessEven(M, O, n, v, o, idx, F)

    return M.ncols() - M.rank()


def ComputeNullityOdd(v, o, m):

    F = GF(31)
    n = v + o

    Ps, O = UOVInstance(v, o, m, F)
    Qs = [P + P.transpose() for P in Ps]

    M, idx = ConstructMOdd(Qs, v, o, m, F)
    TestCorrectnessOdd(M, O, n, v, o, idx, F)

    return M.ncols() - M.rank()


def ComputeNullityHybrid(v, o, m, g):

    F = GF(256)
    n = v + o

    Ps, O = UOVInstanceFixedZeroes(v, o, m, g, F)
    Qs = [P + P.transpose() for P in Ps]

    M, idx = ConstructMGuess(Qs, v, o, m, g, F)
    TestCorrectnessGuess(M, O, n, v, o, idx, g, F)

    return M.ncols() - M.rank()


def PredictNullityEven(v, o, m):
    return sum((-1)**j * math.comb(m + j - 1, j) * math.comb(v + o, v + 2*j) for j in range(o//2 + 1))

def PredictNullityOdd(v, o, m):
    return sum((-1)**j * math.comb(m, j) * math.comb(v + o, v + j) * math.comb(v + o + 1, v + j) // (v + j + 1) for j in range(o + 1))
    
def PredictNullityHybrid(v, o, m, g):
    return sum((-1)**j * math.comb(m + j - 1, j) * (math.comb(v + o, v + 2 * j) - math.comb(v - 1 + g, v + 2 * j)) for j in range(o//2 + 1))