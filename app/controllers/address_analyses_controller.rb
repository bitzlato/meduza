class AddressAnalysesController < ResourcesController
  def recheck
    record.recheck!
    redirect_to address_analyses_path(record), notice: t('.recheck_pended')
  end
end
