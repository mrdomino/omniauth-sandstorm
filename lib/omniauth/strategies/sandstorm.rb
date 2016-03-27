require 'omniauth'

module OmniAuth
  module Strategies
    class Sandstorm
      include OmniAuth::Strategy

      option :name, 'sandstorm'

      def request_phase
        # Do nothing?
      end

      uid do
        request.headers['X-Sandstorm-User-Id']
      end

      info do
        pronoun = case request.headers['X-Sandstorm-User-Pronouns']
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
          name: request.headers['X-Sandstorm-Username'],
          nickname: request.headers['X-Sandstorm-Preferred-Handle'],
          image: request.headers['X-Sandstorm-User-Picture'],
          urls: {
            'User Pronouns': "https://pronoun.is/#{pronoun}"
          },
        }
      end

      extra do
        # Fields from https://docs.sandstorm.io/en/latest/developing/auth/
        %w(
          username user_id tab_id permissions preferred_handle user_picture
          user_pronouns
        ).inject({}) do |hash, field|
          header_name = 'X-Sandstorm-' +
            field.to_s.split('_').map(&:capitalize).join('-')
          hash[field] = request.headers[header_name]
          hash
        end
      end
    end
  end
end
