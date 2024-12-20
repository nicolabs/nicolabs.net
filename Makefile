.PHONY: all
all: setup update build

.PHONY: setup
setup:
	sudo apt-get install ruby-full
	gem install bundler
	bundle install

.PHONY: install
install: setup

.PHONY: update
update:
	bundle update

.PHONY: serve
serve:
	sleep 5 && xdg-open http://localhost:4000 &
	# --future sinon les articles avec une date future sont ignorés : https://github.com/jekyll/jekyll/issues/7493
	bundle exec jekyll serve --livereload -H '*' --drafts --future

.PHONY: build
build:
	rm -rf assets/uml docs/assets/uml
	# --future sinon les articles avec une date future sont ignorés : https://github.com/jekyll/jekyll/issues/7493
	bundle exec jekyll build --future

clean:
	bundle exec jekyll clean
	rm -rf assets/uml docs/assets/uml
