# Percy::Capybara::Bedrock

[![Build Status](https://travis-ci.com/ItinerisLtd/percy-capybara-bedrock.svg?branch=master)](https://travis-ci.com/ItinerisLtd/percy-capybara-bedrock)
[![Gem Version](https://img.shields.io/gem/v/percy-capybara-bedrock.svg?style=flat)](https://rubygems.org/gems/percy-capybara-bedrock)
[![Gem Download](https://img.shields.io/gem/dt/percy-capybara-bedrock.svg?style=flat)](https://rubygems.org/gems/percy-capybara-bedrock)
[![License](https://img.shields.io/github/license/itinerisltd/percy-capybara-bedrock.svg?style=flat)](https://github.com/ItinerisLtd/percy-capybara-bedrock/blob/master/LICENSE.txt)
[![Hire Itineris](https://img.shields.io/badge/Hire-Itineris-ff69b4.svg)](https://www.itineris.co.uk/contact/)


<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Releasing](#releasing)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Installation

Add this line to your application's `Gemfile` or `gem.rb`:

```ruby
gem 'percy-capybara-bedrock'
```

And then execute:

```sh-session
$ bundle
```

Or install it yourself as:

```sh-session
$ gem install percy-capybara-bedrock
```

## Releasing

```sh-session
$ gem install github_changelog_generator
$ gem install gem-release

$ git checkout -b version-bump

$ gem bump --sign --tag --release --version patch --pretend

$ github_changelog_generator && \
  npx doctoc README.md && \
  git add CHANGELOG.md README.md && \
  git commit -m "github_changelog_generator && npx doctoc README.md"

$ git push -u origin Head && \
  hub pull-request
```
