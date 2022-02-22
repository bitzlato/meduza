require 'csv'

class CsvBuilder
  attr_accessor :records, :attributes

  def initialize(records)
    @records    = records
    @attributes = records.klass.attribute_names
  end

  def enumerator
    # yielder << attributes
    Enumerator.new do |yielder|
      records.lazy.each do |row|
        yielder << CSV.generate_line(
          attributes.map { |attr| row.send attr }
        )
      end
    end
  end
end
