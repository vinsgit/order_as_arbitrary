require "order_as_arbitrary/version"
require "order_as_arbitrary/error"
module OrderAsArbitrary
  def method_missing(name, *args)
    method_name = get_method_name(name)
    if method_name
      check_arguments(args)
      self.class.send(:define_method, "#{method_name[0]}") do |values|
        column_name = get_method_name(__method__)[1]
        if values.is_a? Array
          if values.empty?
            return all
          elsif values.first.is_a? Range
            conditions = range_clause(column_name, values)
          else
            conditions = array_clause(column_name, values)
          end
          order_sql = "CASE #{conditions.join(' ')} ELSE #{conditions.size} END"
          order(Arel.sql(order_sql))
        else
          raise OrderAsArbitrary::Error, "Only accept array"
        end
      end
      send(method_name[0], args.first)
    else
      super
    end
  end

  private

  def check_arguments(args)
    raise OrderAsArbitrary::Error, "Wrong number of arguments "  if args.empty?
  end

  def get_method_name(name)
    name.to_s.match(/^order_as_(\w*)/)
  end

  def range_clause(column_name, values)
    values = values.each_with_index.map do |range, index|
      raise OrderAsArbitrary::Error, "Range needs to be increasing" if range.first >= range.last
      op = range.exclude_end? ? "<" : "<="
      "WHEN #{column_name} >= #{range.first} AND #{column_name} #{op} #{range.last} THEN #{index}"
    end
    values
  end

  def array_clause(column_name, values)
    values = values.each_with_index.map do |value, index|
      raise OrderAsArbitrary::Error, "Cannot order by `nil`" if value.nil?
      "WHEN #{column_name} = '#{value}' THEN #{index}"
    end
    values
  end

end
