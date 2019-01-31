# Seastar website

The is the source repo for the http://seastar.io/ website
The site is using [Hugo](https://gohugo.io/) and hosted as [GitHub Project Pages](https://gohugo.io/hosting-and-deployment/hosting-on-github/#github-project-pages)

### Run the site locally

1. clone the project

```
git clone https://github.com/scylladb/seastar-website 
cd seastar-website
```

(use your fork URL)

2. Run a local server

```
hugo server -D
```

Go to http://localhost:1313/ to see the results

### Update the site

Follow [Gitgub working flow](https://guides.github.com/introduction/flow/):
Use your Github login instead of `tzach` below.
Use a relevant branch name inseatd of `fix-memcache-link`

- run the site locally from your fork (see above)
- create a new branch: `git checkout -b fix-memcache-link` 
- update the files (see below)
- test locally `hugo server -D`
- add the updated files: `git add content/seastar-applications.md`
- commit the update with a proper message: `git commit -m "fix memcache link"`
- push to you fork: `git push origin fix-memcache-link`
- from Github UI create a PR
- Wait for a maintainer to merge and deploy


**Only update the MarkDown(.md) files. The `hugo` command generate the HTML under the `doc` directory.
Do not be tempted to update the generated HTML under doc, it will be override.**

### Deploy the site

Do this only if you are a  mainatner, and you tested the master branch locally

```
./deploy.sh
```
