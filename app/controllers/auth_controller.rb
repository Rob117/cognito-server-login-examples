class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action  do
    @client_id = "5d39i7ngqp27mfvsd70m0mq8o8"
    @domain = "https://wevox-test.auth.ap-northeast-1.amazoncognito.com"
    @redirect_uri = "https://d2sgl1ucddhxpa.cloudfront.net/cognito/"
  end
  def index; end

  # redirect to login form
  def generate_tokens
    redirect_to "#{@domain}/login?client_id=#{@client_id}&redirect_uri=#{@redirect_uri}&response_type=code&scope=openid"
  end

  # generate tokens, return tokens with code auth challenge
  def callback
    # uri = URI.parse("#{@domain}/oauth2/token")
    # auth_params = [ ["grant_type", "authorization_code"], ["code", params[:code]], ["client_id", @client_id], ["redirect_uri", @redirect_uri]  ]
    # @response = Net::HTTP.post_form(uri, auth_params)
    # Can I get this to work with the cognito SDK?
    @response = HTTP.post("#{@domain}/oauth2/token", form: {"grant_type" => "authorization_code", "code" => params[:code], "client_id" => @client_id, "redirect_uri" => @redirect_uri})
  end

  def api
    # https://github.com/aws/aws-sdk-js/issues/1212
    # just get API params from being passed in <3
    resp = Cognito.admin_initiate_auth({
      user_pool_id: "ap-northeast-1_VXN6wSX1Z", # required
      client_id: "5d39i7ngqp27mfvsd70m0mq8o8", # required
      auth_flow: "ADMIN_NO_SRP_AUTH", # required, accepts USER_SRP_AUTH, REFRESH_TOKEN_AUTH, REFRESH_TOKEN, CUSTOM_AUTH, ADMIN_NO_SRP_AUTH, USER_PASSWORD_AUTH
      auth_parameters: {
          USERNAME: params[:username], # or params
          PASSWORD: params[:password] # or params
      }
    })
    render json: {data: resp.to_h}
  end

  def decode_token
    jwt = request.headers['jwt']
    token = JWTDecoder.decode_id_token(jwt)
    render json: token
  end
end
