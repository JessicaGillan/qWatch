class DataController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_headers

  def create
    Watchable.collect(params[:service], params[:watchables])
    render json: {status: "success"}, status: 200
  end

  def options
  end

  private
    def set_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, OPTIONS'
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    end
end
