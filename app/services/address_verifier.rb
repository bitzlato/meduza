# Верифицирует адрес и возврщаает можно ли его пропускать
#
class AddressVerifier
  attr_reader :address, :cc_code

  def initialize(address, cc_code)
    @address = address
    @cc_code = cc_code
  end

  def pass?
    (find_actual_cached || verify).
      analysis_result.
      pass?
  end

  private

  def find_actual_cached
    AddressAnalysis.
      find_by(address: address, cc_code: cc_code).
      try(:actual?)
  end

  def verify
    analysis_result = ValegaAnalyzer.new.analyse(Array(address), cc_code).first

    address_analysis = AddressAnalysis
      .create_with(analysis_result: analysis_result)
      .find_or_create_by!(
        address: analysis_result.address_transaction,
        cc_code: cc_code
    )
    address_analysis.update! analysis_result: analysis_result unless address_analysis.analysis_result == analysis_result
    address_analysis
  end
end
