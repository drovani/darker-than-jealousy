module Stackbit

  module Filters

    def if(input, if_true, if_false)
        return input ? if_true : if_false
    end

    def starts_with(input, str)
      return input.start_with?(str)
    end

    def ends_with(input, str)
      return input.end_with?(str)
    end

    def link(input)
      relative_path = input.strip

      return relative_path if relative_path.start_with?("#")

      site = @context.registers[:site]

      site.each_site_file do |item|
        return item.url if item.relative_path == relative_path
        # This takes care of the case for static files that have a leading /
        return item.url if item.relative_path == "/#{relative_path}"
      end

      raise ArgumentError, <<~MSG
        Could not find document '#{relative_path}' in 'link' filter.

        Make sure the document exists and the path is correct.
      MSG
    end

    class Cycler < Liquid::Drop

      def initialize(values)
        @values = values
        @counter = 0
      end

      def next
        res = @values[@counter % @values.length]
        @counter += 1
        return res
      end

    end

    def cycler(input, delimiter = " ")
        return Cycler.new(input.split(delimiter, -1))
    end

  end

end

Liquid::Template.register_filter(Stackbit::Filters)
