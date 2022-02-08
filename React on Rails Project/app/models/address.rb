require 'tide/models'

class Address < Tide::Models::Base
  STRUCTURE = {
    street_address1: {
      type: :String,
      json_key: :streetAddress1,
      value: ''
    },
    street_address2: {
      type: :String,
      json_key: :streetAddress2,
      value: ''
    },
    city: {
      type: :String,
      json_key: :city,
      value: ''
    },
    state: {
      type: :String,
      json_key: :state,
      value: ''
    },
    zipcode: {
      type: :String,
      json_key: :zipcode,
      value: ''
    },
    country: {
      type: :String,
      json_key: :country,
      value: ''
    }
  }.freeze

  attr_accessor :street_address1,
                :street_address2,
                :city,
                :state,
                :zipcode,
                :country

  def valid?
    !(@street_address1.blank? || @city.blank? || @state.blank? || @zipcode.blank?)
  end

  def to_address_str
    string = "#{@street_address1}\n"
    string += "#{@street_address2}\n" if @street_address2.present?
    string += "#{[@city, @state].join(', ')} #{@zipcode}\n"
    string += "#{@country}\n" if @country.present?
    string
  end
end
