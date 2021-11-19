class AddressAnalysesController < ApplicationController
  def show
    render locals: { address_analysis: AddressAnalysis.find(params[:id]) }
  end
end
