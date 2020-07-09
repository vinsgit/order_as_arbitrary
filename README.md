# OrderAsArbitrary
OrderAsArbitrary adds the ability for ActiveRecord to query for the results in the specified order

It's as easy as:

```ruby
class TestObject
  extend OrderAsArbitrary
end

TestObject.order_as_name(["Irelia", "Yummi", "Akali", "Soraka"])
=> #<ActiveRecord::Relation [
     #<TestObject id: 4, name: "Irelia">,
     #<TestObject id: 2, name: "Yummi">,
     #<TestObject id: 1, name: "Akali">,
     #<TestObject id: 3, name: "Soraka">
   ]>
``` 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'order_as_arbitrary'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install order_as_arbitrary

## Usage

Basic usage:
```ruby
class TestObject
  extend OrderAsSpecified
end

TestObject.order_as_name(["Irelia", "Yummi", "Akali", "Soraka"])
=> #<ActiveRecord::Relation [
     #<TestObject id: 4, name: "Irelia">,
     #<TestObject id: 2, name: "Yummi">,
     #<TestObject id: 1, name: "Akali">,
     #<TestObject id: 3, name: "Soraka">
   ]>
``` 

This returns all TestObjects in the given name order.
Because its an `ActiveRecord` relation, it can be chained like this:

```ruby
TestObject.
  where(name: ["Yummi", "Akali", "Soraka"]).
  order_as_name(["Yummi", "Akali", "Soraka"]).limit(3)
=> #<ActiveRecord::Relation [
     #<TestObject id: 2, name: "Yummi">,
     #<TestObject id: 1, name: "Akali">,
     #<TestObject id: 3, name: "Soraka">
   ]>
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vinsgit/order_as_arbitrary. 
