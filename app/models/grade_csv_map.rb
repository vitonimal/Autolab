class GradeCsvMap < ApplicationRecord
  self.table_name = "grade_csv_map"
  has_many :grade_csv_problems
  
  def self.create(courseName, asmt)
  	newMap = GradeCsvMap.new

  	newMap.name = courseName + " " + asmt.name

  	newMap.emailcol = -1
  	newMap.typecol = -1

  	if not newMap.save
  	  raise "Failed to create map for #{courseName} #{assessmentName}: #{newMap.errors.full_messages.join(", ")}"
  	end

  	# asmt.problems.each do |problem|
  	 # self.grade_csv_problems.create
  	# end

  	return newMap
  end
end