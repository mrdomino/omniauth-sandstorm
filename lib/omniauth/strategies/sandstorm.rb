# Copyright 2016 Steven Dee
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#     Unless required by applicable law or agreed to in writing, software
#     distributed under the License is distributed on an "AS IS" BASIS,
#     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#     See the License for the specific language governing permissions and
#     limitations under the License.

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
        sandstorm_header(:user_id) || "anon-#{SecureRandom.hex(16)}"
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
