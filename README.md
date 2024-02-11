# Elm Backwards Compatability Tester

Test your currently checked out code against the tests for any previous versions.
Use when publishing a new minor or patch version of your package to make sure you're not making a breaking change.

[![asciicast](https://asciinema.org/a/MNzYmtAoh4zqBrLDh8WyMSnJz.svg)](https://asciinema.org/a/MNzYmtAoh4zqBrLDh8WyMSnJz)

## Usage

Pass as many git tags, branches, or commit hashes as you'd like.
It will exit with code 0 if there were no failures, and a non-zero exit code with any failures.

```
$ ./backwards.sh v1.0.0 v1.1.0 v1.2.2 master 47138a3
checking tag: v1.0.0
checking tag: v1.1.0
checking tag: v1.2.2
checking tag: master
checking tag: 47138a3
Passes tests for all versions.
```

Check all previous tags matching some pattern, for example, `v1*`:

```
$ git tag --list 'v1*` | xargs ./backwards.sh
```

**WARNING**, this will discard any changes in your test dir!
Make sure to stash or commit those changes before running.

## Doesn't Elm Packages enforce Semver?

Yes and no.
It enforces that minor and patch versions will compile, but it can't do anything to make sure the logic of your functions have changed.

For example, if you expose this function `isEven`:

```elm
isEven : Int -> Bool
isEven n =
    modBy 2 n == 0
```

And then you change the type signature:

```elm
isEven : Int -> Maybe Bool
isEven n =
    Just (modBy 2 n == 0)
```

Elm packages' semver check will only allow you to publish that as a new major version.
However, there's nothing stopping you from making a breaking change if it preserves the function signature:

```elm
-- Returns True when n is actually odd!
isEven : Int -> Bool
isEven n =
    modBy 2 n == 1
```
