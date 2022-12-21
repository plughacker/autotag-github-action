#!/bin/bash -x

main(){
    gh_token=${INPUT_GH_TOKEN}
    repository=${INPUT_REPOSITORY}
    git_username=${INPUT_GIT_USERNAME}
    git_user_email=${INPUT_GIT_USER_EMAIL}
    git_branch_ref=${INPUT_GIT_BRANCH_REF}

    git config --global user.name ${git_username}
    git config --global user.email ${git_user_email}

    git clone -b  ${git_branch_ref} "https://${gh_token}@github.com/${repository}.git" "application"

    cd application

    commit_message=$(git log --format=%b | head -n 1 | tr '[A-Z]' '[a-z]')
    latest_tag=$(git describe --abbrev=0 --tags)

    latest_tag=${latest_tag#"v"}
    latest_tag=${latest_tag#"hotfix-"}

    echo $latest_tag

    if [ -z $latest_tag ];  then
	    latest_tag="0.0.0"
    fi

    case $commit_message in
        *breaking*)
            TAG=v$(pysemver bump major ${latest_tag})
            ;;
        *chore*)
            TAG=v$(pysemver bump minor ${latest_tag})
            ;;
        *feat*)
            TAG=v$(pysemver bump minor ${latest_tag})
            ;;
        *feat!*)
            TAG=v$(pysemver bump major ${latest_tag})
            ;;
        *fix*)
            TAG=v$(pysemver bump patch ${latest_tag})
            ;;
        *hotfix*)
            TAG=v$(pysemver bump patch ${latest_tag})-hotfix
            ;;
        *)
	        echo "[+] bump minor version"
	        TAG=v$(pysemver bump minor ${latest_tag})
	    ;;
    esac

    git tag -a ${TAG} -m "Automatic tag by autotag github action - ${TAG}"
    git push --follow-tags
}

main $@
