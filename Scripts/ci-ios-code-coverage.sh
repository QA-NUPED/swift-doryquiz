#!/bin/sh
SCHEME="IndexedDataStore"
RESULT_BUNDLE="CodeCoverage.xcresult"
RESULT_JSON="CodeCoverage.json"
MIN_CODE_COVERAGE=50.0 # should really be higher =)

# Pre-clean
if [ -d $RESULT_BUNDLE ]; then
	rm -rf $RESULT_BUNDLE
fi
if [ -f $RESULT_JSON ]; then
	rm $RESULT_JSON
fi
# Build
set -o pipefail && env NSUnbufferedIO=YES xcodebuild build-for-testing -project "doryQuiz/doryQuiz.xcodeproj" -scheme "doryQuiz" -destination "platform=iOS Simulator,OS=latest,name=iPhone 14" -enableCodeCoverage YES | xcpretty --report html
# Test
set -o pipefail && env NSUnbufferedIO=YES xcodebuild test-without-building -project "doryQuiz/doryQuiz.xcodeproj" -scheme "doryQuiz" -destination "platform=iOS Simulator,OS=latest,name=iPhone 14" -enableCodeCoverage YES -resultBundlePath $RESULT_BUNDLE | xcpretty --report html

# Extraindo a cobertura da linha e editando para que seja um json file
set -o pipefail && env NSUnbufferedIO=YES xcrun xccov view --report --json $RESULT_BUNDLE > $RESULT_JSON
CODE_COVERAGE=$(cat $RESULT_JSON | jq '.targets[] | select( .name == "IndexedDataStore" and .executableLines > 0 ) | .lineCoverage')
CODE_COVERAGE=$(echo $CODE_COVERAGE*100.0 | bc)
