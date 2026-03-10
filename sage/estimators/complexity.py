import math
from parameters import *

# ---- helper functions ----

FqCost = lambda q: 2 * (math.log(q, 2)**2) + math.log(q, 2)
Density = lambda v: math.comb(v + 2, 2)
Columns = lambda v, o: math.comb(v + o, v)
Admissible = lambda v, o, m: sum((-1)**j * math.comb(m + j - 1, j) * math.comb(v + o, v + 2 * j) for j in range(o//2 + 1)) <= 0

print("v\to\tm\tq\to'\tcompl.\tSL\tscheme")

parameters = UOVParameters() + MayoParameters() + SNOVAParametersLifted()

for v, m, o_max, q, SL, name in parameters:
    for o in range(2, o_max + 1):
        # Dismiss if multiple subspace solutions
        if m * math.comb(o, 2) < v * o or v >= 2 * m:
            continue

        if Admissible(v, o, m):
            cost = (3 * FqCost(q) * Density(v) * (Columns(v, o)**2))
            print(f"{v}\t{o_max}\t{m}\t{q}\t{o}\t{math.ceil(math.log2(cost))}\t{SL}\t{name}")
            break

