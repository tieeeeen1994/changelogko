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

    parser.parse!(argv)

    options.title = argv.join(' ').strip.squeeze(' ').tr("\r\n", '') unless options.release
    options
  end

  def self.option_parser(options)
    ::OptionParser.new do |opts|
      opts.banner = "Usage: changelogko [options] [title]\n\n Options:\n"

      opts.on('-r', '--release', 'Create release from unreleased directory') do |_value|
        options.release = true
      end

      type_desc = "Type of changelog, options are: #{TYPES.map(&:name).join(', ')}"
      opts.on('-t', '--type [string]', String, type_desc) do |value|
        options.type = value
      end

      opts.on('-h', '--help', 'Show help') do
        $stdout.puts opts
        raise ProcessEnded
      end
    end
  end
end
