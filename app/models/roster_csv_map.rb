class RosterCsvMap < ApplicationRecord
  self.table_name = "roster_csv_map"
  
  def self.new_default(courseName)
  	newMap = RosterCsvMap.new()

  	newMap.name = "#{courseName} Roster Map"

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
  
  # firstRow contains mapping info
  def assignMapping(colMap)
    mapl = colMap.length
    
    RosterCsvMap.transaction do
      # acquire lock on current map
      # not really sure why but locking feels safer
      # will remove this lock if it turns out unnecessary
      reload(lock: true)

      for i in 0..(mapl-1)
        case colMap[i]
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

end