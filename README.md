# Percy::Capybara::Bedrock

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Releasing](#releasing)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Releasing

```sh-session
$ gem install github_changelog_generator
$ gem install gem-release

$ git checkout master

$ github_changelog_generator && npx doctoc README.md
$ git add CHANGELOG.md README.md
$ git commit -m "github_changelog_generator && npx doctoc README.md"

$ gem bump --version patch --push --sign --tag --release --pretend
```
