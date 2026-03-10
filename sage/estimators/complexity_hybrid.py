import math
from parameters import *

# ---- helper functions ----

FqCost = lambda q: 2 * (math.log(q, 2) ** 2) + math.log(q, 2)
Density = lambda v: math.comb(v + 2, 2)
Columns = lambda v, o, g: math.comb(v + o, v) - math.comb(v - 1 + g, v)
Admissible = lambda v, o, m, g: sum((-1)**j * math.comb(m + j - 1, j) * (math.comb(v + o, v + 2 * j) - math.comb(v - 1 + g, v + 2 * j)) for j in range(o//2 + 1)) <= 0

print("v\to\tm\tq\to'\tg\tcompl.\tSL\tscheme")

parameters = UOVParameters() + MayoParameters() + SNOVAParametersLifted()

for v_max, m, o_max, q, SL, name in parameters:
    print()
    for o in range(2, o_max + 1):
        break_o = False

        for g_tot in range(0, v_max + 1):
            v = v_max - (g_tot // o)
            g = g_tot - (v_max - v) * o

            # Dismiss if multiple subspace solutions
            if m * math.comb(o, 2) < v * o - g or v >= 2 * m:
                continue

            if Admissible(v, o, m, g):
                cost = ((q**g_tot) * 3 * FqCost(q) * Density(v) * (Columns(v, o, g)**2))
                print(f"{v}\t{o_max}\t{m}\t{q}\t{o}\t{g_tot}\t{math.ceil(math.log2(cost))}\t{SL}\t{name}")
                break_o = (g_tot == 0)
                break

        if break_o: break