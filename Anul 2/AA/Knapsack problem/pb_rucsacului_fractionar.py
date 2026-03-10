from math import floor

n, C = [int(x) for x in input().split()]
val = [int(x) for x in input().split()]
g = [int(x) for x in input().split()]
total_cost = 0
objects = []
for i in range(n):
    objects.append((i, val[i] / g[i]))
objects = sorted(objects, key=lambda x: x[1], reverse=True)
for ob in objects:
    if g[ob[0]] < C:
        C -= g[ob[0]]
        total_cost += val[ob[0]]
    else:
        total_cost += val[ob[0]] * C / g[ob[0]]
        break

if floor(total_cost) == total_cost:
    print(floor(total_cost))
else:
    print(round(total_cost, 4))