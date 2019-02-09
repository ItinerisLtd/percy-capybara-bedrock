# percy-capybara-bedrock

[![Build Status](https://travis-ci.com/ItinerisLtd/percy-capybara-bedrock.svg?branch=master)](https://travis-ci.com/ItinerisLtd/percy-capybara-bedrock)
[![Gem Version](https://img.shields.io/gem/v/percy-capybara-bedrock.svg?style=flat)](https://rubygems.org/gems/percy-capybara-bedrock)
[![Gem Download](https://img.shields.io/gem/dt/percy-capybara-bedrock.svg?style=flat)](https://rubygems.org/gems/percy-capybara-bedrock)
[![License](https://img.shields.io/github/license/itinerisltd/percy-capybara-bedrock.svg?style=flat)](https://github.com/ItinerisLtd/percy-capybara-bedrock/blob/master/LICENSE.txt)
[![Hire Itineris](https://img.shields.io/badge/Hire-Itineris-ff69b4.svg)](https://www.itineris.co.uk/contact/)


<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Installation](#installation)
- [Releasing](#releasing)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Goal

The official [Percy Anywhere](https://docs.percy.io/docs/percy-anywhere) uploads all static files (resources) under [`assets_dir`](https://github.com/percy/percy-capybara/blob/5865d54b81eac27ffc74c839eef7425a361d6f89/lib/percy/capybara/loaders/filesystem_loader.rb). This breaks when taking snapshots on a Bedrock project because of the resource limit (15,000 files).

`percy-capybara-bedrock` fixes the issue by defining [a custom loader](./lib/percy/bedrock/loader.rb) which:
- looks for static files under certain directories only
- excludes certain directories, e.g: `.git`, `vendor` and `node_modules`
- excludes certain file extensions, e.g: `.php` and `.sql`

## Minimum Requirements

- [Percy](https://percy.io/) account
- Ruby 2.6.1
- [PhantomJS](https://github.com/teampoltergeist/poltergeist#installing-phantomjs)
- [Bedrock v1.12.0](https://github.com/roots/bedrock)
- (Optional) [Sage v9.0.0](https://github.com/roots/sage/)

## Installation

```sh-session
$ bundle add percy-capybara-bedrock
```

Under the hood, `percy-capybara-bedrock` uses [Poltergeist](https://github.com/teampoltergeist/poltergeist) (a driver for [Capybara](https://github.com/teamcapybara/capybara)) which requires PhantomJS. Follow the instructions at: https://github.com/teampoltergeist/poltergeist#installing-phantomjs

## Usage

Create a `percy.rb` file under bedrock project root:
```ruby
require "percy/capybara/bedrock/anywhere"

# URL pointing to the local or remote host
server = "http://localhost:8080"

# Absolute path to a web root directory
web_root = File.expand_path("../web/", __FILE__)

# Path where your webserver hosts the WordPress site
assets_base_url = "/"

Percy::Capybara::Bedrock::Anywhere.run(server, web_root, assets_base_url) do|page|
  # Basic
  page.visit("/")
  Percy::Capybara.snapshot(page, name:"/")

  # Allow Javascript execution to finish
  page.visit("/about-us/")
  sleep(1)
  Percy::Capybara.snapshot(page, name:"/about-us/")

  # Capybara DSL
  # More at: https://github.com/teamcapybara/capybara#the-dsl
  page.visit("/contact-us")
  fill_in("Name", with: "Tang Rufus")
  fill_in("Message", with: "Testing contact form submission")
  click_button('Send')
  sleep(1) # Wait for thank you page to show up
  Percy::Capybara.snapshot(page, name:"/contact-us/thank-you/")
end
```

Given that your WordPress site is running at http://localhost:8080, take percy snapshots:
```sh-session
$ PERCY_TOKEN=my-secret-token PERCY_BRANCH=local PERCY_DEBUG=1 bundle exec ruby percy.rb
```

## FAQ

### Does it support Sage?

Yes, run `$ yarn build:production` before snapshot.

### Is it a must to use Sage?

No, Sage is optional.

### It looks awesome. Where can I find some more goodies like this?

- Articles on [Itineris' blog](https://www.itineris.co.uk/blog/)
- More projects on [Itineris' GitHub profile](https://github.com/itinerisltd)
- More plugins on [Itineris' wp.org profile](https://profiles.wordpress.org/itinerisltd/#content-plugins)
- Follow [@itineris_ltd](https://twitter.com/itineris_ltd) and [@TangRufus](https://twitter.com/tangrufus) on Twitter
- Hire [Itineris](https://www.itineris.co.uk/services/) to build your next awesome site

### This isn't on wp.org. Where can I give a ⭐️⭐️⭐️⭐️⭐️ review?

Thanks! Glad you like it. It's important to let my boss knows somebody is using this project. Instead of giving reviews on wp.org, consider:

- tweet something good with mentioning [@itineris_ltd](https://twitter.com/itineris_ltd) and [@TangRufus](https://twitter.com/tangrufus)
- star this [Github repo](https://github.com/ItinerisLtd/percy-capybara-bedrock)
- watch this [Github repo](https://github.com/ItinerisLtd/percy-capybara-bedrock)
- write blog posts
- submit pull requests
- [hire Itineris](https://www.itineris.co.uk/services/)

## Feedback

**Please provide feedback!** We want to make this library useful in as many projects as possible.
Please submit an [issue](https://github.com/ItinerisLtd/percy-capybara-bedrock/issues/new) and point out what you do and don't like, or fork the project and make suggestions.
**No issue is too small.**

## Security

If you discover any security related issues, please email [hello@itineris.co.uk](mailto:hello@itineris.co.uk) instead of using the issue tracker.

## Change log

Please see [CHANGELOG](./CHANGELOG.md) for more information on what has changed recently.

## Credits

[percy-capybara-bedrock](https://github.com/ItinerisLtd/percy-capybara-bedrock) is a [Itineris Limited](https://www.itineris.co.uk/) project created by [Tang Rufus](https://typist.tech).

Full list of contributors can be found [here](https://github.com/ItinerisLtd/percy-capybara-bedrock/graphs/contributors).

## License

[percy-capybara-bedrock](https://github.com/ItinerisLtd/percy-capybara-bedrock) is released under the [MIT License](https://opensource.org/licenses/MIT).

## Releasing

*For maintainers only*

```sh-session
$ gem install github_changelog_generator
$ gem install gem-release

$ git checkout -b version-bump

$ gem bump --sign --tag --release --version patch --pretend
  git push --tags && \
  github_changelog_generator && \
  npx doctoc README.md && \
  git add CHANGELOG.md README.md && \
  git commit -m "github_changelog_generator && npx doctoc README.md" && \
  git push origin version-bump && \
  hub pull-request
```
