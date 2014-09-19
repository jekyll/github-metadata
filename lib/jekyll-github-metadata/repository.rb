module Jekyll
  module GitHubMetadata
    class Repository
      attr_reader :nwo, :owner, :name
      def initialize(name_with_owner)
        @nwo   = name_with_owner
        @owner = nwo.split("/").first
        @name  = nwo.split("/").last
      end

      def organization_repository?
        !!GitHubMetadata.client.organization(owner)
      end
    end
  end
end
