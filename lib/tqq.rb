require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Tqq < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, "tqq"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, { 
        :site              =>   'https://open.t.qq.com',
        :authorize_url     =>   '/cgi-bin/oauth2/authorize',
        :token_url         =>   '/cgi-bin/oauth2/access_token'
      }

      option :authorize_params, {
        :redirect_uri => Setting.tqq_callback_url
      } 

      option :token_params, {
        # SET :parse because weibo oauth2 access_token response with "content-type"=>"text/plain;charset=UTF-8",
        # and when you use ruby 1.8.7, the response body was not a valid HASH (see: https://github.com/intridea/oauth2/issues/75)
        # :body=>"{\"access_token\":\"2.001FOK5CacB2wCc20a59773d0uSGnj\",\"expires_in\":86400,\"uid\":\"2189335154\"}"}
        :parse => :query
      }      

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid { raw_info['data']['openid'] }

      info do
        {
          :nickname => raw_info['data']['nick'],
          :name => raw_info['data']['name'],
          :avatar_url => raw_info['data']['head'] << "/180.jpg"
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        # SET :mode because by default it will use :header option, and send out header like
        # opts[:headers]={"Authorization"=>"Bearer 2.001FOK5CacB2wCc20a59773d0uSGnj"}
        # this doesn't align with weibo API (see: http://open.weibo.com/wiki/2/account/get_uid)
        access_token.options[:mode] = :query
        access_token.options[:param_name] = 'access_token'
        @uid ||= access_token.params["openid"]
        query_params = { 
          format: 'json', 
          oauth_consumer_key: Setting.tqq_key, 
          access_token: access_token.token,
          openid: @uid, 
          clientip: Setting.tqq_clientip, 
          oauth_version: '2.a', 
          scope: 'all'
        }.to_query
        response ||= access_token.get("https://open.t.qq.com/api/user/info?#{query_params}").response.env[:body]
        @raw_info = (JSON.parse(response || '{}')) rescue {}
        @raw_info
      end
    end
  end
end
