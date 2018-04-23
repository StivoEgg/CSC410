import os
import sys

if len(sys.argv) < 1:
    sys.exit("Usage: %s <input file>" % sys.argv[0])

inputFile = open(sys.argv[1], 'r')
formulaFilename = "groupingb-formula.smt2"
formulaFile = open(formulaFilename, "w")

def newline(f):
    f.write("\n")

lines = inputFile.readlines()
preferences = []

for line in lines:
    preferences.append([int(d) for d in line.strip()])

total = len(preferences)
summation = sum(range(total+1))

# declare int
for i in range(1, total+1):
    formulaFile.write("(declare-const x%i Int)\n" % i)

# declare array and preference function
formulaFile.write("(declare-const a1 (Array Int Int))\n")
formulaFile.write("(define-fun equal ((x Int) (y Int)) Int (ite (= x y) 1 0))\n")

newline(formulaFile)


formulaFile.write("(assert (and %s))\n" % (
    " ".join(["(> x%i 0)" % i for i in range(1,total + 1)])))
    
formulaFile.write("(assert (and %s))\n" % (
    " ".join(["(<= x%i %i)" % (i, total) for i in range(1, total + 1)])))

allVar = " ".join(["x%i" % i for i in range(1,total + 1)])

formulaFile.write("(assert (distinct %s))\n" % allVar)
formulaFile.write("(assert (= (+ %s) %i))\n" % (allVar, summation))

newline(formulaFile)

formulaFile.write(
    ";; prefence\n(maximize (+ %s))\n" % (
        " ".join(
            ["(equal x%i %i)" % (i, j) for i in range(1, total + 1) for j in preferences[i-1]]
        )
    )
)

formulaFile.write(
    ";; as many pair as possible\n(minimize (+ %s))\n" % (
        " ".join(
            ["(equal x%i %i)" % (i, i) for i in range(1, total + 1)]
        )
    )
)

newline(formulaFile)

for i in range(1, total + 1):
    formulaFile.write(
        "(assert (= (select a1 %i) x%i))\n" % (i, i)
    )

for i in range(1, total + 1):
    formulaFile.write(
        "(assert (= %i (select a1 (select a1 %i))))\n" % (i, i)
    )

formulaFile.write("(check-sat)\n(get-model)")
formulaFile.close()

solutionFilename = "groupingb_solution.txt"

if os.path.isfile("/u/csc410h/fall/pub/z3/bin/z3"):
    os.system("/u/csc410h/fall/pub/z3/bin/z3 %s > %s" % (formulaFilename, solutionFilename))
else:
    os.system("z3 %s > %s" % (formulaFilename, solutionFilename))

solutionFile = open(solutionFilename, "r")

line = solutionFile.readline
