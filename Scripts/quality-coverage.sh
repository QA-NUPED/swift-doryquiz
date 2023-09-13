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

# Report
set -o pipefail && env NSUnbufferedIO=YES xcrun xccov view --report --json $RESULT_BUNDLE > $RESULT_JSON

# Parse JSON report and create coverage summary
COVERAGE_SUMMARY=$(cat $RESULT_JSON | jq -r '
	.targets[] | 
    select(.executableLines > 0) | 
    {
		folder: .name,
    	lineCoverage: .lineCoverage
    }
')

COVERAGE_TABLE=$(echo "Folder|Line Coverage"
echo "------|-------------"

# Loop para formatar os dados em uma tabela
echo "$COVERAGE_SUMMARY" | while read -r line; do
    folder=$(echo "$line" | jq -r '.folder')
    lineCoverage=$(echo "$line" | jq -r '.lineCoverage')
    printf "%-6s|%13s\n" "$folder" "$lineCoverage"
done)

# Comment on a random pull request
PR_NUMBER=$(gh pr list | awk '{print $1}' | sort -R | head -n 1)
PR_COMMENT="Coverage Percentage:\n$COVERAGE_TABLE"

gh pr comment $PR_NUMBER --body "$PR_COMMENT"

# Filtering code coverage
CODE_COVERAGE=$(echo "$COVERAGE_SUMMARY" | jq -s 'map(.lineCoverage) | add / length * 100')

# Check if code coverage meets the minimum requirement
COVERAGE_PASSES=$(echo "$CODE_COVERAGE >= $MIN_CODE_COVERAGE" | bc)

if [ $COVERAGE_PASSES -eq 1 ]; then
    printf "\033[0;32mCode coverage is %.1f%%\033[0m\n" $CODE_COVERAGE
else
    printf "\033[0;31mCode coverage %.1f%% is less than required %.1f%%\033[0m\n" $CODE_COVERAGE $MIN_CODE_COVERAGE
fi