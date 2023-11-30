#set -e
CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
TPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar org.junit.runner.JUnitCore'
GRADE='./grading-area/'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

# https://github.com/ucsd-cse15l-w23/lab3.git

files=`find student-submission`
check=false

# Find ListExample.java
for file in $files
do 
    if [[ $file == "student-submission/ListExamples.java" ]]
    then
        # echo $file
        echo "ListExamples.java found"
        filename=$file
        check=true
    fi
done

# If the file is not found, exit
if [[ $check == false ]]
then
    echo $check
    exit 1
else
    echo "Found"
fi

# copy necessary files into grading-area
cp $filename $GRADE
cp ./TestListExamples.java $GRADE
cp -r ./lib $GRADE

# compile the java file
javac -cp $CPATH $GRADE*.java 2>./grading-area/compile.txt

cd grading-area
java -cp $TPATH TestListExamples >test.txt

# find the line of test result in test.txt
line=`grep "Tests run:" ./test.txt`

# compute the score
if [[ -z "$line" ]]
then
    SCORE=100;
else
    TOTAL=${line:11:1}
    FAILED=${line:25:1}
    PASSED=$(($TOTAL-$FAILED))
    SCORE=$(($(($PASSED))*100/$TOTAL))
fi

# print the test result
echo "
Total tests: $TOTAL:
Tests Failed: $FAILED;
Test Passed: $PASSED;
Your Score is: $SCORE"