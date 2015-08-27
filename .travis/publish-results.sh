#!/bin/bash

set | grep TRAVIS

if [ "$TRAVIS_REPO_SLUG" == "$GIT_PUB_REPO" ]; then
    echo -e "Setting up for publication...\n"

    VERSION=`grep version gradle.properties | cut -f2 -d=`
    ZIPBASE=docbook-xslt2-${VERSION}

    if [ "$TRAVIS_BRANCH" = "master" ]; then
        RELEASE=${VERSION}
    else
        RELEASE=${TRAVIS_BRANCH}
    fi

    mkdir -p $HOME/pages/{$RELEASE}
    cp -R build/distributions/* $HOME/pages/{$RELEASE}/

    cd $HOME
    git config --global user.email ${GIT_EMAIL}
    git config --global user.name ${GIT_NAME}
    git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/${GIT_PUB_REPO} gh-pages > /dev/null

    if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
        echo -e "Publishing results...\n"

        cd gh-pages
        git rm -rf ./pages/${RELEASE}
        mkdir -p ./pages/${RELEASE}
        cp -Rf $HOME/pages/* ./pages/

        git add -f .
        git commit -m "Successful travis build $TRAVIS_BUILD_NUMBER"
        git push -fq origin gh-pages > /dev/null

        echo -e "Published results to gh-pages.\n"
    else
        echo -e "Publication cannot be performed on pull requests.\n"
    fi
fi
