load "./parameters.m";

FqCost := function(q) return 2 * Log(2, q)^2 + Log(2, q); end function;
Density := function(v) return Binomial(v + 2, 2); end function;
Columns := function(v, o, g) return Binomial(v + o, v) - Binomial(v-1+g, v); end function;

print "v\to\tm\tq\to'\tg\tcompl.\tSL\tscheme";

parameters := UOVParameters() cat MayoParameters();

for p in parameters do

    //--------------------------------------
    v_max, m, o_max, q, L, name := Explode(p);
    //--------------------------------------


    for o in [2..o_max] do
        break_o := false;
        for g_tot in [0..v_max] do

            v := v_max - Floor(g_tot/o);
            g := g_tot - (v_max - v) * o;

            n := v + o;

            if m * Binomial(o, 2) lt v * o - g or v ge 2*m then continue; end if; // Dismiss if multiple subspace solutions

            if &+[(-1)^j * Binomial(m + j - 1, j) * (Binomial(v + o, v + 2*j) - Binomial(v-1+g, v + 2*j))  : j in [0..Ceiling(o/2)]] le 0 then
                cost := q^g_tot * 3 * FqCost(q) * Density(v) * Columns(v, o, g)^2;
                printf "%o\t%o\t%o\t%o\t%o\t%o\t%o\t%o\t%o\n", v, o_max, m, q, o, g_tot, Ceiling(Log(2, cost)), L, name;
                if g_tot eq 0 then break_o := true; end if;
                break;
            end if;
        end for;
        if break_o then break; end if;
    end for;

    printf "\n";
end for;
