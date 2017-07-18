describe ThemeJuice::Env do

  before do
    @env = ThemeJuice::Env
  end

  it { is_expected.to respond_to :from_path }
  it { is_expected.to respond_to :from_path= }
  it { is_expected.to respond_to :from_srv }
  it { is_expected.to respond_to :from_srv= }
  it { is_expected.to respond_to :no_unicode }
  it { is_expected.to respond_to :no_unicode= }
  it { is_expected.to respond_to :no_colors }
  it { is_expected.to respond_to :no_colors= }
  it { is_expected.to respond_to :no_animations }
  it { is_expected.to respond_to :no_animations= }
  it { is_expected.to respond_to :boring }
  it { is_expected.to respond_to :boring= }
  it { is_expected.to respond_to :yolo }
  it { is_expected.to respond_to :yolo= }
  it { is_expected.to respond_to :verbose }
  it { is_expected.to respond_to :verbose= }
  it { is_expected.to respond_to :quiet }
  it { is_expected.to respond_to :quiet= }
  it { is_expected.to respond_to :robot }
  it { is_expected.to respond_to :robot= }
  it { is_expected.to respond_to :trace }
  it { is_expected.to respond_to :trace= }
  it { is_expected.to respond_to :dryrun }
  it { is_expected.to respond_to :dryrun= }
  it { is_expected.to respond_to :stage }
  it { is_expected.to respond_to :stage= }
  it { is_expected.to respond_to :cap }
  it { is_expected.to respond_to :cap= }
  it { is_expected.to respond_to :archive }
  it { is_expected.to respond_to :archive= }
  it { is_expected.to respond_to :branch }
  it { is_expected.to respond_to :branch= }

  describe ".inspect" do
    it "should return an array of all instance variables" do
      expect(@env.inspect).to be_a Array
    end
  end

  %W[boring yolo no_unicode no_colors no_animations
    robot verbose quiet trace dryrun].each do |prop|
    describe ".#{prop}" do

      it "should expect to use the set boolean value" do
        @env.send "#{prop}=", true
        expect(@env.send(prop)).to eq true
      end

      it "should expect to use the default boolean value" do
        @env.send "#{prop}=", nil
        expect(@env.send(prop)).to eq false
      end
    end
  end
end
