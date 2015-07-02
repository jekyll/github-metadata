require 'json'

module Jekyll
  module GitHubMetadata
    class Value
      attr_reader :key, :value

      def initialize(key, value = nil)
        if key.respond_to?(:call)
          @key = '{anonymous}'
          @value = key
        else
          @key = key.to_s
          @value = value
        end
      end

      def render
        @value = if @value.respond_to?(:call)
          case @value.arity
          when 0
            @value.call
          when 1
            @value.call(GitHubMetadata.client)
          when 2
            @value.call(GitHubMetadata.client, GitHubMetadata.repository)
          else
            raise ArgumentError.new("Whoa, arity of 0, 1, or 2 please in your procs.")
          end
        else
          @value
        end
        @value = Sanitizer.sanitize(@value)
      rescue RuntimeError, NameError => e
        Jekyll.logger.error "GitHubMetadata:", "Error processing value '#{key}':"
        raise e
      end

      def to_s
        render.to_s
      end

      def to_json(*)
        render.to_json
      end

      def to_liquid
        case render
        when String, Numeric, Array
          render
        else
          to_json
        end
      end
    end
  end
end
