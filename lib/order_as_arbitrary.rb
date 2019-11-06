require "order_as_arbitrary/version"
require "order_as_arbitrary/error"
module OrderAsArbitrary
  # @param hash [Hash] the ActiveRecord arguments hash
  # @return [ActiveRecord::Relation] the objects, ordered as specified

  def method_missing(_attribute, *args)
    _attribute = _attribute.match(/^order_as_(\w*)/)
    if attr
      binding.pry
      values = *args.first
      column_name = _attribute[1]
      method_name = _attribute[0]
      return all if values.empty?
      values = values.map do |value|
        raise OrderAsSpecified::Error, "Cannot order by `nil`" if value.nil?
        value.is_a? Range ? range_clause(value) : quote(value)
      end
      self.class.send(:define_method, "#{method_name}") do |column_name, values|
        sanitized_values_string = values.map {|value| connection.quote(value)}.join(",")
        where("#{column_name}=?", values).order("FIELD(#{column_name}, #{sanitized_values_string})")
      end
      send(method_name, column_name, values)
    else
      super
    end
  end

  private

  def range_clause(range)
    raise OrderAsSpecified::Error, "Range needs to be increasing" if range.first >= range.last
    range.to_a
  end

end
