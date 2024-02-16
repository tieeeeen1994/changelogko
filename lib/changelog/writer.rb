# frozen_string_literal: true

# Class responsible for writing the change logs and collating them.
class Changelog::Writer
  def self.call(collection, no_archive = false)
    generate_change_log(collection)
    archive_old_change_log unless no_archive
    publish_change_log
    clear_unreleased_logs
  end

  def self.generate_change_log(collection)
    File.open(TEMP_CHANGE_LOG_NAME, 'w') do |file|
      write_title(file)
      TYPES.each do |type|
        write_collection(type, collection, file)
      end
      file.puts ''
    end
    puts "Creating temporary file  #{::TEMP_CHANGE_LOG_NAME}"
  end

  def self.archive_old_change_log
    system('mkdir -p changelogs')
    date_str = Time.now.strftime('%b-%d-%Y-%H-%M-%S')
    old_change_log_location = "changelogs/archive-#{date_str}.md"
    system("mv #{::CHANGE_LOG_NAME} #{old_change_log_location}")
    puts 'Archive old Changelog'
  end

  def self.publish_change_log
    system("mv #{::TEMP_CHANGE_LOG_NAME} #{::CHANGE_LOG_NAME}")
    puts "Renamed #{::TEMP_CHANGE_LOG_NAME} to #{::CHANGE_LOG_NAME}"
  end

  def self.clear_unreleased_logs
    puts 'Clearing changelogs/unreleased'
    system('rm changelogs/unreleased/*')
    system('rmdir changelogs/unreleased')
  end

  def self.write_title(file)
    file.puts("# Changelogs \n")
  end

  def self.write_collection(type, collection, file)
    lines = collection[type.name]
    size = lines.size

    return if size.zero?

    file.puts("## #{type.name.capitalize} (#{size} count/s)\n")

    write_lines(lines, file)
  end

  def self.write_lines(lines, file)
    lines.each do |line|
      file.puts("  + #{line.title} - #{line.author}")
    end
  end
end
