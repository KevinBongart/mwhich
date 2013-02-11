module MWhich
  module Services
    class ITunes
      def initialize(options={})
        @endpoint = "http://itunes.apple.com/search"
      end

      def search(title)
        data = request(title)

        results = data['results'].map do |r|
          {
            'title' => r['trackName'],
            'url' => r['trackViewUrl'],
            'price' => r['trackPrice']
          }
        end

        results
      end

      protected

        def request(title)
          results = []

          url = "#{@endpoint}?term=#{URI::escape(title)}&media=movie"
          response = Net::HTTP.get_response(URI.parse(url))
          data = Yajl::Parser.parse(response.body)

          data
        end

    end
  end
end
