# frozen_string_literal: true

RSpec.describe(Jekyll::GitHubMetadata::Value) do
  let(:simple_value)  { described_class.new(proc { "a value" }) }
  let(:number_value)  { described_class.new(4) }
  let(:string_value)  { described_class.new("petunia my dear") }
  let(:array_value)   { described_class.new(%(oy you there)) }
  let(:hash_value)    { described_class.new("hello" => "world") }
  let(:complex_value) { described_class.new(proc { %w(hi there petunia) }) }

  let(:nil_value_without_key) { described_class.new(nil) }
  let(:nil_value_with_key) { described_class.new("my_key", nil) }
  let(:key_and_value)      { described_class.new("my_key2", proc { "leonard told me" }) }

  it "takes in a value and stores it" do
    v = described_class.new("some_value")

    expect(v.value).to eql("some_value")
  end

  it "knows how to turn itself into a string" do
    expect(simple_value.to_s).to eql("a value")
  end

  it "knows how to turn itself into liquid" do
    expect(simple_value.to_liquid).to eql("a value")
    expect(complex_value.to_liquid).to eql(%w(hi there petunia))
  end

  context "with a proc value" do
    it "can resolve its value" do
      expect(complex_value.render).to eql(%w(hi there petunia))
    end

    it "sets the value of @value to the resolved value" do
      expect(complex_value.value).to be_a(Proc)
      complex_value.render
      expect(complex_value.value).to eql(%w(hi there petunia))
    end
  end

  it "does not modify a string value" do
    expect(string_value.render).to eql("petunia my dear")
  end

  it "does not modify an integer value" do
    expect(number_value.render).to eql(4)
  end

  it "does not modify an array value" do
    expect(array_value.render).to eql(%(oy you there))
  end

  it "does not modify a hash value" do
    expect(hash_value.render).to eql("hello" => "world")
  end

  it "accepts a nil value with no key" do
    expect(nil_value_without_key.key).to eql("{anonymous}")
    expect(nil_value_without_key.render).to be_nil
  end

  it "accepts a nil value with a non-nil key" do
    expect(nil_value_with_key.key).to eql("my_key")
    expect(nil_value_with_key.render).to be_nil
  end

  it "can accept a key and a value" do
    expect(key_and_value.key).to eql("my_key2")
    expect(key_and_value.render).to eql("leonard told me")
  end

  context "delegators" do
    it "delegates +" do
      expect(key_and_value + " foo").to eql("leonard told me foo")
    end

    it "delegates to_s" do
      expect(number_value.to_s).to eql("4")
    end

    it "delegates to_json" do
      expect(key_and_value.to_json).to eql('"leonard told me"')
    end

    it "delegates eql?" do
      expect(key_and_value).to eql("leonard told me")
    end

    it "delegates hash" do
      expect(key_and_value.hash).to eql("leonard told me".hash)
    end
  end
end
