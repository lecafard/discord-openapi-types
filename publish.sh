#!/bin/bash

get_version() {
	local api_version=`jq -r '.info.version' repo/specs/openapi.json`
	local npm_version=`npm view discord-openapi-types versions --json | jq -r '[.[]|select(startswith("'$api_version'"))][-1] // ""'`
	local version=$npm_version
	IFS='.' read -r major minor patch <<< "$version"
	if [[ $api_version = $major ]]; then
		((patch++))
	fi
	echo "$major.$minor.$patch"
}

version=`get_version`
out=`jq '.version="'$version'"' package.json`
echo "$out" > package.json
npm publish
