# Get the filename from the first passed argument.
file_name = ARGV[0]
# Exit with an error unless we have a filename
abort "Please pass a valid CSV filename as the first argument" unless file_name
  
# Initialise a new array to store the links in
course_links = []

# Open the CSV file. Based on
# http://snippets.aktagon.com/snippets/246-How-to-parse-CSV-data-with-Ruby
file = File.new(file_name, 'r')
# Initialise a new index that tells us which line of the file we're on.
index = 0

file.each_line do |row|
  
  # Increment the index
  index += 1

  # Remove any linebreaks from the end of the row.
  row.chomp!
  
  # Split into columns.
  columns = row.split(',')
  
  # If we do not have two columns or the second is empty, we have been passed
  # invalid CSV so exit with an error.
  abort "Invalid CSV" if columns.size != 2 or columns[1] == ""
  
  # Ignore the first row - headers
  unless index == 1
    if columns.first == ""
      # We just have a moodle course, add it to the end of the array.
      course_links.last[:sims_courses] << [columns[1]]
    else
      # We have a course and moodle course, so add them to the array.
      course_links << {:id => columns[0], :sims_courses => [columns[1]]}
    end
  end
end

# For each course...
course_links.each do |course|
  # For each sims course...
  course[:sims_courses].each_with_index do |sims_course, index|
    # Get some details we can use to generate the SQL.
    course_id = course[:id]
    sims_course_id = sims_course

    # Generate a string containing the SQL we need to run.
    sql_string = <<-EOF
    INSERT INTO `moodle_11`.`mdl_enrol` (
      `id`, `enrol`, `status`, `courseid`, `sortorder`, `name`, `enrolperiod`,
      `enrolstartdate`, `enrolenddate`, `expirynotify`, `expirythreshold`,
      `notifyall`, `password`, `cost`, `currency`, `roleid`, `customint1`,
      `customint2`, `customint3`, `customint4`, `customchar1`, `customchar2`,
      `customdec1`, `customdec2`, `customtext1`, `customtext2`, `timecreated`,
      `timemodified`
    )
    VALUES (
      NULL, 'meta', '0', '#{course_id}', '#{index}', NULL, '0', '0', '0', '0',
      '0', '0', NULL, NULL, NULL, '0', '#{sims_course_id}', NULL, NULL, NULL,
      NULL, NULL, NULL, NULL, NULL, NULL, '1315402823', '1315402823'
    );
    EOF
    
    # Strip four spaces from beginning of string. Courtesy of StackOverflow -
    # http://stackoverflow.com/questions/3350648
    sql_string.gsub!(/^ {4}/, '')
    
    # Output the SQL.
    puts sql_string
  end
end