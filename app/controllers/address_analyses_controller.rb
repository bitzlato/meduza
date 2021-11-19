class AddressAnalysesController < ApplicationController
  include PaginationSupport

  def index
    scope = AddressAnalysis.includes(:analysis_result).order('id desc')
    render locals: { address_analyses: paginate(scope) }
  end

  def show
    render locals: { address_analysis: AddressAnalysis.find(params[:id]) }
  end
end
