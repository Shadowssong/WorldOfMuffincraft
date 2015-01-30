class Search
  TRUE_VALUES = ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES

  include MockModel

  attr_accessor :character_name, :realm

  validates :query, presence: true
end
