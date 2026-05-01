Admissible := function(v, o, m, g) return 0 ge &+[(-1)^j * Binomial(m + j - 1, j) * (Binomial(v + o, v + 2*j) - Binomial(v - 1 + g, v + 2*j)) : j in [0..Ceiling(o/2)]]; end function;

FqCost := function(q) return 2 * Log(2, q)^2 + Log(2, q); end function;
Density := function(v) return Binomial(v + 2, 2); end function;
Columns := function(v, o, g) return Binomial(v + o, v) - Binomial(v - 1 + g, v); end function;
Cost := function(v, o, q, g) return q^g * 3 * FqCost(q) * Density(v) * Columns(v, o, g)^2; end function;

function Complexity(v, o, m, q)
    BestComplexity := -1;
    BestHypers := <0, 0, 0>; // <v', o', g>

    for o_reduced in [1..o] do

        for v_reduced in [o..v] do
            // Guessing v or more positions already gives us an oil vector
            if (v - v_reduced) * o_reduced ge v then continue; end if;

            n := v_reduced + o_reduced;

            // Guessing partial v
            for g in [0..o_reduced-1] do

                // Dismiss if unwanted kernel elements are expected
                if m * Binomial(o_reduced, 2) lt v_reduced * o_reduced - g or v_reduced ge 2*m then continue; end if; 

                if Admissible(v_reduced, o_reduced, m, g) then
                    cost := q^((v - v_reduced) * o_reduced) * Cost(v_reduced, o_reduced, q, g);
                    if BestComplexity eq -1 or cost lt BestComplexity then
                        BestComplexity := cost;
                        BestHypers := <v_reduced, o_reduced, g>;
                    end if;
                end if;
            end for;
        end for;
    end for;
    return BestComplexity, BestHypers;
end function;

procedure PrintComplexities(parameters)
    print "Scheme\tSL\t| v\to\tm\tq\t| v'\to'\tg\tcompl.";
    for p in parameters do
        v, m, o, q, SL, scheme := Explode(p);
        cost, hypers := Complexity(v, o, m, q);
        if cost gt 0 then
            printf "%o\t%o\t| %o\t%o\t%o\t%o\t| %o\t%o\t%o\t%o\n", scheme, SL, v, o, m, q, hypers[1], hypers[2], hypers[3], Ceiling(Log(2, cost));
        else
            printf "%o\t%o\t| %o\t%o\t%o\t%o\t| %o\t%o\t%o\t%o\n", scheme, SL, v, o, m, q, "N/A", "N/A", "N/A", "N/A";
        end if;
    end for;
end procedure;
