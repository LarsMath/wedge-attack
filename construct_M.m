function ConstructM(Qs, v, o, m, F)
    n := v + o;
    idx := AssociativeArray(Subsets({1..n}, v)); i := 1; for s in Subsets({1..n}, v) do idx[s] := i; i +:= 1; end for;

    kept := {1..m * Binomial(n, v + 2)};
    if Binomial(n, v) lt #kept then
        kept := RandomSubset({1..m * Binomial(n, v + 2)}, Binomial(n, v));
    end if;

    count := <0, 0>; // Total/kept rows count
    entries := [];
    for s in Subsets({1..n}, v+2) do
        for Q in Qs do
            count[1] +:= 1;
            if count[1] in kept then
                count[2] +:= 1;
                entries cat:=[<idx[s diff {x, y}], count[2], Q[x][y]> : y in s, x in s | x lt y];
            end if;
        end for;
    end for;

    return SparseMatrix(F, Binomial(n, v), Binomial(n, v), entries), idx;
end function;

function GetIndex(idx1, idx2)
    return Min(idx1, idx2) + Binomial(Max(idx1, idx2), 2);
end function;

function Sign(s, i)
    return (-1)^#[j : j in s | j gt i];
end function;

function ConstructMOdd(Qs, v, o, m, F)
    n := v + o;
    idx := AssociativeArray(Subsets({1..n}, v)); i := 1; for s in Subsets({1..n}, v) do idx[s] := i; i +:= 1; end for;

    // plucker_relations := Binomial(n, v + 1) * Binomial(n, v - 1) - Binomial(n, v-1) * Binomial(o+1, 2);
    // plucker_coordinates := Floor(Binomial(n, v) * Binomial(n, v+1) / (v+1));

    entries := [];
    r := 0;
    for s1 in Subsets({1..n}, v+1) do
        for s2 in Subsets({1..n}, v-1) do
            if not s2 subset s1 then
                r +:= 1;
                entries cat:=[<GetIndex(idx[s1 diff {i}], idx[s2 join {i}]), r, Sign(s1, i) * Sign(s2, i)> : i in (s1 diff s2)];
            end if;
        end for;
        for s2 in Subsets({1..n}, v+1) do
            for Q in Qs do
                r +:= 1;
                terms := [<GetIndex(idx[s1 diff {i}], idx[s2 diff {j}]), Q[i][j] * Sign({1..n} diff s1, i) * Sign({1..n} diff s2, j)> : i in s1, j in s2];
                entries cat:=[<i, r, &+[t[2] : t in terms | t[1] eq i] > : i in {t[1] : t in terms}];
            end for;
        end for;
    end for;

    return SparseMatrix(F, Binomial(Binomial(n, v) + 1, 2), r, entries), idx;
end function;

function ConstructMGuess(Qs, v, o, m, g, F)
    n := v + o;
    idx := AssociativeArray(Subsets({1..n}, v)); i := 0; 
    for s in Subsets({1..n}, v) do 
        if not s subset {2..v+g} then
            i +:= 1; idx[s] := i;
        end if;
    end for;

    entries := [];
    col := 0;
    for s in Subsets({1..n}, v+2) do
        for Q in Qs do
            col +:= 1;
            entries cat:=[<idx[s diff {x, y}], col, Q[x][y]> : y in s, x in s | x lt y and IsDefined(idx, s diff {x, y})];
        end for;
    end for;
        
    return SparseMatrix(F, Binomial(n, v) - Binomial(v-1+g, v), m * Binomial(n, v + 2), entries), idx;
end function;