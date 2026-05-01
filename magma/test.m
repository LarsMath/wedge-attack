load "./estimators/parameters.m";
load "./estimators/complexity.m";
load "./estimators/odd_complexity.m";

PrintComplexities(UOVParameters());
PrintComplexities(MayoParameters());
PrintComplexitiesOdd(QRUOVParametersLifted());

print "====================================================================";

load "./magma/rank_predictions.m";

v := 9; o := 3; m := 5;
nullity := ComputeNullityEven(v, o, m);
printf "Even: actual:%o predicted:%o\n", nullity, PredictNullityEven(v, o, m);

v := 7; o := 3; m := 2;
nullity := ComputeNullityOdd(v, o, m);
printf "Odd: actual:%o predicted:%o\n", nullity, PredictNullityOdd(v, o, m);

v := 11; o := 3; m := 14; g := 3;
nullity := ComputeNullityHybrid(v, o, m, g);
printf "Guess: actual:%o predicted:%o\n", nullity, PredictNullityHybrid(v, o, m, g);

print "====================================================================";

load "./magma/wedge_attack.m";
F := GF(256);
v := 13; o := 6; m := 13;

public, private := UOVInstance(v, o, m, F);
solution := FindOilSpace(public, v, o, m, F);
print "Found correct solution:", TestSolution(private, solution);
