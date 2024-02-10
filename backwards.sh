#!/bin/bash

VERSIONS=( "$@" )

# reset test dir to HEAD
reset() {
    git checkout HEAD tests

}

# run current code against the tests for all previous versions
check_versions() {
    for i in "${VERSIONS[@]}"; do
        git checkout "$i" tests && elm-test
        TEST_RESULT=$?
        echo "TEST RESULT $TEST_RESULT"

        if [[ $TEST_RESULT -ne 0 ]]; then
            reset
            echo "failing tag $i"
            return 1;
        fi
    done

    echo "Passes tests for previous tags"
    reset
    return 0
}

check_versions
exit $?
