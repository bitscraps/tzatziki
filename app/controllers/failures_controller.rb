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

  def index
    @failures = Failure.all

    respond_to do |format|
      format.html
      format.csv { send_data @failures.to_csv, filename: "failures-#{Date.today}.csv" }
    end
  end

  private

  def failure_params
    params.permit(:repo_name, :build_number, :branch, :username, :circle_job,
                  :test_file, :test_name, :line_number, :failure)
  end
end