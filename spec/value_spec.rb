RSpec.describe(Jekyll::GitHubMetadata::Value) do
  let(:simple_value)  { described_class.new(proc { 'a value' }) }
  let(:number_value)  { described_class.new(4) }
  let(:string_value)  { described_class.new('petunia my dear') }
  let(:array_value)   { described_class.new(%{oy you there}) }
  let(:hash_value)    { described_class.new({'hello' => 'world'}) }
  let(:complex_value) { described_class.new(proc { %w{hi there petunia } }) }

  it 'takes in a value and stores it' do
    v = described_class.new('some_value')

    expect(v.value).to eql('some_value')
  end

  it 'knows how to turn itself into a string' do
    expect(simple_value.to_s).to eql('a value')
  end

  it 'knows how to turn itself into liquid' do
    expect(simple_value.to_liquid).to eql('a value')
    expect(complex_value.to_liquid).to eql(%w{hi there petunia})
  end

  context 'with a proc value' do
    it 'can resolve its value' do
      expect(complex_value.render).to eql(%w{hi there petunia})
    end

    it 'sets the value of @value to the resolved value' do
      expect(complex_value.value).to be_a(Proc)
      complex_value.render
      expect(complex_value.value).to eql(%w{hi there petunia})
    end
  end

  it 'does not modify a string value' do
    expect(string_value.render).to eql('petunia my dear')
  end

  it 'does not modify an integer value' do
    expect(number_value.render).to eql(4)
  end

  it 'does not modify an array value' do
    expect(array_value.render).to eql(%{oy you there})
  end

  it 'does not modify a hash value' do
    expect(hash_value.render).to eql({'hello' => 'world'})
  end
end
