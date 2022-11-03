require 'yaml'
require 'fileutils'
require 'optparse'

CHANGE_LOGS_PATH = './changelogs'.freeze
CHANGE_LOG_NAME = './CHANGELOG.md'.freeze
TEMP_CHANGE_LOG_NAME = './CHANGELOG.md.temp'.freeze
InvalidLogFile = Class.new(StandardError)
NoLogsFound = Class.new(StandardError)
ProcessEnded = Class.new(StandardError)

Type = Struct.new(:name)

TYPES = [
  Type.new('added'),
  Type.new('fixed'),
  Type.new('changed'),
  Type.new('enhanced'),
  Type.new('deprecated'),
  Type.new('removed'),
  Type.new('security'),
  Type.new('performance'),
  Type.new('other')
].freeze

require 'changelog'
require 'changelog/option_parser'
require 'changelog/writer'
require 'changelog/creator'

begin
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
      Changelog::Writer.call(log_collection)
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
