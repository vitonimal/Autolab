class AddProblemForeignKeyColToGradeCsvProblem < ActiveRecord::Migration[5.2]
  def up
  	add_column :grade_csv_problem, :problem_id, :integer
  end

  def down
  	remove_column :grade_csv_problem, :problem_id
  end
end
