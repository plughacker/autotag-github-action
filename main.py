#!/usr/bin/env python

import os
import semver
import shutil
import sys

from git import Repo

repository = os.getenv("INPUT_REPOSITORY")
github_token = os.getenv("INPUT_GITHUB_TOKEN")

def clean_repo():
    shutil.rmtree("../application")

def main():
    Repo.clone_from(f"https://{github_token}@github.com/{repository}.git", "application")
    os.chdir("application")

    commit_message= os.popen("git log --format=%b | head -n 1 | tr '[A-Z]' '[a-z]'").read()
    latest_tag=os.popen("git tag --list | sort -r | head -n 1").read().removeprefix("v")
    
    if latest_tag == "":
        latest_tag = "0.0.0"

    bump_version = ""

    if 'hotfix' in commit_message.lower():
        bump_version = f"hotfix-{latest_tag}"
    
    elif 'major' in commit_message.lower():
        bump_version = semver.bump_major(latest_tag)

    elif 'minor' in commit_message.lower():
        bump_version = semver.bump_minor(latest_tag)

    elif 'patch' in commit_message.lower():
        bump_version = semver.bump_patch(latest_tag)

    if bump_version == "":
        print("commit needs to follow the always (major, minor, patch and hotfix) in the merge commit message.")
        sys.exit(1)

    print(f"Bump version: {bump_version}")

    repo = Repo("")

    new_tag = repo.create_tag(f"{bump_version}")
    repo.remotes.origin.push(new_tag)

if __name__=='__main__':
    main()
    clean_repo()
