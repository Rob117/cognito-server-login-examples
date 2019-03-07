# https://medium.com/@victor.leong.17/decoding-aws-cognito-jwt-in-rails-f88c1c4db9ec
# https://github.com/jwt/ruby-jwt/issues/158#issuecomment-336262435

# require 'json'
# # install these
# require 'json/jwt'

require 'open-uri'
class JwtDecoder
  attr_reader :jwks
  def initialize(jwk_url)
    # open is from open uri, will dl contents
    @jwks = JSON.load(open(jwk_url)) # GET THE ACTUAL DL
  end

  # Token should be a id JWT, as a string
  def decode_id_token(token)
  # Does not work with RSA256
  # decode = JSON::JWT.decode token, nil, false
  decode = JWT.decode token, nil, false

  # Get the kid from the header
  kid = decode[1]['kid']

  # The JWK file contains multiple keys, so we need to get the key that matches
  jwk_hash = @jwks["keys"].detect { |jwk| jwk["kid"] == kid }

  # Take hash, convert to JWK object
  jwk = JSON::JWK.new(jwk_hash)

  # Get the open ssl PKey RSA
  rsa_public = jwk.to_key

  token = JWT.decode token, rsa_public, true, algorithm: 'RS256'
  # Only one token, so return 0
  token[0]
  end
end

# User pool / region should be env vars
JWTDecoder = JwtDecoder.new("https://cognito-idp.ap-northeast-1.amazonaws.com/ap-northeast-1_VXN6wSX1Z/.well-known/jwks.json")