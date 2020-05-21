class GradeCsvProblem < ApplicationRecord
  self.table_name = "grade_csv_problem"
  belongs_to :grade_csv_maps, foreign_key: 'grade_map_id'

end