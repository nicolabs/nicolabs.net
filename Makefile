all: setup update build

setup:
	bundle install

update:
	bundle update

serve: update
	bundle exec jekyll serve --livereload -H '*' --drafts

build:
	rm -rf assets/uml docs/assets/uml
	bundle exec jekyll build

clean:
	bundle exec jekyll clean
	rm -rf assets/uml docs/assets/uml
