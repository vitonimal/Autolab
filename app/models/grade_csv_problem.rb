class GradeCsvProblem < ApplicationRecord
  self.table_name = "grade_csv_problem"
  belongs_to :grade_csv_map
end