all: install

install:
	bundle install

serve:
	bundle exec jekyll serve --livereload -H '*' --drafts

build:
	bundle exec jekyll build
