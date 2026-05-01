import itertools
import random
import math

def ConstructM(qs, v, o, m, F):
    n = v + o

    # Column/Row labels
    idx = {I: i for i, I in enumerate(itertools.combinations(range(n), v))}
    rows = [(J, k) for J in itertools.combinations(range(n), v + 2) for k in range(m)]

    # Choose rows to keep/prune
    if math.comb(n, v) < m * math.comb(n, v + 2):
        kept_rows = set(random.sample(range(m * math.comb(n, v + 2)), math.comb(n, v)))
        rows = [r for i, r in enumerate(rows) if i in kept_rows]

    entries = dict()
    for r, (J, k) in enumerate(rows):
        entries.update({(r, idx[J[:x] + J[x+1:y] + J[y+1:]]) : qs[k][J[x]][J[y]] for x in range(v+2) for y in range(x+1, v+2)})

    M = matrix(F, math.comb(n, v), math.comb(n, v), entries)
    return M, idx

def ConstructMOdd(Qs, v, o, m, F):
    get_index = lambda idx1, idx2: min(idx1, idx2) + math.comb(max(idx1, idx2) + 1, 2)
    sign = lambda s, i: (-1) ** sum(1 for j in s if j > i)

    n = v + o

    # index subsets of size v
    idx = {frozenset(s): i for i, s in enumerate(itertools.combinations(range(n), v))}

    entries = dict()
    r = 0

    nn = set(range(n))

    for s1 in itertools.combinations(range(n), v + 1):
        s1 = set(s1)
        for s2 in itertools.combinations(range(n), v - 1):
            s2 = set(s2)
            if not s2.issubset(s1):
                r += 1
                for i in (s1 - s2):
                    idx1 = idx[frozenset(s1 - {i})]
                    idx2 = idx[frozenset(s2 | {i})]
                    col = get_index(idx1, idx2)
                    val = sign(s1, i) * sign(s2, i)
                    entries[(r, col)] = val

        for s2 in itertools.combinations(range(n), v + 1):
            s2 = set(s2)
            for Q in Qs:
                r += 1
                terms = []
                for i in s1:
                    for j in s2:
                        idx1 = idx[frozenset(s1 - {i})]
                        idx2 = idx[frozenset(s2 - {j})]
                        col = get_index(idx1, idx2)

                        val = (Q[i][j] * sign(nn - s1, i) * sign(nn - s2, j))
                        terms.append((col, val))

                cols = set(t[0] for t in terms)
                entries.update({(r, c): sum(t[1] for t in terms if t[0] == c) for c in cols})

    M = matrix(F, r+1, math.comb(math.comb(n, v) + 1, 2), entries)
    return M, idx


def ConstructMGuess(Qs, v, o, m, g, F):
    n = v + o

    idx = {}
    i = 0

    forbidden = set(range(1, v + g))

    for s in itertools.combinations(range(n), v):
        if not set(s).issubset(forbidden):
            idx[frozenset(s)] = i
            i += 1


    row_labels = [(J, k) for J in itertools.combinations(range(n), v + 2) for k in range(m)]

    entries = dict()
    for r, (s, k) in enumerate(row_labels):
        for y in s:
            for x in s:
                if x < y:
                    key = frozenset(set(s) - {x, y})
                    if key in idx:
                        entries[(r, idx[key])] = Qs[k][x][y]

    rows = m * math.comb(n, v + 2)
    cols = math.comb(n, v) - math.comb(v - 1 + g, v)

    M = matrix(F, rows, cols, entries, sparse=True)

    return M, idx