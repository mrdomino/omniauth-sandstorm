require 'omniauth'
require 'uri'

module OmniAuth
  module Strategies
    class Sandstorm
      include OmniAuth::Strategy

      option :name, 'sandstorm'

      def request_phase
        redirect callback_path
      end

      def sandstorm_header(field)
        raw_header = request.env["HTTP_X_SANDSTORM_#{field.to_s.upcase}"]
        if field == :username
          URI.unescape(raw_header).force_encoding(Encoding::UTF_8)
        else
          raw_header.nil? ? nil : raw_header.encode(Encoding::UTF_8)
        end
      end

      uid do
        sandstorm_header :user_id
      end

      info do
        pronouns = case sandstorm_header :user_pronouns
                   when 'male'
                     'he'
                   when 'female'
                     'she'
                   when 'robot'
                     'it'
                   else
                     'they'
                   end
        {
          name: sandstorm_header(:username),
          nickname: sandstorm_header(:preferred_handle),
          image: sandstorm_header(:user_picture),
          urls: {
            'User Pronouns': "https://pronoun.is/#{pronouns}",
          },
        }
      end

      extra do
        # Fields from https://docs.sandstorm.io/en/latest/developing/auth/
        %i(
          username user_id tab_id permissions preferred_handle user_picture
          user_pronouns
        ).inject({}) do |hash, field|
          hash[field] = sandstorm_header field
          hash
        end
      end
    end
  end
end
