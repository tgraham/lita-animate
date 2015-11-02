module Lita
  module Handlers
    class Animate < Handler
      attr_accessor :lita_response, :search_query, :search_response, :search_results, :gif

      URL = "https://ajax.googleapis.com/ajax/services/search/images"

      route(/(?:animate|gif|anim)(?:\s+me)? (.+)/i, :init, command: true, help: {
        "animate QUERY" => "animate everything"
      })

      def self.default_config(handler_config)
        handler_config.safe_search = :active
      end

      def init(response)
        self.lita_response = response
        fetch
      end

      def fetch
        self.search_query = "#{lita_response.matches[0][0]} gif"
        self.search_response = query_google
        self.search_results = MultiJson.load(search_response.body)

        if valid_response?
          reply
        else
          invalid_reply
        end
      end

      private

      def invalid_reply
        reason = search_response["responseDetails"] || "unknown error"
        Lita.logger.warn(
          "Couldn't get image from Google: #{reason}"
        )
        lita_response.reply "(facepalm) An error has occurred when querying Google. Please check Lita's logs."
      end

      def reply
        if gif
          lita_response.reply "#{gif["unescapedUrl"]}"
        else
          lita_response.reply "No gifs found for '#{search_query}' (shrug)."
        end
      end

      def gif
        @gif ||= parse_gif_response
      end

      def parse_gif_response
        search_results["responseData"]["results"].shuffle.each do |result|
          if  /^((?!jpg|jpeg|png).)*.gif$/i.match(result["unescapedUrl"])
            return result
          end
        end
        nil
      end

      def valid_response?
        search_results["responseStatus"] == 200
      end

      def safe_value
        safe = Lita.config.handlers.animate.safe_search || "active"
        safe = safe.to_s.downcase
        safe = "active" unless ["active", "moderate", "off"].include?(safe)
        safe
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
