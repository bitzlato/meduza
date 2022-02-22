require 'csv'

class TransactionsExporter
  ATTRIBUTES = TransactionAnalysis.attribute_names
  attr_accessor :output, :records

  def initialize(records, output)
    @records = records
    @output = output
  end

  def generate(scope)
    output << ATTRIBUTES
    scope.each do |row|
      output << CSV.generate_line(
        TransactionAnalysis.attribute_names.map { |attr| row.send attr }
      )
    end
  end
end
