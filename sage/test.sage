load("./rank_predictions.sage")
load("./wedge_attack.sage")

# ============================ Some rank tests ==========================

v, o, m = 9, 3, 5
print(f"Rank test v:{v} o:{o} m:{m}")
print(f"Experimental:{ComputeNullityEven(v, o, m)} Predicted:{PredictNullityEven(v, o, m)}\n")

v, o, m = 7, 3, 2
print(f"Odd rank test v:{v} o:{o} m:{m}")
print(f"Experimental:{ComputeNullityOdd(v, o, m)} Predicted:{PredictNullityOdd(v, o, m)}\n")

v, o, m, g = 11, 3, 14, 3
print(f"Hybrid rank test v:{v} o:{o} m:{m} g:{g}")
print(f"Experimental:{ComputeNullityHybrid(v, o, m, g)} Predicted:{PredictNullityHybrid(v, o, m, g)}\n")

# ========================= Full attack test ===========================

F = GF(16)
v, o, m = 8, 6, 8

print(f"Starting wedge attack v:{v} o:{o} m:{m} q:{len(F)}")
Ps, O_solution = UOVInstance(v, o, m, F)
O_found = FindOilSpace(Ps, v, o, m, F)
print(f"Found planted solution: {TestSolution(O_solution, O_found)}\n")