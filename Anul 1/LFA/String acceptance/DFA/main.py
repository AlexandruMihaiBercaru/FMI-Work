try:
    fin = open("input.txt")
except FileNotFoundError:
    print("Nu exista fisierul.")

all_lines = fin.readlines()

numStates = int(all_lines[0].strip())

allStates = all_lines[1].strip().split()
# print(list_of_states)

numLetters = int(all_lines[2].strip())

alphabet = tuple(all_lines[3].strip().split())
# print(alphabet)

initialState = all_lines[4].strip()

numFinalStates = int(all_lines[5].strip())
allFinStates = all_lines[6].strip().split()

numTransitions = int(all_lines[7].strip())

deltaFc = {}
# transition fc

for i in range(numTransitions):
    one_transition = all_lines[8 + i].strip().split()
    # one_transition[0] - the state before the transition;
    # one_transition[1] - letter;
    # one_transition[2] - the state after the transition.
    if (one_transition[0], one_transition[1]) not in deltaFc:
        deltaFc[(one_transition[0], one_transition[1])] = []
    deltaFc[(one_transition[0], one_transition[1])].append(one_transition[2])

numb_of_words = int(all_lines[8 + numTransitions].strip())

allWords = []
for i in range(numb_of_words):
    word = all_lines[numTransitions + 9 + i].strip()
    allWords.append(word)

fin.close()


def deltaTildaFc(delta, state, word_to_parse):
    if len(word_to_parse) == 1:  # only one letter left for processing
        try:
            return delta[(state, word_to_parse)][0]
        except KeyError:
            return '-1'
    else:
        try:
            return deltaTildaFc(delta, delta[(state, word_to_parse[0])][0], word_to_parse[1:])
        except KeyError:
            return '-1'


fout = open("output.txt", 'w')

for word in allWords:
    result = deltaTildaFc(deltaFc, initialState, word)
    if result in allFinStates:
        fout.write("DA\n")
    else:
        fout.write("NU\n")


fout.close()






