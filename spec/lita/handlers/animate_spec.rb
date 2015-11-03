describe Lita::Handlers::Animate, lita_handler: true do
  describe "#animate" do
    it "should return a gif" do
      http_response_struct = OpenStruct.new(body: File.read("spec/fixtures/200_has_gif.json"))
      allow(Faraday).to receive(:get).and_return(http_response_struct)

      send_command("animate me waffles")

      expect(replies.last).to match(/.*\.gif$/)
    end

    it "should return a gif" do
      http_response_struct = OpenStruct.new(body: File.read("spec/fixtures/200_has_gif.json"))
      allow(Faraday).to receive(:get).and_return(http_response_struct)

      send_command("animate me waffles batman ninja")

      expect(replies.last).to match(/.*\.gif$/)
    end

    it "should not return any gifs if google only returns images or file paths with image extensions in them" do
      http_response_struct = OpenStruct.new(body: File.read("spec/fixtures/200_photos_only.json"))
      allow(Faraday).to receive(:get).and_return(http_response_struct)

      send_command("animate me waffles")

      expect(replies.last).to match("No gifs found for 'waffles gif' (shrug).")
    end

    it "should return an error if a non-200 code is raised" do
      http_response_struct = OpenStruct.new(body: File.read("spec/fixtures/500_bad_response.json"))
      allow(Faraday).to receive(:get).and_return(http_response_struct)

      send_command("animate me waffles")

      expect(replies.last).to match("(facepalm) An error has occurred when querying Google. Please check Lita's logs.")
    end
  end
end

