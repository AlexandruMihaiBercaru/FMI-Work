import queue

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
allFinStates = set(all_lines[6].strip().split())

numTransitions = int(all_lines[7].strip())

deltaFc = {}
# transition fc

for i in range(numTransitions):
    one_transition = all_lines[8 + i].strip().split()
    # one_transition[0] - the state before the transition;
    # one_transition[1] - letter;
    # one_transition[2] - the state after the transition.
    if (one_transition[0], one_transition[1]) not in deltaFc:
        deltaFc[(one_transition[0], one_transition[1])] = set()  # initialize with empty set
    deltaFc[(one_transition[0], one_transition[1])].add(one_transition[2])

numb_of_words = int(all_lines[8 + numTransitions].strip())

allWords = []
for i in range(numb_of_words):
    word = all_lines[numTransitions + 9 + i].strip()
    allWords.append(word)

fin.close()

out = open("output.txt", 'w')

for word in allWords:
    configurationSequence = queue.Queue()
    statesAfterProcessing = set()
    configurationSequence.put((initialState, word))
    while not configurationSequence.empty():
        (currentState, subWord) = configurationSequence.get()
        # print(currentState, subWord)
        if subWord == "":
            statesAfterProcessing.add(currentState)
        else:
            if (currentState, subWord[0]) not in deltaFc:
                continue
            else:
                possibleStates = deltaFc[(str(currentState), subWord[0])]
                # print(possibleStates)
                for state in possibleStates:
                    configurationSequence.put((state, subWord[1:]))
    currentFinalStates = statesAfterProcessing & allFinStates
    # print(statesAfterProcessing)
    if len(currentFinalStates) > 0:  # at least one final states resulted after the processing of the word
        out.write("DA\n")
    else:
        out.write("NU\n")

out.close()
