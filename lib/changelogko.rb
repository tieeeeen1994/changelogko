# frozen_string_literal: true

require 'yaml'
require 'fileutils'
require 'optparse'

CHANGE_LOGS_PATH = './changelogs'
CHANGE_LOG_NAME = './CHANGELOG.md'
TEMP_CHANGE_LOG_NAME = './CHANGELOG.md.temp'
InvalidLogFile = Class.new(StandardError)
NoLogsFound = Class.new(StandardError)
ProcessEnded = Class.new(StandardError)

Type = Struct.new(:name, :description)

TYPES = [
  Type.new('added', "\t\tAdd something new like a new feature."),
  Type.new('changed', "\t\tAlter something that already exists."),
  Type.new('deprecated', "\tDepreciate an existing feature."),
  Type.new('enhanced', "\tImprove an existing feature."),
  Type.new('fixed', "\t\tFix a bug."),
  Type.new('optimized', "\tRender a feature efficient and effective."),
  Type.new('other', "\t\tEtc."),
  Type.new('removed', "\t\tDelete a feature."),
  Type.new('secured', "\t\tEstablish a security layer.")
].freeze

require 'changelog'
require 'changelog/option_parser'
require 'changelog/writer'
require 'changelog/creator'

begin
  changelogko_command_file_path = "#{FileUtils.pwd}/.changelogko"
  ARGV << File.read(changelogko_command_file_path).strip if File.exist?(changelogko_command_file_path)
  options = Changelog::OptionParser.parse(ARGV)
  if options.release
    log_collection = {}
    TYPES.each do |type|
      log_collection[type.name] = []
    end
    files = 0
    Dir.glob('./changelogs/unreleased/*.yml') do |file|
      changelog = Changelog.new(file, :file)
      changelog.validate!
      log_collection[changelog.type] << changelog
      files += 1
    rescue InvalidLogFile => e
      puts e.message
      exit(1)
    end
    if files.positive?
      Changelog::Writer.call(log_collection, options.no_archive)
    else
      puts 'No logs found at changelogs/unreleased/'
    end
  elsif options.title && options.type
    Changelog::Creator.call(options)
    # Changelog creation
  end
rescue InvalidLogFile => e
  puts e.message
  exit(1)
rescue ProcessEnded
  exit
end
