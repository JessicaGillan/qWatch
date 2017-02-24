# Public: API controller for data mining in chrome extension
#
class DataController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_headers

  ALLOWED_SERVICES = {"netflix" => true}

  def create
    # check that data mined is one of the permitted services
    if(ALLOWED_SERVICES[params[:service]] && params[:watchables])
      # call the Watchable collect method, passing the data collected from the gem miner
      Watchable.collect(params[:service], params[:watchables])
      render json: {status: "success"}, status: 200
    else
      render json: {status: "error", error: "host domain not in allowed services list"}, status: 500
    end
  end

  # options method for preflight check on cross-domain origins
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
