class SirenFormsController < ApplicationController

  def new
    @siren_form = SirenForm.new
  end

  def create
    @siren_form = SirenForm.new(siren_params)
    @ResultList = Siren.search(@siren_form)
    redirect_to siren_form_path(1, result: @ResultList)
  end

  def show
    @result = params[:result]
  end

  private

  def siren_params
    params.require(:siren_form).permit(:siren, :name)
  end
end
