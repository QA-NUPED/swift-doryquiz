RESULT_JSON="CodeCoverage.xcresult"
MIN_CODE_COVERAGE=60.0

if [ -f $RESULT_JSON ]; then
	rm $RESULT_JSON
fi

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