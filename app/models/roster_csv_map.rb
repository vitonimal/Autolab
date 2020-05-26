class RosterCsvMap < ApplicationRecord
  self.table_name = "roster_csv_map"

  after_update :verify_full_mapping
  
  def self.new_default(courseName)
  	newMap = RosterCsvMap.new

  	newMap.name = courseName

    newMap.semestercol = -1
    newMap.emailcol = -1
    newMap.lastnamecol = -1
    newMap.firstnamecol = -1
    newMap.schoolcol = -1
    newMap.majorcol = -1
    newMap.yearcol = -1
    newMap.gradingpolicycol = -1
    newMap.coursenumbercol = -1
    newMap.courselecturecol = -1
    newMap.sectioncol = -1

    if not newMap.save
      raise "Failed to create map for #{courseName}: #{newMap.errors.full_messages.join(", ")}"
    end

  	return newMap
  end
  
  # header is the first row of the sortable table
  def assignMapping(header)
    headerl = header.length
    
    RosterCsvMap.transaction do
      # acquire lock on current map
      # not really sure why but locking feels safer
      # will remove this lock if it turns out unnecessary
      reload(lock: true)

      for i in 0..(headerl-1)
        case header[i]
        when "EMAIL"
          self.emailcol = i
        when "FIRST_NAME"
          self.firstnamecol = i
        when "LAST_NAME"
          self.lastnamecol = i
        when "LECTURE"
          self.courselecturecol = i
        when "SECTION"
          self.sectioncol = i
        when "SCHOOL"
          self.schoolcol = i
        when "MAJOR"
          self.majorcol = i
        when "YEAR"
          self.yearcol = i
        when "GRADING_POLICY"
          self.gradingpolicycol = i
        when "COURSE_NUMBER"
          self.coursenumbercol = i
        when "SEMESTER"
          self.semestercol = i
        end
      end

      save!
    end # release lock
  end

private
  
  def verify_full_mapping
    if self.semestercol < 0 || self.emailcol < 0 ||
       self.lastnamecol < 0 || self.firstnamecol < 0 ||
       self.schoolcol < 0 || self.majorcol < 0 ||
       self.yearcol < 0 || self.gradingpolicycol < 0 ||
       self.coursenumbercol < 0 || self.courselecturecol < 0 ||
       self.sectioncol < 0
      fail "Invalid mapping updates for #{self.name}"
    end
  end

end