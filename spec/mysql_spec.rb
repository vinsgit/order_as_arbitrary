require "spec_helper"
require "config/test_setup_migration"
require "shared/order_as_arbitrary_examples"


RSpec.describe "MySQL" do
  before :all do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Base.establish_connection(:mysql_test)
    TestSetupMigration.migrate(:up)
  end
  after :all do
    ActiveRecord::Base.remove_connection
    TestSetupMigration.migrate(:down)
  end

  include_examples ".order_as_arbitrary"
end