# frozen_string_literal: true

module Scholarsphere
  module Client
    class Collection
      attr_reader :metadata, :depositor, :permissions, :work_noids

      # @param metadata [Hash] Attributes for the collection
      # @param depositor [String] Access ID of the depositor
      # @param permissions [Hash] Additional permissions for the collection (optional)
      # @param work_noids [Array<String>] List of of identifiers for works that belong to the collection
      def initialize(metadata:, depositor:, permissions: {}, work_noids: [])
        @metadata = metadata
        @depositor = depositor
        @permissions = permissions
        @work_noids = work_noids
      end

      def create
        connection.post do |req|
          req.url 'collections'
          req.body = {
            metadata: metadata,
            depositor: depositor,
            permissions: permissions,
            work_noids: work_noids
          }.to_json
        end
      end

      private

        def connection
          Scholarsphere::Client.connection
        end
    end
  end
end
