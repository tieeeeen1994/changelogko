# frozen_string_literal: true

module Releaseko
  # Class responsible for managing the file ./metadata/app-version.
  class AppVersion
    METHODS = %w[major minor build].freeze
    FILE_PATH = File.join(Dir.pwd, 'metadata', 'app-version').freeze

    attr_reader :method, :breakdown

    def initialize(method)
      @method = method
      validate!
    end

    def perform
      breakdown_version
      increment_on_method
      build_version!
    end

    private

    def validate!
      CustomError.new("Unknown method: #{method}").complain unless METHODS.include?(method)
      CustomError.new("#{FILE_PATH} not found", 2).complain unless File.exist?(FILE_PATH)
    end

    def app_version
      @app_version ||= File.read(FILE_PATH).strip
    end

    def build_version!
      puts "Overwriting #{FILE_PATH} with new version"
      new_version = "#{breakdown['major']}.#{breakdown['minor']}.#{breakdown['build']}"
      File.write(FILE_PATH, new_version)
    end

    def breakdown_version
      puts 'Breaking down version numbers'
      version_numbers = app_version.split('.')
      @breakdown = {
        'major' => version_numbers[0],
        'minor' => version_numbers[1],
        'build' => version_numbers[2],
        'other' => version_numbers[3..].join('.')
      }
    end

    def increment_on_method
      puts "Incrementing #{method} number"
      breakdown[method] = breakdown[method].next
      reset_trailing_version_numbers
    end

    def reset_trailing_version_numbers
      ((METHODS.find_index(method) + 1)..(METHODS.length - 1)).each do |i|
        breakdown[METHODS[i]] = 0
      end
    end
  end
end
