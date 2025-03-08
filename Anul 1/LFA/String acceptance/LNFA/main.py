import queue

try:
    fin = open("input.txt")
except FileNotFoundError:
    print("Nu exista fisierul.")

all_lines = fin.readlines()

numStates = int(all_lines[0].strip())
allStates = all_lines[1].strip().split()
numLetters = int(all_lines[2].strip())
alphabet = tuple(all_lines[3].strip().split())
initialState = all_lines[4].strip()
numFinalStates = int(all_lines[5].strip())
allFinStates = set(all_lines[6].strip().split())
numTransitions = int(all_lines[7].strip())

deltaFc = {}
lambdaMoves = {}

for i in range(numTransitions):
    one_transition = all_lines[8 + i].strip().split()
    stateBefore = one_transition[0]
    letter = one_transition[1]
    stateAfter = one_transition[2]
    if letter == '.':  # a lambda-transition
        if stateBefore not in lambdaMoves:
            lambdaMoves[stateBefore] = set()
        lambdaMoves[stateBefore].add(stateAfter)
    else:
        if (stateBefore, letter) not in deltaFc:
            deltaFc[(stateBefore, letter)] = set()  # initialize with empty set
        deltaFc[(stateBefore, letter)].add(stateAfter)

numb_of_words = int(all_lines[8 + numTransitions].strip())

allWords = []
for i in range(numb_of_words):
    word = all_lines[numTransitions + 9 + i].strip()
    allWords.append(word)

fin.close()

# find lambda closure of each state

lambdaClosures = {}
for currentState in allStates:
    lambdaClosures[currentState] = {currentState}
    if currentState in lambdaMoves:  # at least one lambda-transition from the current state to another one
        candidateStates = lambdaMoves[currentState]
        lambdaClosures[currentState].update(candidateStates)

        while len(candidateStates) > 0:
            candidateStatesList = list(candidateStates)
            dim = len(candidateStatesList)
            times = 0
            while times < dim:
                if candidateStatesList[0] in lambdaMoves:  # at least one lambda-transition leaving from this state
                    nextStates = lambdaMoves[candidateStatesList[0]]
                    for st in nextStates:
                        if st not in lambdaClosures[currentState]:
                            candidateStatesList.append(st)
                    lambdaClosures[currentState].update(nextStates)
                x = candidateStatesList.pop(0)
                times += 1
            candidateStates = set(candidateStatesList)
    print(lambdaClosures[currentState])

out = open("output.txt", 'w')

for word in allWords:
    print(word)
    visited = set()
    configurationSequence = queue.Queue()
    statesAfterProcessing = set()
    visited.add((initialState, word))
    configurationSequence.put((initialState, word))
    while not configurationSequence.empty():
        (currentState, subWord) = configurationSequence.get()

        print(currentState, subWord)
        # print(currentState, subWord)
        if subWord == "":
            # after we finished processing the letters of the word, we find the lambda-closure of the final state
            # and add those states to the result
            statesAfterProcessing.update(lambdaClosures[currentState])
        else:
            # firstly we process the lambda-closure of the current state

            possibleStates = lambdaClosures[currentState]

            # now, for each state in the lambda-closure, we process the first letter
            for S in possibleStates:
                if (S, subWord[0]) not in deltaFc:
                    continue
                else:
                    otherPossibleStates = deltaFc[(str(S), subWord[0])]
                    # print(possibleStates)
                    for state in otherPossibleStates:
                        if (state, subWord[1:]) not in visited:
                            visited.add((state, subWord[1:]))
                            configurationSequence.put((state, subWord[1:]))
    currentFinalStates = statesAfterProcessing & allFinStates

    # print(statesAfterProcessing)
    if len(currentFinalStates) > 0:  # at least one final states resulted after the processing of the word
        out.write("DA\n")
    else:
        out.write("NU\n")

out.close()
