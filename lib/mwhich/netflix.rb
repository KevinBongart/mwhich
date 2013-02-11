module MWhich
  module Services
    class Netflix

      def initialize(options={})
        @endpoint = "http://odata.netflix.com/v2/Catalog/"
        @format = "json"
      end

      def search(title)
        data = request(title)

        results = data['d']['results'].map do |r|
          {
            'title' => r['Name'],
            'url' => r['Url'],
            'instant' => r['Instant']['Available']
          }
        end

        results
      end

      protected

        def request(title)
          filter = "Name eq '#{title}'"
          url = "#{@endpoint}Titles?$filter=#{URI::escape(filter)}&$format=#{@format}"

          response = Net::HTTP.get_response(URI.parse(url))
          Yajl::Parser.parse(response.body)
        end

    end
  end
end