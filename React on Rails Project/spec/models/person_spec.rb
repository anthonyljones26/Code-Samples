require 'date'

RSpec.describe Person do
  subject { described_class }
  context 'default new' do
    before(:each) do
      @person = subject.new
    end

    it 'defaults person.first_name to \'\' when initialized' do
      expect(@person.first_name).to eq('')
    end

    it 'defaults person.last_name to \'\' when initialized' do
      expect(@person.last_name).to eq('')
    end

    it 'defaults person.mill_person_id to \'\' when initialized' do
      expect(@person.mill_person_id).to eq('')
    end

    it 'defaults person.date_of_birth to nil when initialized' do
      expect(@person.date_of_birth).to eq(nil)
    end

    it 'defaults person.is_user to false when initialized' do
      expect(@person.is_user).to eq(false)
    end

    it 'defaults person.aliases to [] when initialized' do
      expect(@person.aliases).to eq([])
    end
  end

  context 'setting up new person model' do
    before(:each) do
      @person = subject.new(
        first_name: 'John',
        last_name: 'Doe',
        millennium_person_id: 'ABC123',
        date_of_birth: Date.new(2001, 2, 3),
        is_user: true,
        aliases: [
          Person::Alias.new(
            alias: 'Johnny',
            alias_type: 'Nickname',
            alias_pool: 'string'
          )
        ]
      )
    end

    it 'properly assigns person.first_name to given value \'John\'' do
      expect(@person.first_name).to be_kind_of(String)
      expect(@person.first_name).to eq('John')
    end

    it 'properly assigns person.last_name to given value of \'Doe\'' do
      expect(@person.last_name).to be_kind_of(String)
      expect(@person.last_name).to eq('Doe')
    end

    it 'properly assigns person.millennium_person_id to given value of \'ABC123\'' do
      expect(@person.mill_person_id).to be_kind_of(String)
      expect(@person.mill_person_id).to eq('ABC123')
    end

    it 'properly assigns person.date_of_birth given value of \'02/03/2001\'' do
      expect(@person.date_of_birth).to be_kind_of(Date)
      expect(@person.date_of_birth.strftime('%m/%d/%Y')).to eq('02/03/2001')
    end

    it 'properly assigns person.is_user to true' do
      expect(@person.is_user).to be_kind_of(TrueClass)
      expect(@person.is_user).to eq(true)
    end

    it 'properly assigns person.aliases to given values' do
      expect(@person.aliases).to be_kind_of(Array)
      expect(@person.aliases[0].alias).to eq('Johnny')
      expect(@person.aliases[0].type).to eq('Nickname')
      expect(@person.aliases[0].pool).to eq('string')
    end
  end
end
