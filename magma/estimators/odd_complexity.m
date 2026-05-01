Admissible := function(v, o, m) return 0 ge &+[(-1)^j * Binomial(m, j) * Binomial(v+o, v+j) * Binomial(v+o+1,v+j) / (v+j+1)  : j in [0..o]]; end function;

Density := function(v) return (v + 1)^2; end function;
Columns := function(v, o) return Binomial(v + o, v) * Binomial(v + o + 1, v) / (v + 1); end function;
Cost := function(v, o) return 3 * Density(v) * Columns(v, o)^2; end function;

function Complexity(v, o, m)
    BestComplexity := -1;
    BestHypers := <0>; // <o'>

    for o_reduced in [1..o] do
        n := v + o_reduced;

        if m * Binomial(o_reduced + 1, 2) lt v * o_reduced then continue; end if;

        if Admissible(v, o_reduced, m) then
            cost := Cost(v, o_reduced);
            if BestComplexity eq -1 or cost lt BestComplexity then
                BestComplexity := cost;
                BestHypers := <o_reduced>;
            end if;
        end if;
    end for;
    return BestComplexity, BestHypers;
end function;


procedure PrintComplexities(parameters)
    print "Scheme\tSL\t| v\to\tm\t| o'\tcomplexity";
    for p in parameters do
        v, m, o, _, SL, scheme := Explode(p);
        cost, hypers := Complexity(v, o, m);
        if cost gt 0 then
            printf "%o\t%o\t| %o\t%o\t%o\t| %o\t%o\n", scheme, SL, v, o, m, hypers[1], Ceiling(Log(2, cost));
        else
            printf "%o\t%o\t| %o\t%o\t%o\t| %o\t%o\n", scheme, SL, v, o, m, "N/A", "N/A";
        end if;
    end for;
end procedure;
