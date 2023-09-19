#!/bin/bash
SCHEME="IndexedDataStore"
RESULT_BUNDLE="CodeCoverage.xcresult"
RESULT_JSON="CodeCoverage.json"
MIN_CODE_COVERAGE=40.0

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
# #Report
set -o pipefail && env NSUnbufferedIO=YES xcrun xccov view --report --json $RESULT_BUNDLE > $RESULT_JSON

#Filtrando para que a variavel code coverage apenas contenha a cobertura total
CODE_COVERAGE=$(cat $RESULT_JSON | jq -r '.targets[] | select( .executableLines > 0 ) | .lineCoverage' | sed -n '1p')

# Multiplicando por cem para que o valor seja uma porcentagem
CODE_COVERAGE_1=$(echo $CODE_COVERAGE*100.0 | bc)

CODE_COVERAGE_2=$(printf "%.2f" $CODE_COVERAGE_1)

TABLE_MD="## COVERAGE
| **Code coverage** | **Coverage required** |
|-------------------|---------------------------|
| $CODE_COVERAGE_2  % | $MIN_CODE_COVERAGE % |"

# Verificando se a porcentagem obtida está de acordo com o esperado
COVERAGE_PASSES=$(echo "$CODE_COVERAGE_1 > $MIN_CODE_COVERAGE" | bc)
if [ $COVERAGE_PASSES -ne 1 ]; then
	printf "\033[0;31mCode coverage %.1f%% is less than required %.1f%%\033[0m\n" $CODE_COVERAGE_1 $MIN_CODE_COVERAGE
	PR_NUMBER=$(gh pr list -L 1 | jq -r 'sort_by(.updated_at) | .[] | "PR #" + (.number | tostring) + ": " + .title + " (Atualizado em " + .updated_at + ")"')

	#PR_NUMBER=$(gh pr list --limit 1 --sort updated --json number | jq -r '.[0].number')
	PR_COMMENT="$TABLE_MD"
	gh pr comment $PR_NUMBER --body "$PR_COMMENT"
	exit -1
else
	printf "\033[0;32mCode coverage is %.1f%%\033[0m\n" $CODE_COVERAGE_1

    # Gerar relatório de pastas testadas e porcentagens
    REPORT=$(cat $RESULT_JSON | jq -r '.targets[] | select( .executableLines > 0 ) | "\(.name): \(.lineCoverage * 100) %"' | sort)
    echo -e "Folders Tested and Coverage Percentage:\n$REPORT"

fi

PR_NUMBER=$(gh pr list | awk '{print $1}' | sort -R | head -n 1)
#PR_NUMBER=$(gh pr list --limit 1 --sort updated --json number | jq -r '.[0].number')
PR_COMMENT="$TABLE_MD"
gh pr comment $PR_NUMBER --body "$PR_COMMENT"