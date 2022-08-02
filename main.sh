#!/bin/bash

main() {
    COMMIT_MESSAGE=$(git log --format=%B | head -n 1)

    case $COMMIT_MESSAGE in
        *"hotfix"*)
            echo "Hotfix"
        ;;
        *"minor"*)
            echo "Minor"
        ;;
        *"patch"*)
            echo "Patch"
        ;;
        esac
}

main $@
