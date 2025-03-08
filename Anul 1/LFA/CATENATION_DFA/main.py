index_stare = 1

try:
    fin = open("dfa_1.in")
except FileNotFoundError:
    print("Nu exista fisierul.")

all_lines = fin.readlines()
nr_states_1 = int(all_lines[0].strip())
states_temp = all_lines[1].strip().split()
states_1_renumb = {}
for s in states_temp:
    if s not in states_1_renumb:
        states_1_renumb[s] = index_stare
        index_stare += 1

nr_letters_1 = int(all_lines[2].strip())
alphabet_1 = list(all_lines[3].strip().split())
initial_state_1 = states_1_renumb[all_lines[4].strip()]

nr_final_states_1 = int(all_lines[5].strip())
final_states_temp_1 = all_lines[6].strip().split()
final_states_1 = set()
for f in final_states_temp_1:
    final_states_1.add(states_1_renumb[f])

nr_transitions_1 = int(all_lines[7].strip())
transition_fc_1 = {}

for i in range(nr_transitions_1):
    transition = all_lines[8 + i].strip().split()
    state_before, letter, state_after = transition
    transition_fc_1[(states_1_renumb[state_before], letter)] = states_1_renumb[state_after]

fin.close()


try:
    fin = open("dfa_2.in")
except FileNotFoundError:
    print("Nu exista fisierul.")
all_lines = fin.readlines()
nr_states_2 = int(all_lines[0].strip())
states_temp = all_lines[1].strip().split()

states_2_renumb = {}
for s in states_temp:
    if s not in states_2_renumb:
        states_2_renumb[s] = index_stare
        index_stare += 1

nr_letters_2 = int(all_lines[2].strip())
alphabet_2 = list(all_lines[3].strip().split())
initial_state_2 = states_2_renumb[all_lines[4].strip()]

nr_final_states_2 = int(all_lines[5].strip())
final_states_temp_2 = all_lines[6].strip().split()
final_states_2 = set()
for f in final_states_temp_2:
    final_states_2.add(states_2_renumb[f])

nr_transitions_2 = int(all_lines[7].strip())
transition_fc_2 = {}

for i in range(nr_transitions_2):
    transition = all_lines[8 + i].strip().split()
    state_before, letter, state_after = transition
    transition_fc_2[(states_2_renumb[state_before], letter)] = states_2_renumb[state_after]

fin.close()


# print("Primul DFA:\n")
# print(f'{states_1_renumb} \n{alphabet_1} \n{initial_state_1} \n{final_states_1} \n{transition_fc_1}\n')
#
# print("\nAl doilea DFA:\n")
# print(f'{states_2_renumb} \n{alphabet_2} \n{initial_state_2} \n{final_states_2} \n{transition_fc_2}\n')

LNFA_states = list(states_1_renumb.values()) + list(states_2_renumb.values())
LNFA_alphabet = sorted(list(set(alphabet_1 + alphabet_2)))

l_moves = {}
for f in final_states_1:
    print("d")
    if (f, '.') not in l_moves:
        l_moves[(f, '.')] = initial_state_2

LNFA_transitions = {}
LNFA_transitions.update(transition_fc_1)
LNFA_transitions.update(transition_fc_2)
LNFA_transitions.update(l_moves)

# print(f'Automatul concatenare: \n{LNFA_states}\n{LNFA_alphabet}\n{initial_state_1}\n{final_states_2}\n{LNFA_transitions}')

L_closures = {}
for state in LNFA_states:
    if state not in final_states_1:
        L_closures[state] = {state}
    else:
        L_closures[state] = {state, initial_state_2}

print(L_closures)

state_table = [[set() for col in range(len(LNFA_alphabet))] for lin in range(len(LNFA_states))]

# LNFA to DFA TRANSFORMATION, STEP 1 - find NFA transition table

for q in range(len(LNFA_states)):
    for sym in range(len(LNFA_alphabet)):
        # set of states reached after applying <q>, sym, <q>
        rez = set()
        # set of states representing <q>, the lambda-closure of state q
        temp_states_1 = L_closures[LNFA_states[q]]
        # the set of states reached from q after applying
        # the lambda-closure of q and the symbol sym
        temp_states_2 = set()

        for s in temp_states_1:
            if (s, LNFA_alphabet[sym]) in LNFA_transitions:
                temp_states_2.add(LNFA_transitions[(s, LNFA_alphabet[sym])])

        for s in temp_states_2:
            s_closure = L_closures[LNFA_states[s - 1]]
            rez.update(s_closure)
        state_table[q][sym] = rez


# LNFA to DFA TRANSFORMATION, STEP 2 (find the DFA states and the transition table)

DFA_initial_state = L_closures[initial_state_1]
DFA_alphabet = list(LNFA_alphabet)
DFA_states = [DFA_initial_state]
DFA_transition_function = {}
DFA_final_states = set()

subsets_neprelucrate = [DFA_initial_state]

while len(subsets_neprelucrate) > 0:
    crt_subset = subsets_neprelucrate[0]
    for letter in range(len(DFA_alphabet)):
        subset = set()
        for q in crt_subset:
            subset_in_table = state_table[q - 1][letter]
            subset.update(subset_in_table)
        if len(subset) > 0:
            if subset not in DFA_states:
                DFA_states.append(subset)
                subsets_neprelucrate.append(subset)
            DFA_transition_function[(tuple(crt_subset), DFA_alphabet[letter])] = subset
    x = subsets_neprelucrate.pop(0)

for subset in DFA_states:
    is_final = None
    for state in subset:
        if len(L_closures[state] & final_states_2) > 0:
            is_final = True
            break
    if is_final is True:
        DFA_final_states.add(tuple(subset))

RENUM_DFA_states = {}  # a dictionary with the renumbering of the subsets which represent the states of the DFA
index_stare = 1
for s in DFA_states:
    if tuple(s) not in RENUM_DFA_states:
        RENUM_DFA_states[tuple(s)] = index_stare
        index_stare += 1

RENUM_DFA_initial_state = RENUM_DFA_states[tuple(DFA_initial_state)]

RENUM_DFA_final_states = [RENUM_DFA_states[tuple(subset)] for subset in DFA_final_states]

RENUM_DFA_transitions = {(RENUM_DFA_states[k[0]], k[1]): RENUM_DFA_states[tuple(v)]
                         for (k, v) in zip(DFA_transition_function.keys(), DFA_transition_function.values())}

output = open("concat.out", "w")

output.write(str(len(DFA_states)) + "\n" + " ".join([str(stare) for stare in list(RENUM_DFA_states.values())]) + "\n")
output.write(str(len(DFA_alphabet)) + "\n" + " ".join(DFA_alphabet) + "\n")
output.write(str(RENUM_DFA_initial_state) + '\n' + str(len(RENUM_DFA_final_states)) + '\n' +
             " ".join([str(stare) for stare in RENUM_DFA_final_states]) + "\n")
output.write(str(len(RENUM_DFA_transitions)) + '\n')

for tr in RENUM_DFA_transitions:
    output.write(f'{str(tr[0])} {tr[1]} {str(RENUM_DFA_transitions[tr])}\n')

output.close()
