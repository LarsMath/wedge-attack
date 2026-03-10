import math
load("./generate_problem.sage")
load("./construct_M.sage")

# ================================== Oil space recovery =======================

def FindOilSpace(Ps, v, o, m, F):

    n = v + o
    Qs = [P + P.transpose() for P in Ps]

    # choose projection dimension
    o_proj = next(oi for oi in range(2, o+1) if sum((-1)**j * math.comb(m + j - 1, j) * math.comb(v + oi, v + 2*j) for j in range(oi//2 + 1)) <= 1)
    Qs_proj = [Q[:v+o_proj, :v+o_proj] for Q in Qs]

    M, idx = ConstructM(Qs_proj, v, o_proj, m, F)

    oil_kernel = M.right_kernel()
    assert oil_kernel.dimension() == 1
    V_vec = oil_kernel.basis()[0]

    rows = []
    for i in range(o_proj):
        row = []
        for j in range(v+o_proj):
            if j == v+i:
                row.append(V_vec[idx[tuple(range(v))]])
            elif j < v :
                key = tuple(range(j)) + tuple(range(j+1, v)) + (v+i,)
                row.append(V_vec[idx[key]])
            else:
                row.append(F(0))

        rows.append(row)

    O_proj_sol = matrix(F, rows)

    # ================================== Lifting step =======================

    if o_proj < o:

        o_diff = o - o_proj
        R = PolynomialRing(F, o_diff * v, 'x', order='degrevlex')
        x = R.gens()

        O_proj_sol_ext = block_matrix([[O_proj_sol.change_ring(R), zero_matrix(R, o_proj, o_diff)]])
        Ox = block_matrix([[zero_matrix(R, o_diff, o_proj), matrix(R, o_diff, v, x), identity_matrix(R, o_diff)]])
        O_tot = block_matrix([[O_proj_sol_ext], [Ox]])

        system = []

        for Q in Qs:
            expr = O_tot * Q.change_ring(R) * O_tot.transpose()
            system += list(expr.list())

        solutions = Ideal(system).variety()
        assert len(solutions) != 0, "No lift of solution exist, spurious oil space found"
        solution = solutions[0]

        O_proj_sol = matrix(F, o, n, lambda i, j: O_tot[i, j].subs(solution))

    return O_proj_sol
