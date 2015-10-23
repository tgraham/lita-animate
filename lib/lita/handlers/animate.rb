module Lita
  module Handlers
    class Animate < Handler
      attr_accessor :search_query

      URL = "https://ajax.googleapis.com/ajax/services/search/images"

      route(/(?:animate|gif|anim)(?:\s+me)? (.+)/i, :fetch, command: true, help: {
        "animate QUERY" => "animate everything"
      })

      def self.default_config(handler_config)
        handler_config.safe_search = :active
      end

      def fetch(response)
        self.search_query = "#{response.matches[0][0]} gif"

        search_response = query_google

        search_payload = MultiJson.load(search_response.body)

        if search_payload["responseStatus"] == 200
          choice = nil

          search_payload["responseData"]["results"].shuffle.each do |result|
            if valid_extension?(result["unescapedUrl"])
              choice = result
              break
            end
          end

          if choice
            response.reply "#{choice["unescapedUrl"]}"
          else
            response.reply "No gifs found for '#{search_query}' (shrug)."
          end
        else
          reason = search_payload["responseDetails"] || "unknown error"
          Lita.logger.warn(
            "Couldn't get image from Google: #{reason}"
          )
          response.reply "(facepalm) An error has occurred when querying Google. Please check Lita's logs."
        end
      end

      private

      def safe_value
        safe = Lita.config.handlers.animate.safe_search || "active"
        safe = safe.to_s.downcase
        safe = "active" unless ["active", "moderate", "off"].include?(safe)
        safe
      end

      def valid_extension?(result)
        if /^.*\.(jpg|png|jpeg)/i.match(result)
          false
        elsif /.*\.gif$/.match(result)
          true
        else
          false
        end
      end

      def query_google
        Faraday.get(
          URL,
          v: "1.0",
          q: search_query,
          safe: safe_value,
          rsz: 8,
          imgtype: "animated"
        )
      end
    end

    Lita.register_handler(Animate)
  end
end
