require "order_as_arbitrary/version"
require "order_as_arbitrary/error"
module OrderAsArbitrary
  def method_missing(name, *args)
    method_name = get_method_name(name)
    if method_name
      check_arguments(args)
      if args.first.is_a? Range
        values = range_clause(args.first)
      elsif args.first.is_a? Array
        values = array_clause(args.first)
      else
        raise OrderAsArbitrary::Error, "Only accept array or range"
      end
      self.class.send(:define_method, "#{method_name[0]}") do |values|
        column_name = get_method_name(__method__)[1]
        sanitized_values_string = values.map {|value| connection.quote(value)}.join(",")
        where("#{column_name} in (?)", values).order("FIELD(#{column_name}, #{sanitized_values_string})")
      end
      send(method_name[0], values)
    else
      super
    end
  end

  private

  def check_arguments(args)
    raise OrderAsArbitrary::Error, "Wrong number of arguments "  if args.empty? || args.first.nil?
  end

  def get_method_name(name)
    name.to_s.match(/^order_as_(\w*)/)
  end

  def range_clause(range)
    raise OrderAsArbitrary::Error, "Range needs to be increasing" if range.first >= range.last
    range.to_a
  end

  def array_clause(array)
    array.map do |value|
      raise OrderAsSpecified::Error, "Cannot order by `nil`" if value.nil?
      value
    end
    array
  end

end
