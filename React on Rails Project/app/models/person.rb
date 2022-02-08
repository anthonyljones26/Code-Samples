require 'tide/models'
require 'portal/careaware_api'

class Person < Tide::Models::Base
  class Alias < Tide::Models::Base
    STRUCTURE = {
      alias: {
        type: :String,
        json_key: :alias,
        value: ''
      },
      type: {
        type: :String,
        json_key: :alias_type,
        value: ''
      },
      pool: {
        type: :String,
        json_key: :alias_pool,
        value: ''
      }
    }.freeze

    attr_accessor :alias,
                  :type,
                  :pool
  end

  STRUCTURE = {
    first_name: {
      type: :String,
      json_key: :first_name,
      value: ''
    },
    last_name: {
      type: :String,
      json_key: :last_name,
      value: ''
    },
    mill_person_id: {
      type: :String,
      json_key: :millennium_person_id,
      value: ''
    },
    date_of_birth: [
      {
        type: :Date,
        json_key: :date_of_birth,
        value: nil
      },
      {
        type: :Date,
        json_key: :birthday,
        value: nil
      }
    ],
    is_user: {
      type: :TrueClass,
      json_key: :is_user,
      value: false
    },
    aliases: {
      type: 'Person::Alias',
      json_key: :aliases,
      value: []
    },
    health_plans: {
      type: 'Portal::CareawareApi::Model::Mobjects::HealthPlan',
      json_key: :health_plans,
      value: []
    },
    health_plans_success: {
      type: :TrueClass,
      json_key: :health_plans_success,
      value: false
    }
  }.freeze

  attr_accessor :first_name,
                :last_name,
                :mill_person_id,
                :date_of_birth,
                :is_user,
                :aliases

  def name
    "#{@first_name} #{@last_name}"
  end

  def mrn
    Integer @aliases.select { |value| value.type == 'MRN' }&.first&.alias, 10
  rescue StandardError
    nil
  end

  def valid?
    health_plans.present?
  end

  def health_plan_names
    health_plans&.map { |health_plan| health_plan.name }
  end

  def only_mu_plans?
    return unless @health_plans_success

    mu_count = health_plans.count { |element| APP_CONFIG['mu_insurance_ids'].include? element.id }
    mu_count == health_plans.length
  end

  def age
    dob = @date_of_birth
    now = Time.current.to_date
    now.year - dob.year - (now.month > dob.month || (now.month == dob.month && now.day >= dob.day) ? 0 : 1)
  end

  private

  def health_plans
    @health_plans = retrieve_health_plans unless @health_plans_success
    @health_plans
  end

  def retrieve_health_plans
    health_plan_list = Portal::CareawareApi::Services::Mobjects::HealthPlans.retrieve_user_health_plans(@mill_person_id)
    @health_plans_success = !health_plan_list.nil?
    health_plan_list.delete_if { |element| APP_CONFIG['self_pay_insurance_ids'].include?(element.id) }
  rescue StandardError
    @health_plans_success = false
    nil
  end
end
