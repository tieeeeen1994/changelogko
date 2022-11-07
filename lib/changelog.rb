# Main class that manages the set of actions for managing change logs.
class Changelog
  attr_reader :file_path, :errors, :type, :title, :options, :source, :author

  def initialize(params, source = :file)
    @source = source
    @errors = []
    if source == :file
      @file_path = params
    else
      @options = params
    end

    load_data
  end

  def valid?
    clear_errors
    load_data
    check_data

    errors.size.zero?
  end

  def validate!
    return true if valid?

    raise InvalidLogFile, error_full_messages.join(".\n")
  end

  def file
    @file ||= File.read(file_path)
  end

  def load_data
    @title = data[:title]
    @type = data[:type]
    @author = data[:author]
  end

  def check_data
    add_error 'Missing Title' if @title.nil?
    add_error 'Missing Type' if @type.nil?
    validate_type
  end

  def validate_type
    type = TYPES.find { |t| t.name == @type }

    add_error "Invalid Type '#{@type}'" unless type
  end

  def clear_errors
    @errors = []
  end

  def data
    @data ||= load_from_source
  end

  def load_from_source
    if source == :file
      yaml = YAML.safe_load(file)
      initialize_props_from_yaml(yaml)
    else
      initialize_props_from_options
    end
  end

  def initialize_props_from_yaml(yaml)
    {
      title: yaml.fetch('title', nil),
      type: yaml.fetch('type', nil),
      author: yaml.fetch('author', nil)
    }
  end

  def initialize_props_from_options
    {
      title: options.title,
      type: options.type,
      author: author_name
    }
  end

  def to_s
    "Title: #{@title} | Type: #{@type}"
  end

  def author_name
    name = "#{`git config user.name`[0..-2]} (#{`git config user.email`[0..-2]})"
    name = "#{`git config --global user.name`[0..-2]} (#{`git config --global user.email`[0..-2]})" if name =~ /\A\s*\Z/
    name
  end

  def show_errors
    errors_full_messages.each { |message| puts message }
  end

  def error_full_messages
    if source == :file
      errors.collect { |error| "#{error} at #{file_path}" }
    else
      errors
    end
  end

  def add_error(message)
    errors << message
  end

  def save
    File.open(generate_file_name, 'w') do |file|
      file.puts("title: #{title}")
      file.puts("author: #{author}")
      file.puts("type: #{type}")
    end
  end

  def generate_file_name
    base_path = 'changelogs/unreleased'
    FileUtils.mkdir_p(base_path)
    safe_name = title.gsub(/[^\w-]/, '-')
    "#{base_path}/#{safe_name}.yml"
  end
end
