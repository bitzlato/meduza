require 'csv'

class CsvBuilder
  attr_accessor :records, :attributes

  def initialize(records)
    @records    = records
    @attributes = records.klass.respond_to?(:csv_attributes) ? records.klass.csv_attributes : records.klass.attribute_names
  end

  def enumerator
    # yielder << attributes
    Enumerator.new do |yielder|
      yielder << CSV.generate_line(attributes)
      records.lazy.each do |row|
        yielder << CSV.generate_line(
          attributes.map { |attr| row.send attr }
        )
      end
    end
  end
end
