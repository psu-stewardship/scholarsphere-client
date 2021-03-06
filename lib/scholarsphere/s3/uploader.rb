# frozen_string_literal: true

module Scholarsphere
  module S3
    ##
    #
    # Uploads a file to Scholarsphere's AWS S3 instance. When upload is invoked, a pre-signed URL is requested from
    # Scholarsphere, and if successful, the file is then uploaded to Scholarsphere using the url.
    #
    # An md5 hash is calculated for the file at initialization to ensure the file is transferred successfully.
    #
    # # Example
    #
    #     uploaded_file = Scholarsphere::S3::UploadedFile.new('path/to/file')
    #     uploader = Scholarsphere::S3::Uploader(file: uploaded_file)
    #     response = uploader.upload
    #
    class Uploader
      # @param file [UploadedFile]
      def initialize(file:)
        @file = file
        @content_md5 = file.content_md5
      end

      # @return [Faraday::Response] The response from Scholarsphere to the upload request.
      def upload
        raise Client::Error.new(request.body) unless request.success?

        request
      end

      private

        attr_reader :file, :content_md5

        def request
          @request ||= connection(file.presigned_url).put do |req|
            req.body = file.source.read
            req.headers['Content-MD5'] = file.content_md5
          end
        end

        def connection(url)
          Faraday::Connection.new(
            url: url,
            ssl: { verify: Scholarsphere::Client.verify_ssl? }
          )
        end
    end
  end
end
