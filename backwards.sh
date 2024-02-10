#!/bin/bash

VERSIONS=( "$@" )

# reset test dir to HEAD
reset() {
    git checkout HEAD tests >/dev/null 2>&1
}

# run current code against the tests for all versions passed as arguments.
# stops at first version that fails.
check_versions() {
    for i in "${VERSIONS[@]}"; do
        echo "checking tag: $i";
        git checkout "$i" tests > /dev/null 2>&1 && OUTPUT=$(elm-test)
        TEST_RESULT=$?

        if [[ $TEST_RESULT -ne 0 ]]; then
            reset
            echo "$OUTPUT"
            echo "failing tag found: $i"
            return 1;
        fi
    done

    echo "Passes tests for all versions."
    reset
    return 0
}

check_versions
exit $?
