require "airport"


describe Airport do
  let(:weather) { double :weather }
  subject(:airport) { described_class.new(weather) }

  it "has a default capacity when initialized" do
    expect(subject.capacity).to eq Airport::DEFAULT_CAPACITY
  end


  let(:plane) { double :plane }
  before { allow(plane).to receive(:land) }
  before { allow(plane).to receive(:take_off) }

  describe "#land" do
    it "lands the plane" do
      allow(weather).to receive(:stormy?).and_return(false)
      subject.land plane
      expect(subject.planes.last).to eq plane
    end

    it "prevents landing when weather is stormy" do
      allow(weather).to receive(:stormy?).and_return(true)
      message = "Landing prevented due to stormy weather"
      expect { subject.land plane }.to raise_error message
    end

    it "allows landing when weather is clear" do
      allow(weather).to receive(:stormy?).and_return(false)
      expect { subject.land plane }.not_to raise_error
    end

    it "prevents landing when airport is full" do
      allow(weather).to receive(:stormy?).and_return(false)
      message = "Airport reached its capacity"
      expect { subject.land plane while true }.to raise_error message
    end
  end

  describe "#take_off" do
    it "plane takes off from the airport" do
      allow(weather).to receive(:stormy?).and_return(false)
      subject.land plane
      subject.take_off plane
      expect(subject.planes).not_to include plane
    end

    it "prevents take-off when weather is stormy" do
      allow(weather).to receive(:stormy?).and_return(true)
      message = "Take-off prevented due to stormy weather"
      expect { subject.take_off plane }.to raise_error message
    end

    it "allows take-off when weather is clear" do
      allow(weather).to receive(:stormy?).and_return(false)
      expect { subject.take_off plane }.not_to raise_error
    end
  end


end
