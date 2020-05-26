class GradeCsvMap < ApplicationRecord
  self.table_name = "grade_csv_map"
  has_many :grade_csv_problems, foreign_key: 'grade_map_id', dependent: :destroy
  # need to verify each column has a valid mapping, i.e. not -1
  # will write another verification once after confirming what is mandatory for
  # bulk import
  after_update :verify_full_mapping

  def self.create(asmt)
  	newMap = GradeCsvMap.new

  	newMap.name = asmt.course.name + " " + asmt.name

  	newMap.emailcol = -1
  	newMap.typecol = -1

  	if not newMap.save
  	  raise "Failed to create map for #{asmt.course.name} #{asmt.name}: #{newMap.errors.full_messages.join(", ")}"
  	end

  	asmt.problems.each do |problem|
  	  newMap.grade_csv_problems.create(:problem_id => problem.id, :grade => -1)
  	end

  	return newMap
  end

  def assignMapping(header, asmt)
    headerl = header.length
    
    GradeCsvMap.transaction do
      # acquire lock on current map
      # not really sure why but locking feels safer
      # will remove this lock if it turns out unnecessary
      reload(lock: true)

      problems = asmt.problems
      gcps = self.grade_csv_problems

      for i in 0..(mapl-1)
        case header[i]
        when "Email"
          self.emailcol = i
        when "Grade Type"
          self.typecol = i
        else
          problems.each do |problem|
          	# note that header takes on the form "problem Score/Feedback"
          	# TODO: check whether there is escape character at the end
            if problem.name.equal?(header[i])
              gcp = gcps.find_by(:problem_id => problem.id)
              gcp.grade = i
              gcp.save
              break
            end
          end
        end
      end

      save!
    end # release lock
  end

private
  
  def verify_full_mapping
    if self.emailcol >= 0 && self.typecol >= 0 &&
       self.grade_csv_problems.inject { |prev_valid, cur_map| prev_valid && cur_map.grade >= 0 }
      # do nothing
    else
      fail "Invalid mapping updates for #{self.name}"
    end
  end
end