#!/bin/bash

# vaiables
tag=${1}

# build image(s)
semver=${tag} docker compose build
build_result=$?

# push image(s)
semver=${tag} docker compose push
push_result=$?

# pull/test
semver=${tag} docker compose pull
pull_result=$?

overall_result=$((${build_result} + ${push_result} + ${pull_result}))

echo "build result: ${build_result}"
echo "push result: ${push_result}"
echo "pull result: ${pull_result}"
echo "overall result: ${overall_result}"

# eof