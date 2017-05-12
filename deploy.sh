#!/bin/bash

set -o errexit -o nounset

terraform apply

echo
echo "Setting git user name..."
git config user.name "$GH_USER_NAME"

echo "Setting git user email..."
git config user.email "$GH_USER_EMAIL"

echo
echo "Committing terraform state changes..."
git checkout master > /dev/null
git add . > /dev/null
git commit -m "tfstate: $(TZ=Europe/Amsterdam date) [skip ci]"

echo
echo "Pushing changes to upstream master..."
git push --quiet "https://$GH_USER_NAME:$GH_TOKEN@github.com/$GH_REPO.git" master
