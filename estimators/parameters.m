// Return all in the form v, m, o, q, L

function UOVParameters()
    // n, m, q, L
    parameters := [<112, 44, 256, 1>, <160, 64, 16, 1>, <184, 72, 256, 3>, <244, 96, 256, 5>];
    return [<p[1] - p[2], p[2], p[2], p[3], p[4], "UOV"> : p in parameters];
end function;

function MayoParameters()
    // n, m, o, k, q, L
    parameters := [<86, 78, 8, 10, 16, 1>, <81, 64, 17, 4, 16, 1>, <118, 108, 10, 11, 16, 3>, <154, 142, 12, 12, 16, 5>];
    return [<p[1] - p[3], p[2], p[3], p[5], p[6], "MAYO"> : p in parameters];
end function;

function QRUOVParameters()
    // q, v, m, l, L
    parameters := [<127, 156, 54, 3, 1>, <7, 740, 100, 10, 1>, <31, 165, 60, 3, 1>, <31, 600, 70, 10, 1>, <127, 228, 78, 3, 3>, <7, 1100, 140, 10, 3>, <31, 246, 87, 3, 3>, <31, 890, 100, 10, 3>, <127, 306, 105, 3, 5>, <7, 1490, 190, 10, 5>, <31, 324, 114, 3, 5>, <31, 1120, 120, 10, 5>];
    return [<p[2], p[3], p[3], p[1], p[5], "QR-UOV"> : p in parameters];
end function;

function QRUOVParametersLifted()
    // q, v, m, l, L
    parameters := [<127, 156, 54, 3, 1>, <7, 740, 100, 10, 1>, <31, 165, 60, 3, 1>, <31, 600, 70, 10, 1>, <127, 228, 78, 3, 3>, <7, 1100, 140, 10, 3>, <31, 246, 87, 3, 3>, <31, 890, 100, 10, 3>, <127, 306, 105, 3, 5>, <7, 1490, 190, 10, 5>, <31, 324, 114, 3, 5>, <31, 1120, 120, 10, 5>];
    return [<Floor(p[2]/ p[4]), p[3], Floor(p[3]/ p[4]), p[1]^p[4], p[5], "QR-UOV_lifted"> : p in parameters];
end function;

function SNOVAParameters()
    // v, o, q, l, L
    parameters := [<37, 17, 16, 2, 1>, <25, 8, 16, 3, 1>, <24, 5, 16, 4, 1>, <56, 25, 16, 2, 3>, <49, 11, 16, 3, 3>, <37, 8, 16, 4, 3>, <24, 5, 16, 5, 3>, <75, 33, 16, 2, 5>, <66, 15, 16, 3, 5>, <60, 10, 16, 4, 5>, <29, 6, 16, 5, 5>];
    return [<p[4]*p[1], p[4]*p[4]*p[2], p[4]*p[2], p[3], p[5], "SNOVA"> : p in parameters];
end function;

function SNOVAParametersLifted()
    // v, o, q, l, L
    parameters := [<37, 17, 16, 2, 1>, <25, 8, 16, 3, 1>, <24, 5, 16, 4, 1>, <56, 25, 16, 2, 3>, <49, 11, 16, 3, 3>, <37, 8, 16, 4, 3>, <24, 5, 16, 5, 3>, <75, 33, 16, 2, 5>, <66, 15, 16, 3, 5>, <60, 10, 16, 4, 5>, <29, 6, 16, 5, 5>];
    return [<p[1], p[2], p[2], p[3]^p[4], p[5], "SNOVA_lifted"> : p in parameters];
end function;

function SNOVAParametersOdd()
    // v, o, q, l, L
    parameters := [<37, 17, 23, 2, 1>, <25, 8, 23, 3, 1>, <24, 5, 23, 4, 1>, <56, 25, 23, 2, 3>, <49, 11, 23, 3, 3>, <37, 8, 23, 4, 3>, <24, 5, 23, 5, 3>, <75, 33, 23, 2, 5>, <66, 15, 23, 3, 5>, <60, 10, 23, 4, 5>, <29, 6, 23, 5, 5>];
    return [<p[1], p[2], p[2], p[3]^p[4], p[5], "SNOVA_lifted"> : p in parameters];
end function;

function EvenCharParameters()
    all := UOVParameters() cat MayoParameters() cat SNOVAParameters() cat SNOVAParametersLifted();
    return [p : p in all | p[5] eq 1] cat [p : p in all | p[5] eq 3] cat [p : p in all | p[5] eq 5];
end function;

function OddCharParameters()
    all := QRUOVParameters() cat QRUOVParametersLifted();
    return [p : p in all | p[5] eq 1] cat [p : p in all | p[5] eq 3] cat [p : p in all | p[5] eq 5];
end function;

function AllParameters()
    all := UOVParameters() cat MayoParameters() cat QRUOVParameters() cat QRUOVParametersLifted() cat SNOVAParameters() cat SNOVAParametersLifted();
    return [p : p in all | p[5] eq 1] cat [p : p in all | p[5] eq 3] cat [p : p in all | p[5] eq 5];
end function;
