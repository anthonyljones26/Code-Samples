require 'portal/careaware_api'
require 'portal/hco_api'

class RefillController < ApplicationController # rubocop:disable Metrics/ClassLength
  include Concerns::Relationship
  include Concerns::Embeddable

  protect_from_forgery with: :null_session, if: proc { |c| c.request.format.json? }
  after_action :update_active_user_session, only: :index

  def index
    patient_array = @all_users.map.with_index do |patient, index|
      {
        id: index,
        name: patient.name,
        select_url: user_url(index),
        health_plans: patient == @active_user ? patient.health_plan_names : [],
        isCopayAvailable: patient.only_mu_plans?,
        aliases: get_patient_aliases(patient),
        age: patient.age
      }
    end
    @refill_props = setup_props patient_array, session[:active_user_index]
  end

  def create
    return render_unprocessable_entity unless (refill_data = validate_create_input(refill_params))
    return render_forbidden unless @active_user.valid?

    ############################ DISABLE DUE TO CREATE VISIT LOGIC NOT USED UNTIL SELF PAY #############################
    # Portal::HcoApi::Services::Visits.create_visit(create_visit_request)
    ####################################################################################################################
    message = APP_CONFIG['message'].merge(patientId: @active_user.mill_person_id, text: nurse_message(refill_data))
    careaware_message = Portal::CareawareApi::Model::Millennium::Message.new(message.deep_symbolize_keys)
    Portal::CareawareApi::Services::Millennium::Messages.create_message(careaware_message)

    render_created created_response(refill_data, @active_user)
  end

  private

  def created_response(refill_data, patient)
    {
      patient: patient.name,
      requestDateTime: Time.now,
      paymentMethod: patient.only_mu_plans? ? 'MU_INSURANCE' : 'INSURANCE',
      recentVisit: refill_data.recent_visit,
      deliveryMethod: refill_data.delivery_method,
      address: refill_data.address.as_json
    }
  end

  def validate_create_input(parameters)
    return false unless @active_user == @all_users[Integer(parameters['patientIndex'])]

    refill_data = RefillData.new(parameters)
    refill_data.valid? ? refill_data : false
  rescue StandardError
    false
  end

  def refill_params
    params.require(:refill).permit(
      :patientIndex,
      :recentVisit,
      :paymentMethod,
      :deliveryMethod,
      address: [:streetAddress1, :streetAddress2, :city, :state, :zipcode, :country]
    )
  end

  def copay_amount(patient)
    patient.only_mu_plans? ? "$#{format('%.2f', APP_CONFIG['mu_copay_amount'])}" : APP_CONFIG['no_copay_amount']
  end

  def nurse_message(refill_data)
    render_to_string(
      partial: 'refill/nurse_message',
      formats: :text,
      locals: {
        payment_method: refill_data.payment_method,
        recent_visit: refill_data.recent_visit,
        amount_paid: copay_amount(@active_user),
        delivery_method: refill_data.delivery_method,
        address: refill_data.address
      }
    ).to_str
  end

  def create_visit_request
    {
      provider_number: APP_CONFIG['visit_attending_physician'],
      admission_date_time: Time.now,
      patient_MRN: @active_user.mrn,
      billing_location: APP_CONFIG['visit_billing_location']
    }
  end

  def setup_props(patients, active_user_index)
    {
      locale: I18n.locale,
      patients: patients,
      activePatient: active_user_index,
      config: {
        copayAmount: APP_CONFIG['mu_copay_amount'],
        urls: {
          schedulingUrl: MU_CONFIG['scheduling_url'],
          eVisitUrl: MU_CONFIG['e_visit'],
          allergyRefillUrl: refill_index_url
        },
        phoneNumbers: {
          allergyClinic: MU_CONFIG['phone_numbers']['allergy_clinic'],
          insuranceError: MU_CONFIG['phone_numbers']['insurance_error']
        },
        preferredAliasType: APP_CONFIG['preferred_alias_type']
      },
      dexConfig: setup_dex_config
    }
  end

  def setup_dex_config
    {
      acls: APP_CONFIG['dex_issuer_jwk_xref'].keys,
      loginUrl: APP_CONFIG['login_url'],
      detectIframe: APP_CONFIG['detect_iframe'],
      refreshToken: {
        url: refresh_token_url
      },
      bcsToken: session_bcs_token
    }
  end

  def update_active_user_session
    session[:all_users][session[:active_user_index]] = @active_user.to_array
  end

  def get_patient_aliases(patient)
    patient.aliases.map { |a| { type: a.type, alias: a.alias } }
  end
end
