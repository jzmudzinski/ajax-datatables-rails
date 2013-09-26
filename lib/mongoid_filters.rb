
module Mongoid
  module Filters
    extend ActiveSupport::Concern

    module ClassMethods
      def filter(attrs)

        attrs.each do |method|
          eval "attr_accessor :#{method}_gte, :#{method}_lte, :#{method}_eq, :#{method}_is_null, :#{method}_is_not_null"
        end

        def filter_criteria(filters = nil)
            f = {}
            if filters.present?
              filters.each_pair do |k,v|
                match = k.match(/\b(\w*)_(gte|lte|eq|is_null|is_not_null)\b/)
                if match[2] == "eq"
                  f.merge!({"#{match[1]}" => v})
                elsif match[2] == "is_null"
                  f.merge!({"#{match[1]}" => nil }) if v.to_i == 1 || v == true || v == "true"
                elsif match[2] == "is_not_null"
                  f.merge!({"#{match[1]}" => {"$ne" => nil} }) if v.to_i == 1 || v == true || v == "true"
                else
                  f.each_pair{|k,v| found_key = k if k.to_s == match[1] && v.class.name == "Hash"}
                  if found_key
                    f[found_key].merge!({"$#{match[2]}" => v})
                  else
                    f.merge!({"#{match[1]}" => {"$#{match[2]}" => v}})
                  end
                end
              end
            end
            f
          end
      end
    end
  end
end
