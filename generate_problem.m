function Upper(M)
    assert Nrows(M) eq Ncols(M);
    n := Nrows(M);
    return Matrix(BaseRing(M), n, n, [[i lt j select M[i][j] + M[j][i] else (i eq j select M[i][j] else 0) : j in [1..n]] : i in [1..n]]);
end function;

function UOVInstanceFixedZeroes(v, o, m, g, F)
    n := v + o;
    
    O := VerticalJoin(Matrix(F, 1, o, [0 : _ in [1..g]] cat [Random(F) : _ in [1..o-g]] ), RandomMatrix(F, n-o-1, o));
    P1 := [Upper(RandomMatrix(F, n-o, n-o)) : _ in [1..m]];
    P2 := [RandomMatrix(F, n-o, o) : _ in [1..m]];
    P3 := [-Upper(Transpose(O) * P1[i] * O + Transpose(O) * P2[i]) : i in [1..m]];
    P4 := ZeroMatrix(F, o, n-o);

    P := [VerticalJoin(HorizontalJoin(P1[i], P2[i]), HorizontalJoin(P4, P3[i])) : i in [1..m]];
    OI := Transpose(VerticalJoin(O, ScalarMatrix(F, o, 1)));

    return P, OI;
end function;

function UOVInstance(v, o, m, F)
    return UOVInstanceFixedZeroes(v, o, m, 0, F);
end function;

function TestSolution(O, O_sol)
    return EchelonForm(O) eq EchelonForm(O_sol);
end function;
