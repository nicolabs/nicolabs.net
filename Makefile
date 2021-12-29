all: install

install:
	bundle install

update:
	bundle update

serve:
	bundle exec jekyll serve --livereload -H '*' --drafts

build:
	bundle exec jekyll build
