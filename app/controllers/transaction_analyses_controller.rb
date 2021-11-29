class TransactionAnalysesController < ApplicationController
  include PaginationSupport

  layout 'fluid'

  def index
    scope = TransactionAnalysis.includes(:blockchain_tx, :deposit, :user).order('id desc')
    render locals: { transaction_analyses: paginate(scope) }
  end

  def show
    render locals: { transaction_analysis: TransactionAnalysis.find(params[:id]) }
  end
end
