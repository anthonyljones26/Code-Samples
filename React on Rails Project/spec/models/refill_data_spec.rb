RSpec.describe RefillData do
  subject { described_class }

  context 'default new' do
    before(:each) do
      @refill_data = subject.new
    end

    it 'defaults refill_data.payment_method to \'\' when initialized' do
      expect(@refill_data.payment_method).to eq('')
    end

    it 'defaults refill_data.recent_visit to nil when initialized' do
      expect(@refill_data.recent_visit).to eq(nil)
    end

    it 'defaults refill_data.delivery_method to \'\' when initialized' do
      expect(@refill_data.delivery_method).to eq('')
    end

    it 'defaults refill_data.address to nil when initialized' do
      expect(@refill_data.address).to eq(nil)
    end
  end

  context 'setting up new refill_data model' do
    before(:each) do
      address = {
        streetAddress1: '1234 Rosemary Lane',
        streetAddress2: 'APT 101',
        city: 'Columbia',
        state: 'MO',
        zipcode: '65203',
        country: 'United States'
      }

      @refill_data = subject.new(
        paymentMethod: 'MasterCard',
        recentVisit: true,
        deliveryMethod: 'quadcopter',
        address: Address.new(address)
      )
    end

    it 'properly assigns refill_data.payment_method to given value \'MasterCard\'' do
      expect(@refill_data.payment_method).to be_kind_of(String)
      expect(@refill_data.payment_method).to eq('MasterCard')
    end

    it 'properly assigns refill_data.recent_visit to given value true' do
      expect(@refill_data.recent_visit).to be_kind_of(TrueClass)
      expect(@refill_data.recent_visit).to eq(true)
    end

    it 'properly assigns refill_data.delivery_method to given value \'quadcopter\'' do
      expect(@refill_data.delivery_method).to be_kind_of(String)
      expect(@refill_data.delivery_method).to eq('quadcopter')
    end

    it 'properly assigns refill_data.address to given address' do
      expect(@refill_data.address).to be_kind_of(Address)
      expect(@refill_data.address.street_address1).to eq('1234 Rosemary Lane')
    end
  end
end
