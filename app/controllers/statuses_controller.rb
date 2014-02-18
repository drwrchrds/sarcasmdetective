class StatusesController < ApplicationController
  def show
    @status = Status.find_by(params[:id])
  end
end
