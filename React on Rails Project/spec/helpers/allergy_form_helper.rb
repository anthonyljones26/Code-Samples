module PortalAllergyVials
  module AllergyFormHelper
    PAYMENT_OPTIONS = {
      insurance: 'INSURANCE'
    }.freeze

    INSURANCE_OPTIONS = {
      yes: 'INSURANCE',
      no: 'INVALID'
    }.freeze

    RECENT_VISIT_OPTIONS = {
      yes: true,
      no: false
    }.freeze

    DELIVERY_OPTIONS = {
      pickup: 'PICKUP',
      deliver: 'DELIVER'
    }.freeze

    CREATE_STATUS_OPTIONS = {
      MESSAGE: {
        CREATED: -> { { status: 201, data: '' } },
        UNPROCESSABLE: -> { raise Portal::CareawareApi::Services::Errors::UnprocessableEntityError },
        INTERNALSERVER: -> { raise Portal::CareawareApi::Services::Errors::InternalServerError }
      },
      VISIT: {
        CREATED: -> { { status: 201, data: '' } },
        UNPROCESSABLE: -> { raise Portal::HcoApi::Services::Errors::UnprocessableEntityError },
        INTERNALSERVER: -> { raise Portal::HcoApi::Services::Errors::InternalServerError }
      }
    }.freeze

    def select_payment_method(option = PAYMENT_OPTIONS[:insurance])
      find('#payment-method-select-field').click
      find("#terra-select-dropdown #terra-select-option-#{option}").click
    end

    def select_insurance(option = INSURANCE_OPTIONS[:yes])
      find('#current-insurance-select-field').click
      find("#terra-select-dropdown #terra-select-option-#{option}").click
    end

    def select_recent_visit(option = RECENT_VISIT_OPTIONS[:yes])
      find('#recent-visit-select-field').click
      find("#terra-select-dropdown #terra-select-option-#{option}").click
    end

    def select_delivery_method(option = :pickup)
      find('#delivery-method-select-field').click
      find("#terra-select-dropdown #terra-select-option-#{DELIVERY_OPTIONS[option]}").click
    end

    def fill_out_form
      select_insurance
      select_recent_visit
      select_delivery_method
    end

    def populate_delivery_field(patient_address)
      fill_in 'streetAddress1', with: patient_address.street_address1
      fill_in 'streetAddress2', with: patient_address.street_address2
      fill_in 'city', with: patient_address.city
      fill_in 'state', with: patient_address.state
      fill_in 'zipcode', with: patient_address.zipcode
      fill_in 'country', with: patient_address.country
    end

    def click_save(request_status = {})
      default_status = {
        message_status: :CREATED,
        visit_status: :CREATED
      }
      status = default_status.merge(request_status)
      mock_millennium_messages(CREATE_STATUS_OPTIONS[:MESSAGE][status[:message_status]]) do
        mock_hco_visits(CREATE_STATUS_OPTIONS[:VISIT][status[:visit_status]]) do
          click_button('Send')
          expect(page).to have_selector '.banner-container'
        end
      end
    end

    def mock_millennium_messages(response)
      allow(Portal::CareawareApi::Services::Millennium::Messages).to receive(:create_message) { response.call }
      yield
      allow(Portal::CareawareApi::Services::Millennium::Messages).to receive(:create_message).and_call_original
    end

    def mock_hco_visits(response)
      allow(Portal::HcoApi::Services::Visits).to receive(:create_visit) { response.call }
      yield
      allow(Portal::HcoApi::Services::Visits).to receive(:create_visit).and_call_original
    end
  end
end
