#!/bin/bash
hugo
git add docs/*
git commit docs/* -m fix;
git commit -a -m fix;
git push
git status
