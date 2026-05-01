load "./magma/generate_problem.m";
load "./magma/construct_M.m";

// ========================================== Even =============================================

// Reconstructing Λ^v V from the solution
procedure TestCorrectnessEven(M, O, n, v, o, idx, F)
    sol := [Zero(F) : _ in [1..Binomial(n, v)]];
    for s in Subsets({1..n}, v) do
        sol[idx[s]] := Determinant(Submatrix(Transpose(O), [i : i in [1..n] | not i in s], [1..o]));
    end for;
    solution := Vector(F, Binomial(n, v), sol);
    assert solution * M eq 0;
end procedure;

function ComputeNullityEven(v, o, m)
    F := GF(256);
    n := v + o;

    Ps, O := UOVInstance(v, o, m, F);
    Qs := [P + Transpose(P) : P in Ps];
        
    M, idx := ConstructM(Qs, v, o, m, F);

    // Testing whether the solution actually lies in the kernel of the matrix
    TestCorrectnessEven(M, O, n, v, o, idx, F);

    return Nrows(M) - Rank(M);
end function;

PredictNullityEven := function(v, o, m) 
    return Max(0, &+[(-1)^j * Binomial(m + j - 1, j) * Binomial(v + o, v + 2*j) : j in [0..Floor(o/2)]]); 
end function;

// ========================================== Odd =============================================

// Reconstructing Λ^v V ⊗ Λ^v V from the solution
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

function ComputeNullityOdd(v, o, m)
    F := GF(31);
    n := v + o;

    Ps, O := UOVInstance(v, o, m, F);
    Qs := [P + Transpose(P) : P in Ps];

    M, idx := ConstructMOdd(Qs, v, o, m, F);

    // Testing whether the solution actually lies in the kernel of the matrix
    TestCorrectnessOdd(M, O, n, v, o, idx, F);

    return Nrows(M) - Rank(M);
end function;

PredictNullityOdd := function(v, o, m)
    return Max(0, &+[(-1)^j * Binomial(m, j) * Binomial(v + o, v + j) * Binomial(v + o + 1, v + j) / (v + j + 1) : j in [0..o]]);
end function;

// ========================================== Hybrid =============================================

procedure TestCorrectnessHybrid(M, O, n, v, o, idx, g, F)
    sol := [Zero(F) : _ in [1..Binomial(n, v) - Binomial(v-1+g, v)]];
    for s in Subsets({1..n}, v) do
        if IsDefined(idx, s) then sol[idx[s]] := Determinant(Submatrix(Transpose(O), [i : i in [1..n] | not i in s], [1..o])); end if;
    end for;
    solution := Vector(F, Binomial(n, v) - Binomial(v-1+g, v), sol);
    assert solution * M eq 0;
end procedure;

function ComputeNullityHybrid(v, o, m, g)
    F := GF(256);
    n := v + o;

    Ps, O := UOVInstanceFixedZeroes(v, o, m, g, F);
    Qs := [P + Transpose(P) : P in Ps];

    M, idx := ConstructMHybrid(Qs, v, o, m, g, F);

    // Testing whether the solution actually lies in the kernel of the matrix
    TestCorrectnessHybrid(M, O, n, v, o, idx, g, F);

    return Nrows(M) - Rank(M);
end function;

PredictNullityHybrid := function(v, o, m, g) 
    return Max(0, &+[(-1)^j * Binomial(m + j - 1, j) * (Binomial(v + o, v + 2 * j) - Binomial(v - 1 + g, v + 2 * j)) : j in [0..Floor(o/2)]]);
end function;
