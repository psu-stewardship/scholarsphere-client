# frozen_string_literal: true

module Scholarsphere
  module Client
    ##
    #
    # Requests a pre-signed url, id, and prefix from Scholarsphere for uploading a given file. In order to generate a
    # correct path, the file's extension name is required for the request. The url is used to upload the file's binary
    # content into Scholarsphere, while the id and key are used when adding the file to a work.
    #
    class Upload
      # @param extname [String] Extension of the file to be uploaded, without the period, such as 'pdf'
      # @param content_md5 [String] This should be the same as UploadedFile.content_md5
      def initialize(extname:, content_md5:)
        @extname = extname
        @content_md5 = content_md5
      end

      # @return [String] Prefix where the file is stored in the S3 bucket.
      def prefix
        data['prefix']
      end

      # @return [String] URL for uploading the file into AWS.
      def url
        data['url']
      end

      # @return [String] A unique identifier for the file which will serve as its name in S3.
      def id
        data['id']
      end

      private

        attr_reader :extname, :content_md5

        def request
          @request ||= Scholarsphere::Client.connection.post do |req|
            req.url 'uploads'
            req.body = { extension: extname, content_md5: content_md5 }.to_json
          end
        end

        def data
          @data ||= begin
            raise Client::Error.new(request.body) unless request.success?

            JSON.parse(request.body)
          end
        end
    end
  end
end
