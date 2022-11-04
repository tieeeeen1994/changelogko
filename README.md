# Changelogko

This gem provides the ability to easily manage your change logs. Commit changes alongside change log files to easily track them without worry, then just release them whenever to automatically create a new CHANGELOG.md file.

As an additional feature, *Releaseko is integrated into the gem as it feels like Releaseko is very coupled with Changelogko.* It is also just a simple feature that just automatically updates `metadata/app-version`, releases change logs through Changelogko, then push.

## Installation

Use `bundler` to install the gem.
```ruby
gem 'changelogko', git: 'https://github.com/tieeeeen1994/changelogko'
```

Then:
```
$ bundle install
```

## Usage

### Changelogko 

Refer to:
```
$ bundle exec changelogko -h
```

Changelogko will create the needed files if they don't exist yet.

### Releaseko

Refer to:
```
$ bundle exec releaseko -h
```

Releaseko looks for `metadata/app-version` for the project's versioning. It will automatically increment this file based on mode.

## Credits

The original author of this gem is [@neume](https://github.com/neume), then further enhanced by [@tieeeeen1994](https://github.com/tieeeeen1994).