class AddRosterCsvMappingTable < ActiveRecord::Migration[5.2]
  def change
    create_table :roster_csv_map do |t|
      # Semester,email,last_name,first_name,school,major,year,grading_policy,courseNumber,courseLecture,section
      t.string :name

      t.integer :semestercol
      t.integer :emailcol
      t.integer :lastnamecol
      t.integer :firstnamecol
      t.integer :schoolcol
      t.integer :majorcol
      t.integer :yearcol
      t.integer :gradingpolicycol
      t.integer :coursenumbercol
      t.integer :courselecturecol
      t.integer :sectioncol
    end
  end
end
