class CurrenciesController < ApplicationController
  def update
    currency.update! params_permitted
    redirect_to root_path
  end

  def update_all
    Currency.find_each do |currency|
      currency.update params_permitted
    end
    redirect_to root_path
  end

  private

  def currency
    @currency ||= Currency.find params[:id]
  end

  def params_permitted
    params.require(:currency).permit(:status)
  end
end
