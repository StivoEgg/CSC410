
## Compile, and run tests
## Script should work for most Linux/OSX/MacOS systems

## compiling test cases
javac -d test test/1/Test.java ;

## compile the code. Your code should compile with this command exactly
mkdir -p class
if javac -cp soot.jar -d class src/*.java; then

	## run test cases
	if java -cp soot.jar:class csc410.hw3.RunDataFlowAnalysis Test > /dev/null; then
		echo "[>] Your Upward Exposed Uses:"; cat exposed-uses.txt; 
		echo "[*] Expected Upward Exposed Uses:"; cat test/1/expected-uses.txt;
	else
		echo "[!] Runtime Error";
	fi;
else
	echo "[!] Compilation Error";
fi;