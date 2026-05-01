def Upper(M):
    assert M.nrows() == M.ncols()
    n = M.nrows()
    F = M.base_ring()
    return matrix(F, n, n, lambda i, j: M[i, j] if i == j else (M[i,j] + M[j,i] if i < j else F(0)))


def UOVInstanceFixedZeroes(v, o, m, g, F):
    n = v + o

    # first row with fixed zeroes
    O_top = matrix(F, 1, o, [F(0) for _ in range(g)] + [F.random_element() for _ in range(o-g)])
    O_bottom = random_matrix(F, n-o-1, o)
    O = block_matrix([[O_top],[O_bottom]])

    P1 = [Upper(random_matrix(F, n-o, n-o)) for _ in range(m)]
    P2 = [random_matrix(F, n-o, o) for _ in range(m)]
    P3 = [-Upper(O.transpose() * P1[i] * O + O.transpose() * P2[i]) for i in range(m)]
    P4 = zero_matrix(F, o, n-o)

    P = [block_matrix([[P1[i], P2[i]], [P4, P3[i]]]) for i in range(m)]
    OI = block_matrix([[O], [identity_matrix(F, o)]]).transpose()

    return P, OI


def UOVInstance(v, o, m, F):
    return UOVInstanceFixedZeroes(v, o, m, 0, F)


def TestSolution(O, O_sol):
    return O.echelon_form() == O_sol.echelon_form()