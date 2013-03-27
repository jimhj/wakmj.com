require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Renren < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, "renren"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, { 
        :site              =>   'https://graph.renren.com',
        :authorize_url     =>   '/oauth/authorize',
        :token_url         =>   '/oauth/token'
      }

      option :authorize_params, {
        :redirect_uri => Setting.renren_callback_url
      } 

      option :token_params, {
        # SET :parse because weibo oauth2 access_token response with "content-type"=>"text/plain;charset=UTF-8",
        # and when you use ruby 1.8.7, the response body was not a valid HASH (see: https://github.com/intridea/oauth2/issues/75)
        # :body=>"{\"access_token\":\"2.001FOK5CacB2wCc20a59773d0uSGnj\",\"expires_in\":86400,\"uid\":\"2189335154\"}"}
        :parse => :json
      }      

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid { raw_info["id"] }


      info do
        {
          :nickname => raw_info['name'],
          :name => raw_info['name'],
          :avatar_url => (raw_info["avatar"].select{ |h| h["type"] == "main" }.first || {})["url"]
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        access_token.options[:mode] = :query
        access_token.options[:param_name] = 'access_token'
        # @raw_info ||= access_token.post("https://api.renren.com/restserver.do", :params => { method: 'users.getProfileInfo', uid: uid, v: '1.0', format: 'json' }).parsed
        # p @raw_info
        @raw_info ||= access_token.params["user"]
      end
    end
  end
end
