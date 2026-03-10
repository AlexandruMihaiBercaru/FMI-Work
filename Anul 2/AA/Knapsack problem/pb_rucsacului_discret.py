n, C = [int(x) for x in input().split()]
val = [int(x) for x in input().split()]
g = [int(x) for x in input().split()]
total_cost = 0
objects = []

dp = [[0 for _ in range(C+1)] for _ in range(n+1)]

# construim matricea:
for i in range(n+1):
    for c in range(C+1):
        if i == 0 or c == 0:
            dp[i][c] = 0
        elif g[i-1] <= c:
            dp[i][c] = max(val[i-1] + dp[i-1][c - g[i-1]], dp[i-1][c])
        else:
            dp[i][c] = dp[i-1][c]

rez = dp[n][C]
for linie in dp:
    for elem in linie:
        print(elem, end=" ")
    print()