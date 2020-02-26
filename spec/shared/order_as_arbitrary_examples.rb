require "support/application_record"
require "support/test_class"
require "support/association_test_class"

RSpec.shared_examples ".order_as_arbitrary" do
  # Clean up after each test. This is a lot lighter for these few tests than
  # trying to wrangle with RSpec-Rails to get transactional tests to work.
  after :each do
    TestClass.delete_all
    AssociationTestClass.delete_all
  end

  let(:shuffled_objects) do
    Array.new(5) { |i| TestClass.create(field: "Field #{i}") }.shuffle
  end
  let(:shuffled_object_fields) { shuffled_objects.map(&:field) }
  let(:shuffled_object_ids) { shuffled_objects.map(&:id) }
  let(:omitted_object) { TestClass.create(field: "Nothing") }

  context "with no table name specified" do
    subject { TestClass.order_as_field( shuffled_object_fields) }
    it "returns results  including unspecified objects" do
      omitted_object # Build an object that isn't sorted in this list.
      expect(subject).to include omitted_object
    end

    it "returns results in the given order" do
      omitted_object # Build an object that isn't sorted in this list.
      expect(subject.map(&:id)).to eq [*shuffled_object_ids, omitted_object.id]
    end

    context "when the order is chained with other orderings" do
      subject do
        TestClass.order_as_field(shuffled_object_fields.take(3)).order(:id)
      end

      it "returns results in the given order by multiple fields" do
        shuffled_objects # Build these objects first.
        omitted_object # Build an object that isn't sorted in this list.
        expect(subject.map(&:id)).to eq [
                                            *shuffled_object_ids.take(3),
                                            *shuffled_object_ids.drop(3).sort,
                                            omitted_object.id
                                        ]
      end
    end
  end

  context "when the order is empty array" do
    subject { TestClass.order_as_id([]) }

    let(:test_objects) do
      Array.new(5) do |i|
        TestClass.create(field: "Field #{i}")
      end
    end

    it "keep the original order" do
      test_objects # Build test objects
      expect(subject.map(&:id)).
          to eq test_objects.map(&:id)
    end
  end

  context "when the order is a range" do
    subject do
      TestClass.order_as_number_field(ranges)
    end

    let(:ranges) { [(3..4), (0..2)] }
    let(:numbers) { [0.0, 1.0, 2.0, 3.0, 4.0] }

    let!(:test_objects) do
      numbers.each do |i|
        TestClass.create(number_field: i)
      end
    end

    it "sorts according to range" do
      expect(subject.map(&:number_field)).to eq [
                                                    *numbers.drop(3),
                                                    *numbers.take(3)
                                                ]
    end

    context "reverse ranges" do
      let(:ranges) { [(5..0)] }

      it "raises an error" do
        expect { subject }.to raise_error(OrderAsArbitrary::Error)
      end
    end

    context "exclusive ranges" do
      let(:numbers) { [0.0, 1.0, 2.0, 3.0, 4.0, 0.9, 1.5] }

      let(:ranges) { [(1...2), (0...1), (2...5)] }
      it "sorts according to range" do
        expect(subject.map(&:number_field)).to eq [1.0, 1.5, 0.0, 0.9, 2.0, 3.0, 4.0]
      end
    end

  end

  context "invalid hash input" do
    subject { TestClass.order_as_id({}) }

    it "raises an error" do
      expect { subject }.to raise_error(OrderAsArbitrary::Error)
    end
  end
end