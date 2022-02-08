require_relative './address'
require 'tide/models'
class RefillData < Tide::Models::Base
  STRUCTURE = {
    payment_method: {
      type: :String,
      json_key: :paymentMethod,
      value: ''
    },
    recent_visit: {
      type: :TrueClass,
      json_key: :recentVisit,
      value: nil
    },
    delivery_method: {
      type: :String,
      json_key: :deliveryMethod,
      value: ''
    },
    address: {
      type: :Address,
      json_key: :address,
      value: nil
    }
  }.freeze

  attr_accessor :payment_method,
                :recent_visit,
                :delivery_method,
                :address

  def valid?
    !(@payment_method.blank? || @recent_visit.nil? || @delivery_method.blank?) && @address.valid?
  end
end
