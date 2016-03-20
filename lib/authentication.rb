module Authentication
  class << self

    # Validate the Authorization code & as user login provide refresh token and access token
    #
    # @params code [String], Google OAuth Authorization code
    #
    # @return [HTTParty::Response], Hash containing the Google OAuth request details
    #
    #   example response of valid auth token:
    #   {"access_token"=> <some character patter>,
    #     "token_type"=> "Bearer",
    #     "expires_in"=> <integer value in second>,
    #     "refresh_token"=> <some character patter>,
    #     "id_token"=> <some character patter>
    #   }
    #
    #   example response 0f invalid auth token
    #   {"error"=>"invalid_grant", "error_description"=>"Invalid code."}
    #
    # @return [Hash] containing refresh token and access token
    def login(code)
      begin
        response = HTTParty.post('https://www.googleapis.com/oauth2/v4/token',
          query: {
            code: code,
            grant_type: 'authorization_code',
            client_id: ENV['GOOGLE_OAUTH_CLIENT_ID'],
            client_secret: ENV['GOOGLE_OAUTH_CLIENT_SECRET'],
            redirect_uri: ENV['GOOGLE_OAUTH_REDIRECT_URL']
          })
      rescue
        raise CustomException::RequestTimeOut
      end

      raise CustomException::Unauthorized unless response.code == Constant::OK

      {
      access_token: response['access_token'],
      refresh_token: response['refresh_token']
      }
    end

    # Provides the new access token in behalf of refresh token
    #
    # @params code [String], Google OAuth Refresh code
    #
    # @return [HTTParty::Response], Hash containing the Google OAuth request details
    #
    #   example response of valid auth token:
    #   {"access_token"=> <some character patter>,
    #     "token_type"=> "Bearer",
    #     "expires_in"=> <integer value in second>,
    #     "id_token"=> <some character patter>
    #   }
    #
    #   example response 0f invalid auth token
    #   {"error"=>"invalid_grant", "error_description"=>"Invalid code."}
    #
    # @return [Hash] containing access token
    def refresh(refresh_token)
      begin
        response = HTTParty.post('https://www.googleapis.com/oauth2/v4/token',
        query: { refresh_token: refresh_token,
        grant_type: 'refresh_token',
        client_id: ENV['GOOGLE_OAUTH_CLIENT_ID'],
        client_secret: ENV['GOOGLE_OAUTH_CLIENT_SECRET']
        })
      rescue
        raise CustomException::RequestTimeOut
      end

      raise CustomException::Unauthorized unless response.code == Constant::OK

      {
      access_token: response['access_token']
      }
    end


    # Validate whether the auth token with Google OAuth and provide details
    #
    # @params token [String], Google OAuth token
    #
    # @return [HTTParty::Response], Hash containing the Google OAuth request details
    #
    #   example response of valid auth token:
    #   {"id"=> <some integer value>,
    #     "email"=>"pustkaly_user@example.com",
    #     "verified_email"=>true,
    #     "name"=> <user full name>,
    #     "given_name"=> <user given name>,
    #     "family_name"=> <user family name>,
    #     "link"=> <google plus account link>,
    #     "picture"=> <some image url>,
    #     "gender"=>"male",
    #     "locale"=>"en",
    #     "hd"=>"example.com"}
    #
    #   example response 0f invalid auth token
    #   {"error"=>
    #     {"errors"=>
    #     [{"domain"=>"global", "reason"=>"authError", "message"=>"Invalid Credentials", "locationType"=>"header", "location"=>"Authorization"}],
    #     "code"=>401,
    #     "message"=>"Invalid Credentials"}}
    def get_user_info_from_access_token(token)
      begin
        response = HTTParty.get('https://www.googleapis.com/oauth2/v2/userinfo',
        headers: {
        'Authorization' => "OAuth #{token}"
        })
      rescue
        raise CustomException::RequestTimeOut
      end

      raise CustomException::Unauthorized unless response.code == Constant::OK
      response
    end

    # Validate the domain of the Gmail account
    #
    # @params auth [HTTParty::Response], Hash containing response of Google Oauth validation
    def authenticate_domain(auth)
      unless auth['hd'] == ENV['AUTH_DOMAIN']
        raise CustomException::DomainConflict
      end
      true
    end
  end
end
