class FailuresController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def create
    failure = Failure.new(failure_params)
  
    if failure.save
      render json: failure
    else
      render json: { error: 'Unable to create failure' }
    end
  end

  private

  def failure_params
    params.permit(:test_file, :test_name, :line_number, :failure)
  end
end