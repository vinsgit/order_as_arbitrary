# VersionedMigration = ActiveRecord::Migration[ActiveRecord::VERSION::STRING.to_f] # rubocop:disable Metrics/LineLength
class TestSetupMigration <  ActiveRecord::Migration[6.0]
  def up
    db_connection = ActiveRecord::Base.connection
    return if db_connection.try(:data_source_exists?, :test_classes)

    create_table :test_classes do |t|
      t.string :field
      t.float :number_field
    end

    create_table :association_test_classes do |t|
      t.integer :test_class_id
    end
  end

  def down
    drop_table :test_classes
    drop_table :association_test_classes
  end
end