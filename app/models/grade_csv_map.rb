class GradeCsvMap < ApplicationRecord
  self.table_name = "grade_csv_map"
  has_many :grade_csv_grade
end