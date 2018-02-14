#!/bin/bash
hugo
git add docs/*
git commit condocs/* -m fix;
git commit content/blog/* -m fix;
git commit content/images/* -m fix;
git commit -a -m fix;
git push
git status
