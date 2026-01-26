#returns whether the record is abstract or not, impplies there is no data table
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
