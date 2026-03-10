import math
from parameters import *

# ---- helper functions ----

Density = lambda v: (v + 1)**2
Columns = lambda v, o: math.comb(v + o, v) * math.comb(v + o + 1, v) // (v + 1)
Admissible = lambda v, o, m: sum((-1)**j * math.comb(m, j) * math.comb(v + o, v + j) * math.comb(v + o + 1, v + j) // (v + j + 1) for j in range(o + 1)) <= 0

print("v\to\tm\tq\to'\tcompl.\tSL\tscheme (complexity in field operations!)")

parameters = QRUOVParametersLifted() + UOVoddParameters()

for v, m, o_max, q, SL, name in parameters:
    for o in range(2, o_max + 1):
        # Dismiss if multiple subspace solutions
        if m * math.comb(o + 1, 2) < v * o:
            continue

        if Admissible(v, o, m):
            cost = (3 * Density(v) * (Columns(v, o)**2))
            print(f"{v}\t{o_max}\t{m}\t{q}\t{o}\t{math.ceil(math.log2(cost))}\t{SL}\t{name}")
            break

