require "lita"

module Lita
  module Handlers
    class Animate < Handler
      URL = "https://www.googleapis.com/customsearch/v1/"
      VALID_SAFE_VALUES = %w(high medium off)

      config :safe_search, types: [String, Symbol], default: :high do
        validate do |value|
          unless VALID_SAFE_VALUES.include?(value.to_s.strip)
            "valid values are :high, :medium, or :off"
          end
        end
      end

      config :cse_key
      config :cse_cx
      
      route(/(?:animate|gif|anim)(?:\s+me)? (.+)/i, :fetch, command: true, help: {
        "animate QUERY" => "animate everything"
      })

      def fetch(response)
        query = "#{response.matches[0][0]} animated gif"
        
        http_response = http.get(
          URL,
          key: config.cse_key,
          cx: config.cse_cx,
          q: query,
          safe: config.safe_search,
          num: 8,
          start: rand(1..100),
          imgSize: "medium",
          searchType: "image",
          fileType: "gif"
        )
        
        data = MultiJson.load(http_response.body)

        if http_response.status == 200
          choice = data["items"].sample
          if choice
            response.reply ensure_extension(choice["link"])
          else
            response.reply %{No images found for "#{query}".}
          end
        else
          Lita.logger.warn(
            "Couldn't get image from Google, sorry!"
          )
        end
      end

      private

      def ensure_extension(url)
        if [".gif"].any? { |ext| url.end_with?(ext) }
          url
        else
          "#{url}#.gif"
        end
      end
    end

    Lita.register_handler(Animate)
  end
end
