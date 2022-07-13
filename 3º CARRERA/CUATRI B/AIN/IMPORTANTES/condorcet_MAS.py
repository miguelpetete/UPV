# ======================================================================
# Simple program to solve proove the solution for my Shchool exercices
# ======================================================================
# 
# Input ==========================================
# agent: ['opt1 > opt2 > ... > optN', nº of agents]
proove = {
	1: ['c>b>a',1],
	2: ['b>c>a',1],
	3: ['a>c>b',1],
}

# 0: winner, 1: looser
OPCION = 0

# ================================================
# 
# 
# 
# 
# 
# 
# 
# Returns the array of the best weights
# t = 0: winner, 1: looser
# sep is always '>'
def condorcet(agents = proove):
	solution = {}

	for agent in agents.keys():
		options = agents[agent][0].strip().split('>')
		
		lo = len(options)
		for opt in range(lo):
			solution[options[opt]] = agents[agent][1] * (lo - opt - 1) if solution.get(options[opt]) == None else \
			  solution[options[opt]] + agents[agent][1] * (lo - opt- 1)
	max_w = dict(zip(solution.values(), solution.keys()))

	k = max_w.keys()
	
	# Maximum
	m = max(k)
	if len([i for i in k if k == m]) > 1:
		print('> There are more maximums')
	else:
		print("> The winner option is:",max_w[m])
	
	# Minimum
	m = min(k)
	if len([i for i in k if k == m]) > 1:
		print('There are more minimums')
	else:
		print("> The looser option is:",max_w[m])


print("="*20,"Condorcet","="*20)
condorcet()
print("="*51)