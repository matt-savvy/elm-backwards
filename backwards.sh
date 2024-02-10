#!/bin/bash

VERSIONS=( "$@" )

# reset test dir to HEAD
reset() {
    git checkout HEAD tests >/dev/null 2>&1
}

# run current code against the tests for all previous versions.
# stops at first version that fails.
check_versions() {
    for i in "${VERSIONS[@]}"; do
        echo "checking tag: $i";
        git checkout "$i" tests > /dev/null 2>&1 && elm-test >/dev/null 2>&1
        TEST_RESULT=$?

        if [[ $TEST_RESULT -ne 0 ]]; then
            reset
            echo "failing tag found: $i"
            return 1;
        fi
    done

    echo "Passes tests for previous tags"
    reset
    return 0
}

check_versions
exit $?
