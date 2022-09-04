source "https://rubygems.org"

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
gem "jekyll", "~> 4"

# This is the default theme for new Jekyll sites. You may change this to anything you like.
gem "minima", "~> 2.0"

# Dependency for jekyll-plantuml_hook
#gem "nokogiri"

# If you want to use GitHub Pageuse s, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :jekyll_plugins

# If you have any plugins, put them here!
group :jekyll_plugins do
  # Default plugins from github
  gem "jekyll-coffeescript"
  gem "jekyll-commonmark-ghpages"
  gem "jekyll-gist"
  gem "jekyll-github-metadata"
  #gem "jekyll-paginate"
  gem "jekyll-relative-links"
  gem "jekyll-optional-front-matter"
  gem "jekyll-readme-index"
  gem "jekyll-default-layout"
  gem "jekyll-titles-from-headings"
  # More plugins for this site
  # gem "nicolabs-feed-collection"
  gem "jekyll-feed"
  gem "jekyll-paginate-v2"
  gem "jekyll-redirect-from"
  gem "jekyll-sitemap"
  # Looks like the ideal solution but does not work
  #gem 'jekyll-plantuml_hook', git: 'https://github.com/chulkilee/jekyll-plantuml_hook.git', ref: 'master'
  # To remove <a /> from article previews - https://github.com/joshdavenport/jekyll-regex-replace
  gem "jekyll-regex-replace"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.0", :install_if => Gem.win_platform?

# https://stackoverflow.com/questions/65989040/bundle-exec-jekyll-serve-cannot-load-such-file
gem "webrick"
