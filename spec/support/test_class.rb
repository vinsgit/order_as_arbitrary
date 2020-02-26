class TestClass < ApplicationRecord
  extend OrderAsArbitrary

  has_one :association_test_class
end