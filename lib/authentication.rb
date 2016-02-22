module Authentication
  class << self

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
    def authenticate_with_oauth(token)
      begin
        # Todo Use latest oauth2 v3
        # HTTParty.get("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{token}")
        response = HTTParty.get("https://www.googleapis.com/oauth2/v2/userinfo",
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
