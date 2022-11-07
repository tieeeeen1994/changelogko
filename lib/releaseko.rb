require 'English'
require 'fileutils'
require 'releaseko/custom_error'
require 'releaseko/app_version'
require 'releaseko/changelog_wrapper'
require 'releaseko/repository_updater'

begin
  case ARGV[0]
  when '-m', '--method'
    Releaseko::AppVersion.new(ARGV[1]).perform
    Releaseko::ChangelogWrapper.perform
    Releaseko::RepositoryUpdater.perform if Releaseko::RepositoryUpdater.set_to_push
    puts 'Release operation is a success!!!'
  when '-h', '--help'
    puts 'Usage: bin/release [options]'
    puts "\nOptions:"
    puts "\n  -m, --method [major, minor, build] [-p, --push]"
    puts '    Method of release so app version is updated accordingly.'
    puts '    Extra option -p, --push will automatically commit and push the release to working branch.'
    puts '    It will only push if the branch has a set upstream remote.'
    puts "\n  -h, --help"
    puts '    Display help. Duh.'
    puts "\nMethods:"
    puts '  major  Increments major version number'
    puts '  minor  Increments minor version number'
    puts '  build  Increments build version number'
  else
    puts 'Use --help (-h) option for usage details'
  end

  exit(0)
end
