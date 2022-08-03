#!/bin/bash -x

main(){
    gh_token=${INPUT_GH_TOKEN}
    repository=${INPUT_REPOSITORY}
    git_username=${INPUT_GIT_USERNAME}
    git_user_email=${INPUT_GIT_USER_EMAIL}

    git config --global user.name ${git_username}
    git config --global user.email ${git_user_email}

    git clone "https://${gh_token}@github.com/${repository}.git" "application"

    cd application

    commit_message=$(git log --format=%b | head -n 1 | tr '[A-Z]' '[a-z]')
    latest_tag=$(git describe --abbrev=0 --tags)

    latest_tag=${latest_tag#"v"}
    latest_tag=${latest_tag#"hotfix-"}

    echo $latest_tag

    case $commit_message in
        *hotfix*)
            TAG=hotfix-$(pysemver bump major ${latest_tag})
            ;;
        *chore*)
            TAG=$(pysemver bump minor ${latest_tag})
            ;;
        *feat*)
            TAG=$(pysemver bump minor ${latest_tag})
            ;;
        *fix*)
            TAG=$(pysemver bump patch ${latest_tag})
            ;;
        *)

        echo "[+] commit needs to follow the always (major, minor, patch and hotfix) in the merge commit message."
        exit 1
        ;;
    esac

    git tag -a ${TAG} -m "Automatic tag by autotag github action - ${TAG}"
    git push --follow-tags
}

main $@
