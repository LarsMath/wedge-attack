load "./parameters.m";

Density := function(v) return (v + 1)^2; end function;
Columns := function(v, o) return Binomial(v + o, v) * Binomial(v + o + 1, v) / (v + 1); end function;

print "log2q\tv\to\tm\to'\tcomplexity\tSL\tscheme";

parameters := QRUOVParametersLifted();

for p in parameters do

    //--------------------------------------
    v, m, o_max, q, L, name := Explode(p);
    //--------------------------------------

    for o in [1..o_max] do
        n := v + o;

        if m * Binomial(o+1, 2) lt v * o then continue; end if;

        if &+[(-1)^j * Binomial(m, j) * Binomial(v+o, v+j) * Binomial(v+o+1,v+j) / (v+j+1)  : j in [0..o]] le 0 then
            cost := 3 * Density(v) * Columns(v, o)^2;
            printf "%o\t%o\t%o\t%o\t%o\t%o\t\t%o\t%o\n", Ceiling(Log(2, q)), v, o_max, m, o, Ceiling(Log(2, cost)), L, name;
            break;
        end if;
    end for;
end for;

