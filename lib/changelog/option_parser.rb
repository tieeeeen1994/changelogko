# frozen_string_literal: true

# Class responsible for parsing options and detecting arguments passed for Changelogko.
class Changelog::OptionParser
  Options = Struct.new(:release, :title, :type, :no_archive)

  def self.parse(argv)
    options = Options.new

    parser = option_parser(options)

    argv = ['-h'] if argv.empty?
    parser.parse!(argv)

    options.title = argv.join(' ').strip.squeeze(' ').tr("\r\n", '') unless options.release
    options
  end

  def self.option_parser(options)
    ::OptionParser.new do |opts|
      opts.banner = "Usage: (changelogko|cko) [options]\nOptions:\n"

      release_option(opts, options)
      type_option(opts, options)
      types_option(opts)
      no_archive_option(opts, options)
      help_option(opts)
    end
  end

  def self.release_option(opts, options)
    opts.on('-r', '--release', 'Create release from unreleased directory.') do
      options.release = true
    end
  end

  def self.type_option(opts, options)
    type_desc = 'Type of changelog. Use -T, --types to display all available types.'
    opts.on('-t', '--type [title]', String, type_desc) do |value|
      options.type = value
    end
  end

  def self.types_option(opts)
    opts.on('-T', '--types', 'List available types.') do
      TYPES.each do |type|
        $stdout.puts "#{type.name}\t#{type.description}"
      end
      raise ProcessEnded
    end
  end

  def self.no_archive_option(opts, options)
    opts.on('-A', '--no-archive', 'Do not archive the release after creating it.') do
      options.no_archive = true
    end
  end

  def self.help_option(opts)
    opts.on('-h', '--help', 'Show help.') do
      $stdout.puts opts
      raise ProcessEnded
    end
  end
end
