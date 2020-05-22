class GradeCsvMap < ApplicationRecord
  self.table_name = "grade_csv_map"
  has_many :grade_csv_problems, foreign_key: 'grade_map_id', dependent: :destroy
  # need to verify each column has a valid mapping, i.e. not -1
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
        case colMap[i]
        when "Email"
          self.emailcol = i
        when "Grade Type"
          self.typecol = i
        else
          problems.each do |problem|
            if problem.name.equal?(colMap[i])
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
       self.problems.inject { |prev_valid, problem| prev_valid && problem.grade >= 0 }
      # do nothing
    else
      raise "Invalid mapping updates for #{self.name}"
    end
  end
end