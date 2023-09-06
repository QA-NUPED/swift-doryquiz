#!/bin/bash
SCHEME="IndexedDataStore"
RESULT_BUNDLE="CodeCoverage.xcresult"
RESULT_JSON="CodeCoverage.json"
MIN_CODE_COVERAGE=60.0

# Pre-clean
if [ -d $RESULT_BUNDLE ]; then
	rm -rf $RESULT_BUNDLE
fi
if [ -f $RESULT_JSON ]; then
	rm $RESULT_JSON
fi
# Build
set -o pipefail && env NSUnbufferedIO=YES xcodebuild build-for-testing -project "doryQuiz/doryQuiz.xcodeproj" -scheme "doryQuizTests" -destination "platform=iOS Simulator,OS=latest,name=iPhone 14" -enableCodeCoverage YES | xcpretty
# Test
set -o pipefail && env NSUnbufferedIO=YES xcodebuild test-without-building -project "doryQuiz/doryQuiz.xcodeproj" -scheme "doryQuizTests" -destination "platform=iOS Simulator,OS=latest,name=iPhone 14" -enableCodeCoverage YES -resultBundlePath $RESULT_BUNDLE | xcpretty
#Report
# set -o pipefail && env NSUnbufferedIO=YES xcodebuild -project "doryQuiz/doryQuiz.xcodeproj" -scheme "doryQuizTests" build "COMPILER_INDEX_STORE_ENABLE=NO" test -destination "id=B6C47C9F-927E-4B99-B86A-D8DE5A8B84E1" -resultBundlePath "/var/folders/6q/wgy6jtp12w5gzgm9lzcglpqw0000gn/T/XCUITestOutput001844682/Test.xcresult" "GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES" "GCC_GENERATE_TEST_COVERAGE_FILES=YES" | xcpretty "--color" "--report" "html" "--output" "swift-doryquiz/CodeCoverage.xcresult/Info.plist"
# Converter o formato de cobertura gerado pelo Xcode para o formato LCOV
# xcrun llvm-cov export -format="lcov" -instr-profile "doryQuiz/doryQuiz.xcodeproj/CodeCoverage.xcresult/doryQuizTests/doryQuiz.app" -o "CodeCoverage.xcresult/coverage.lcov"
plconvert -gcov Info.plist
gcovr -r ./CodeCoverage.xcresult -g -k -o output.lcov

set -o pipefail && env NSUnbufferedIO=YES xcrun xccov view --report --json $RESULT_BUNDLE > $RESULT_JSON

#Filtrando para que a variavel code coverage apenas contenha a cobertura total
CODE_COVERAGE=$(cat $RESULT_JSON | jq -r '.targets[] | select( .executableLines > 0 ) | .lineCoverage' | sed -n '1p')

# Multiplicando por cem para que o valor seja uma porcentagem
CODE_COVERAGE=$(echo $CODE_COVERAGE*100.0 | bc)

# Verificando se a porcentagem obtida está de acordo com o esperado
COVERAGE_PASSES=$(echo "$CODE_COVERAGE > $MIN_CODE_COVERAGE" | bc)
if [ $COVERAGE_PASSES -ne 1 ]; then
	printf "\033[0;31mCode coverage %.1f%% is less than required %.1f%%\033[0m\n" $CODE_COVERAGE $MIN_CODE_COVERAGE
	exit -1
else
	printf "\033[0;32mCode coverage is %.1f%%\033[0m\n" $CODE_COVERAGE
fi
