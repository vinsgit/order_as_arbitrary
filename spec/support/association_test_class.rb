class AssociationTestClass < ApplicationRecord
  extend OrderAsArbitrary
  belongs_to :test_class
end