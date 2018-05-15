RSpec.describe Humanity::Person do

  let(:person) do
    Humanity::Person.new(first_name: "Andy", last_name: "Weiss")
  end

  let(:other_person) do
    Humanity::Person.new(first_name: "Other", last_name: "Person")
  end

  before do
    PG::Connection.open(dbname: 'contacts').exec("DELETE FROM people;")
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
      person.eat_lunch
    end

    it "is full" do
      expect(person.tummy).to eq("full")
    end

    it "is happy" do
      expect(person.emotion).to eq("happy")
    end

  end

  it "can persist to a database" do
    person.save

    expect(person.id).not_to eq(nil)
  end

  it "can be retrieved from a database" do
    person.save

    expect(Humanity::Person.find(person.id)).to be_a(Humanity::Person)
  end

  it "can be deleted from a database" do
    person.save

    person.delete

    expect(Humanity::Person.find(person.id)).to eq(nil)
  end

  it "can be retrieved as a collection" do
    person.save
    other_person.save

    expect(Humanity::Person.all.map(&:id)).to match_array([person.id, other_person.id])
  end

  it "can be filtered as a collecton" do
    person.save
    other_person.save

    expect(
      Humanity::Person.where(first_name: "Andy").map(&:id)
    ).to match_array([person.id])
  end

  it "can display its attributes" do
    expected = {
                  "first_name" => "Andy",
                  "last_name" => "Weiss",
                  "tummy" => "grumbling",
                  "emotion" => "sad"
                }
    expect(person.attributes).to include(expected)
  end

end
