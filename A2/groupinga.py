import os
import sys
import re

if len(sys.argv) < 1:
    sys.exit("Usage: %s <input file>" % sys.argv[0])

inputFile = open(sys.argv[1], "r")
formulaFilename = "groupinga-formula.smt2"
formulaFile = open(formulaFilename, "w")

def newline(f):
    f.write("\n")

lines = inputFile.readlines()
preferences = []

for line in lines:
    preferences.append([int(d) for d in line.strip().split(" ")])

total = len(preferences)

# Declare boolean
for i in range(1, total+1):
    formulaFile.write("(declare-const x%i Bool)\n" % i)
    for j in range(1, total+1):
        if i != j:
            formulaFile.write("(declare-const x%ix%i Bool)\n" % (i, j))
    
newline(formulaFile)

# Exclusive OR
for i in range(1, total+1):
    formulaFile.write("(assert (or ")
    pairs = []
    for j in range(1, total+1):
        if i != j:
            pairs.append("x%ix%i" % (i,j))
    for pair1 in pairs:
        formulaFile.write("(and ")
        for pair2 in pairs:
            if (pair1 != pair2):
                formulaFile.write("(not %s) " % pair2)    
        formulaFile.write("%s)" % pair1)
    
    formulaFile.write("(and ")
    for pair2 in pairs:
        formulaFile.write("(not %s) " % pair2)    
    formulaFile.write("x%i)" % i)
    formulaFile.write("))\n")


formulaFile.write("(assert (or")
for i in range(1, total+1):
    formulaFile.write(" (and")
    for j in range(1, total + 1):
        if i != j:
            formulaFile.write(" (not x%i)" % j)
        else:
            formulaFile.write(" x%i" % j)
    formulaFile.write(")")
formulaFile.write("))\n")
newline(formulaFile)

# Confirm matching
for i in range(1, total+1):
    for j in range(1, total+1):
        if i != j:
            formulaFile.write("(assert (not (xor x%ix%i x%ix%i)))\n" % (i, j, j ,i))

newline(formulaFile)

# Preferences
for i in range(len(preferences)):
    for pref in preferences[i]:
        formulaFile.write("(assert-soft x%ix%i)\n" % (i+1, pref))

formulaFile.write("(check-sat)\n(get-model)")
formulaFile.close()

solutionFilename = "groupinga_solution.txt"

if os.path.isfile("/u/csc410h/fall/pub/z3/bin/z3"):
    os.system("/u/csc410h/fall/pub/z3/bin/z3 %s > %s" % (formulaFilename, solutionFilename))
else:
    os.system("z3 %s > %s" % (formulaFilename, solutionFilename))

solutionFile = open(solutionFilename, "r")

outputFilename = "groupinga-output.txt"
outputFile = open(outputFilename, "w")

line = solutionFile.readline()
pattern = r'x(\d+)x(\d+)'
count = 0
outputLines = [""]
while line and count < total / 2:
    line = line.strip()
    result = re.search(pattern, line)
    if result:
        nextLine = solutionFile.readline().strip()
        if nextLine.startswith('true'):
            outputLines.append("%s,%s\n" % (result.group(1), result.group(2)))
            count += 1
    line = solutionFile.readline()

outputLines[0] = "%i groups formed:\n" % count

for line in outputLines:
    outputFile.write(line)

outputFile.close()

solutionFile.close()
os.remove(solutionFilename)