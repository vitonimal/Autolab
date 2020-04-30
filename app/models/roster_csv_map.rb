class RosterCsvMap < ApplicationRecord
  self.table_name = "roster_csv_map"
  
  # I assume we need to pass in the sortable table information here?
  def self.create()
  	newMap = RosterCsvMap.new()
  	# and then complete the initialization of the new map?
  	return newMap
  end
end