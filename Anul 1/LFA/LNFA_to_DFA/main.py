
# parse LNFA from file

import queue

try:
    fin = open("input.txt")
except FileNotFoundError:
    print("Nu exista fisierul.")

all_lines = fin.readlines()

nr_states = int(all_lines[0].strip())
all_states = all_lines[1].strip().split()

nr_letters = int(all_lines[2].strip())
alphabet = tuple(all_lines[3].strip().split())

initial_state = all_lines[4].strip()
nr_final_states = int(all_lines[5].strip())
final_states = set(all_lines[6].strip().split())
nr_transitions = int(all_lines[7].strip())

transition_fc = {}  # contains all transition functions
l_moves = {}

for i in range(nr_transitions):
    one_transition = all_lines[8 + i].strip().split()
    state_before = one_transition[0]
    letter = one_transition[1]
    state_after = one_transition[2]
    if letter == '.':  # a lambda-transition
        if state_before not in l_moves:
            l_moves[state_before] = set()
        l_moves[state_before].add(state_after)
    else:
        if (state_before, letter) not in transition_fc:
            transition_fc[(state_before, letter)] = set()  # initialize with empty set
        transition_fc[(state_before, letter)].add(state_after)

nr_words = int(all_lines[8 + nr_transitions].strip())

all_words = []
for i in range(nr_words):
    word = all_lines[nr_transitions + 9 + i].strip()
    all_words.append(word)

fin.close()


lambdaClosures = {}
for currentState in all_states:
    lambdaClosures[currentState] = {currentState}
    if currentState in l_moves:  # at least one lambda-transition from the current state to another one
        candidateStates = l_moves[currentState]
        lambdaClosures[currentState].update(candidateStates)

        while len(candidateStates) > 0:
            candidateStatesList = list(candidateStates)
            dim = len(candidateStatesList)
            times = 0
            while times < dim:
                if candidateStatesList[0] in l_moves:  # at least one lambda-transition leaving from this state
                    nextStates = l_moves[candidateStatesList[0]]
                    for st in nextStates:
                        if st not in lambdaClosures[currentState]:
                            candidateStatesList.append(st)
                    lambdaClosures[currentState].update(nextStates)
                x = candidateStatesList.pop(0)
                times += 1
            candidateStates = set(candidateStatesList)
    print(lambdaClosures[currentState])
