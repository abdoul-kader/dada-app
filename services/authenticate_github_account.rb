# frozen_string_literal: true

require 'http'

module Dada
  # Returns an authenticated user, or nil
  class AuthenticateGithubAccount
    def initialize(config)
      @config = config
    end

    def call(code)
      access_token = get_access_token_from_github(code)
      # puts "access token:#{access_token}"
      get_sso_account_from_api(access_token)
      b=get_sso_account_from_api(access_token)
      # puts "b:  #{b}"
    end

    private

    def get_access_token_from_github(code)
      challenge_response =
        HTTP.headers(accept: 'application/json')
            .post(@config.GH_TOKEN_URL,
                  json: { client_id: @config.GH_CLIENT_ID,
                          client_secret: @config.GH_CLIENT_SECRET,
                          code: code })

      raise unless challenge_response.status < 400
      challenge_response.parse['access_token']
    end

    def get_sso_account_from_api(access_token)
      sso_info = { access_token: access_token }
      #puts "sso info: #{sso_info}"
      signed_sso_info = SecureMessage.sign(sso_info)
      #puts "signed= #{signed_sso_info}"

      response =
        HTTP.post("#{@config.API_URL}/auth/authenticate/github_account",
                  json: signed_sso_info)
      # puts "response : #{response}, config= #{@config.API_URL}"
      response.code == 200 ? response.parse : nil
    end
  end
end
