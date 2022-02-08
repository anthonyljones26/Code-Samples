RSpec.describe Address do
  subject { described_class }
  context 'default new' do
    before(:each) do
      @address = subject.new
    end

    it 'defaults address.street_address1 to \'\' when initialized' do
      expect(@address.street_address1).to eq('')
    end

    it 'defaults address.street_address2 to \'\' when initialized' do
      expect(@address.street_address2).to eq('')
    end

    it 'defaults address.city to \'\' when initialized' do
      expect(@address.city).to eq('')
    end

    it 'defaults address.state to \'\' when initialized' do
      expect(@address.state).to eq('')
    end

    it 'defaults address.zipcode to \'\' when initialized' do
      expect(@address.zipcode).to eq('')
    end

    it 'defaults address.country to \'\' when initialized' do
      expect(@address.country).to eq('')
    end
  end

  context 'setting up new address model' do
    before(:each) do
      @address = subject.new(
        streetAddress1: '1234 Rosemary Lane',
        streetAddress2: 'APT 101',
        city: 'Columbia',
        state: 'MO',
        zipcode: '65203',
        country: 'United States'
      )
    end

    it 'address.street_address1 should equal given string' do
      expect(@address.street_address1).to be_kind_of(String)
      expect(@address.street_address1).to eq('1234 Rosemary Lane')
    end

    it 'address.street_address2 should equal given string' do
      expect(@address.street_address2).to be_kind_of(String)
      expect(@address.street_address2).to eq('APT 101')
    end

    it 'address.city should equal given string' do
      expect(@address.city).to be_kind_of(String)
      expect(@address.city).to eq('Columbia')
    end

    it 'address.state should equal given string' do
      expect(@address.state).to be_kind_of(String)
      expect(@address.state).to eq('MO')
    end

    it 'address.zipcode should equal given string' do
      expect(@address.zipcode).to be_kind_of(String)
      expect(@address.zipcode).to eq('65203')
    end

    it 'address.country should equal given string' do
      expect(@address.country).to be_kind_of(String)
      expect(@address.country).to eq('United States')
    end
  end
end
