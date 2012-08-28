require "active_support"
module Mongoid
  module Filters
    extend ActiveSupport::Concern

    module ClassMethods
      def filter(attrs)

        attrs.each do |method|
          eval "attr_accessor :#{method}_gte, :#{method}_lte, :#{method}_eq"
        end

        def filter_criteria(filters = nil)
            f = {}
            if filters.present?
              filters.each_pair do |k,v|
                match = k.match(/\b(\w*)_(gte|lte|eq)\b/)
                if match[2] == "eq"
                  f.merge!({"#{match[1]}" => v})
                else
                  f.merge!({"#{match[1]}" => {"$#{match[2]}" => v}})
                end
              end
            end
            f
          end
      end
    end
  end
end