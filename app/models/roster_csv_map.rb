class RosterCsvMap < ApplicationRecord
  self.table_name = "roster_csv_map"
  
  def self.create(courseName)
  	newMap = RosterCsvMap.new()

  	newMap.name = "#{courseName} Roster Map"

  	# Set the default values of each column
  	newMap.semestercol = 0
    newMap.emailcol = 1
    newMap.lastnamecol = 2
    newMap.firstnamecol = 3
    newMap.schoolcol = 4
    newMap.majorcol = 5
    newMap.yearcol = 6
    newMap.gradingpolicycol = 7
    newMap.coursenumbercol = 8
    newMap.courselecturecol = 9
    newMap.sectioncol = 10
  	return newMap
  end
end