class FailuresController < ApplicationController
  skip_before_action :verify_authenticity_token

  http_basic_authenticate_with name: ENV.fetch('HTTP_USERNAME'), password: ENV.fetch('HTTP_PASSWORD'), only: :index

  def create
    failure = Failure.new(failure_params)
  
    if failure.save
      render json: failure
    else
      render json: { error: 'Unable to create failure' }
    end
  end

  def index
    @failures_csv = Failure.all
    @failures = Failure.select(:repo_name, :build_number, :branch).distinct(:branch).group(:branch, :build_number, :repo_name)

    respond_to do |format|
      format.html
      format.csv { send_data @failures_csv.to_csv, filename: "failures-#{Date.today}.csv" }
    end
  end

  def show
    @failures = Failure.where(build_number: params[:id])
  end

  private

  def failure_params
    params.permit(:repo_name, :build_number, :branch, :username, :circle_job,
                  :test_file, :test_name, :line_number, :failure)
  end
end