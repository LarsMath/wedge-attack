load "./generate_problem.m";
load "./construct_M.m";

function FindOilSpace(Ps, v, o, m, F)
    n := v + o;

    // Constructing polar forms
    Qs := [P + Transpose(P) : P in Ps];

    // Choosing projection
    o_proj := [o_i : o_i in [2..o] | &+[(-1)^j * Binomial(m + j - 1, j) * (Binomial(v + o_i, v + 2*j)) : j in [0..Floor(o_i/2)]] le 0][1];
    Qs_proj := [Submatrix(Q, [1..v+o_proj], [1..v+o_proj]) : Q in Qs];

    // Constructing the Macaulay matrix
    M, idx := ConstructM(Qs_proj, v, o_proj, m, F);

    // Recovering the unique kernel element
    oil_kernel := Nullspace(M);
    assert Dimension(oil_kernel) eq 1; // Fail if not exactly 1 oil space is found
    V_vec := Basis(oil_kernel)[1];

    // Reconstructing the (projected) oil space from kernel element
    O_proj_sol := Matrix(F, o_proj, v+o_proj, [[j in ({1..v} join {v+i}) select V_vec[idx[({1..v} join {v+i}) diff {j}]] else 0 : j in [1..v+o_proj]] : i in [1..o_proj]]);

    // If we projected, we reconstruct the entire oil space from the projected one
    if o_proj lt o then
        o_diff := o - o_proj;
        R<[x]> := PolynomialRing(F, o_diff * v, "grevlex");
        O_proj_sol_ext := HorizontalJoin(ChangeRing(O_proj_sol, R), ZeroMatrix(R, o_proj, o_diff));
        Ox := HorizontalJoin(HorizontalJoin(ZeroMatrix(R, o_diff, o_proj), Matrix(R, o_diff, v, x)), ScalarMatrix(R, o_diff, 1));
        O_tot := VerticalJoin(O_proj_sol_ext, Ox);

        system := &cat[Eltseq(O_tot * ChangeRing(Q, R) * Transpose(O_tot)) : Q in Qs];

        solution := Variety(Ideal(system))[1];

        O_proj_sol := Matrix(F, o, n, [[Evaluate(O_tot[i][j], solution) : j in [1..n]] : i in [1..o]]);
    end if;

    return O_proj_sol;

end function;
