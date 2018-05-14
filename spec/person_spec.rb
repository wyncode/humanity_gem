RSpec.describe Humanity::Person do

  let(:person) do
    Humanity::Person.new
  end

  it "knows how to eat" do
    expect(person.skills).to include("eating")
  end

  context "before lunch" do

    it "is hungry" do
      expect(person.tummy).to eq("grumbling")
    end

    it "is sad" do
      expect(person.emotion).to eq("sad")
    end

  end

  context "after lunch" do

    before do
      person.eat_breakfast
    end

    it "is full" do
      expect(person.tummy).to eq("full")
    end

    it "is happy" do
      expect(person.emotion).to eq("happy")
    end

  end

end
