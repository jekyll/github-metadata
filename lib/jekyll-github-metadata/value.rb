require "json"

module Jekyll
  module GitHubMetadata
    class Value
      attr_reader :key, :value

      def initialize(*args)
        case args.size
        when 1
          @key = "{anonymous}"
          @value = args.first
        when 2
          @key = args.first.to_s
          @value = args.last
        else
          raise ArgumentError, "#{args.size} args given but expected 1 or 2"
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
                     raise ArgumentError, "Whoa, arity of 0, 1, or 2 please in your procs."
                   end
                 else
                   @value
                 end
        @value = Sanitizer.sanitize(@value)
      rescue RuntimeError, NameError => e
        Jekyll::GitHubMetadata.log :error, "Error processing value '#{key}':"
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
        when nil
          nil
        when true, false
          value
        when Hash
          value
        when String, Numeric, Array
          value
        else
          to_json
        end
      end
    end
  end
end
