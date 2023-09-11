#!/bin/bash
pr_number=1
github_token="teste1234"
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
# #Report
set -o pipefail && env NSUnbufferedIO=YES xcrun xccov view --report --json $RESULT_BUNDLE > $RESULT_JSON

#Filtrando para que a variavel code coverage apenas contenha a cobertura total
CODE_COVERAGE=$(cat $RESULT_JSON | jq -r '.targets[] | select( .executableLines > 0 ) | .lineCoverage' | sed -n '1p')

# Multiplicando por cem para que o valor seja uma porcentagem
CODE_COVERAGE=$(echo $CODE_COVERAGE*100.0 | bc)

# Verificando se a porcentagem obtida está de acordo com o esperado
COVERAGE_PASSES=$(echo "$CODE_COVERAGE > $MIN_CODE_COVERAGE" | bc)
if [ $COVERAGE_PASSES -ne 1 ]; then
	printf "\033[0;31mCode coverage %.1f%% is less than required %.1f%%\033[0m\n" $CODE_COVERAGE $MIN_CODE_COVERAGE
else
	printf "\033[0;32mCode coverage is %.1f%%\033[0m\n" $CODE_COVERAGE
fi
        
	 md="| Feature Name | Line Coverage | Branch Coverage |\n|---|---|---|\n"
        
        schemes=$(echo "$RESULT_JSON" | jq -r 'keys[]' | sort)
        
        for scheme in $schemes; do
            error=$(echo "$RESULT_JSON" | jq -r ".\"$scheme\".error")
            
            if [ "$error" == "No coverage data found" ]; then
                line_coverage="0.0% (0/0)"
                branch_coverage="0.0% (0/0)"
            elif [ -n "$error" ]; then
                line_coverage="Error"
                branch_coverage="$error"
            else
                lines=$(echo "$RESULT_JSON" | jq -r ".\"$scheme\".lines")
                branches=$(echo "$RESULT_JSON" | jq -r ".\"$scheme\".branches")
                line_coverage=$(CODE_COVERAGE "$lines")
                branch_coverage=$(CODE_COVERAGE "$branches")
            fi
            
            md+="| $scheme | $line_coverage | $branch_coverage |\n"
			
        done
		echo -e "$md"
        
	# Comentário no PR
		comment_url="https://api.github.com/QA-NUPED/swift-doryquiz/$pr_number/comments"
		comment_text="**Relatório de Cobertura:**\n\n$md"

		curl -s -H "Authorization: token $github_token" \
			-H "Content-Type: application/json" \
			-X POST -d "{\"body\":\"$comment_text\"}" \
			"$comment_url"