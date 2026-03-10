load "./generate_problem.m";
load "./construct_M.m";

procedure TestCorrectnessEven(M, O, n, v, o, idx, F)
    sol := [Zero(F) : _ in [1..Binomial(n, v)]];
    for s in Subsets({1..n}, v) do
        sol[idx[s]] := Determinant(Submatrix(Transpose(O), [i : i in [1..n] | not i in s], [1..o]));
    end for;
    solution := Vector(F, Binomial(n, v), sol);
    assert solution * M eq 0;
end procedure;

procedure TestCorrectnessOdd(M, O, n, v, o, idx, F)
    sol := [Zero(F) : _ in [1..Binomial(n, v)]];
    for s in  Subsets({1..n}, v) do
        sol[idx[s]] := Determinant(Submatrix(Transpose(O), [i : i in [1..n] | not i in s], [1..o]));
    end for;
    sol2 := [Zero(F) : _ in [1..Binomial(Binomial(n, v) + 1, 2)]];
    for x in [1..Binomial(n, v)] do
        for y in [x..Binomial(n, v)] do
            sol2[GetIndex(x, y)] := sol[x] * sol[y];
        end for;
    end for;
    solution := Vector(F, Binomial(Binomial(n, v) + 1, 2), sol2);
    assert solution * M eq 0;
end procedure;

procedure TestCorrectnessGuess(M, O, n, v, o, idx, g, F)
    sol := [Zero(F) : _ in [1..Binomial(n, v) - Binomial(v-1+g, v)]];
    for s in Subsets({1..n}, v) do
        if IsDefined(idx, s) then sol[idx[s]] := Determinant(Submatrix(Transpose(O), [i : i in [1..n] | not i in s], [1..o])); end if;
    end for;
    solution := Vector(F, Binomial(n, v) - Binomial(v-1+g, v), sol);
    assert solution * M eq 0;
end procedure;

function ComputeNullityEven(v, o, m)
    F := GF(256);
    n := v + o;

    Ps, O := UOVInstance(v, o, m, F);
    Qs := [P + Transpose(P) : P in Ps];
        
    M, idx := ConstructM(Qs, v, o, m, F);

    TestCorrectnessEven(M, O, n, v, o, idx, F);

    return Nrows(M) - Rank(M);
end function;

function ComputeNullityOdd(v, o, m)
    F := GF(31);
    n := v + o;

    Ps, O := UOVInstance(v, o, m, F);
    Qs := [P + Transpose(P) : P in Ps];

    M, idx := ConstructMOdd(Qs, v, o, m, F);
    TestCorrectnessOdd(M, O, n, v, o, idx, F);

    return Nrows(M) - Rank(M);
end function;

function ComputeNullityGuess(v, o, m, g)
    F := GF(256);
    n := v + o;

    Ps, O := UOVInstanceFixedZeroes(v, o, m, g, F);
    Qs := [P + Transpose(P) : P in Ps];

    M, idx := ConstructMGuess(Qs, v, o, m, g, F);

    TestCorrectnessGuess(M, O, n, v, o, idx, g, F);

    return Nrows(M) - Rank(M);
end function;

print ComputeNullityEven(9, 3, 5);
print ComputeNullityOdd(7, 3, 2);
print ComputeNullityGuess(11, 3, 14, 3);