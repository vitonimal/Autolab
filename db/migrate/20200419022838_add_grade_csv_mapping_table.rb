class AddGradeCsvMappingTable < ActiveRecord::Migration[5.2]
  def change
    create_table :grade_csv_map do |t|
      t.string :name

      t.integer :emailcol
      t.integer :typecol
    end

    create_table :grade_csv_problem do |t|
      t.integer :grade_map_id
      t.integer :grade
    end
  end
end
