# Class responsible for parsing options and detecting arguments passed for Changelogko.
class Changelog::OptionParser
  Options = Struct.new(
    :release,
    :title,
    :type,
    :dry_run
  )

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
      opts.banner = "Usage: changelogko [options] [title]\n\n Options:\n"

      release_option(opts, options)
      type_option(opts, options)
      help_option(opts)
    end
  end

  def self.release_option(opts, options)
    opts.on('-r', '--release', 'Create release from unreleased directory') do |_value|
      options.release = true
    end
  end

  def self.type_option(opts, options)
    type_desc = "Type of changelog, options are: #{TYPES.map(&:name).join(', ')}"
    opts.on('-t', '--type [string]', String, type_desc) do |value|
      options.type = value
    end
  end

  def self.help_option(opts)
    opts.on('-h', '--help', 'Show help') do
      $stdout.puts opts
      raise ProcessEnded
    end
  end
end
