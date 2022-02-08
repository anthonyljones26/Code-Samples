export const en = {

  title: 'Allergy Vial Refills',
  notice: 'Do not use messaging for urgent matters. Please allow up to two weeks for your new vial to be mixed.',
  requiredField: 'This is a required field.',

  form: {
    notice: 'All fields are required.',
    send: 'Send',
    sending: 'Sending...',
    sendError: {
      errorDetail: 'We are unable to complete your allergy vial refill request at this time. ' +
        'Please call the Allergy Clinic at 573-817-3000 to request your refill.'
    }
  },

  paymentMethod: {
    label: 'How will you be paying for your refill?',
    placeholder: 'Select a payment method',
    insurance: 'Pay With Insurance',
    selfPay: 'Self Pay'
  },

  payWithInsurance: {
    label: 'Insurance Plan Name:',
    currentInsurance: {
      label: 'Is this your current insurance?',
      placeholder: 'Select an option',
      error: 'Update your insurance information.',
      errorDetail: 'You must call the Allergy Clinic at {telNumberText} and provide your ' +
        'updated insurance information before your refill request can be submitted.',
      yes: 'Yes',
      no: 'No'
    },
    noInsurance: {
      error: 'No insurance on file.',
      errorDetail: 'You must call the Allergy Clinic at {telNumberText} and provide your updated insurance ' +
        'information before your refill request can be submitted.'
    },
    insuranceError: {
      error: 'Failure to retrieve insurance',
      errorDetail: 'There was an error retrieving your insurance information. Please try again. ' +
        'If you have seen this error more than once, please contact us at {telNumberText}. ' +
        'We are sorry for the inconvenience.'
    }
  },

  recentVisit: {
    label: 'Have you seen an allergy doctor or had a HEALTHConnect Visit within the last year?',
    error: {
      base: 'The Allergy Clinic will still mix this vial, but you will need to { scheduleUrl } ' +
        ' with your allergy provider before your next vial will be mixed.',
      scheduleUrl: 'schedule a visit'
    },
    placeholder: 'Select an option',
    yes: 'Yes',
    no: 'No'
  },

  deliveryMethod: {
    label: 'Delivery Method',
    placeholder: 'Select a delivery method',
    pickup: 'Pick up at Allergy Clinic',
    deliver: 'Mail to me',
    mailform: {
      streetAddress1: 'Street Address 1',
      streetAddress2: 'Street Address 2',
      city: 'City',
      state: 'State',
      postalCode: 'Postal Code',
      country: 'Country',
      error: {
        postalCode: 'Enter a valid zip code.'
      }
    },
    pickupAddress: {
      name: 'Allergy Clinic',
      streetAddress1: '812 Keene Street',
      city: 'Columbia',
      state: 'MO',
      postalCode: '65201',
      phoneNumber: '573-817-3000'
    }
  },

  patientSwitcher: {
    viewingLabel: 'Viewing health record for',
    changePerson: 'Change Person'
  },

  copayLabel: 'Co-pay ${amount}',
  copayAlert: 'You will be billed for the co-pay amount.',
  successPage: {
    heading: {
      patient: 'Patient Name',
      dateTime: 'Date & Time of Request',
      payment: 'Payment Information',
      addressPickUp: 'Pick Up Location',
      addressMail: 'Delivery Location'
    },
    banner: {
      mail: 'Refill request was successful. Within two weeks you will receive a new message ' +
      'in your inbox when your vial has been mailed.',
      pickUp: 'Refill request was successful. Within two weeks you will receive a new message ' +
      'in your inbox when your vial is ready for pick up.',
    },
    recordsLabel: 'Please print a copy of this page for your records.',
    insuranceLabel: 'Your insurance will be billed.',
    providerName: 'Allergy Clinic',
    contactLabel: 'If you have any questions about this request, contact the clinic at 573-817-3000.',
    dateTimeFormat: 'dddd, MMM D, YYYY [\n]h:mm A'
  },

  errorPage: {
    noRelationship: {
      header: 'You need an invitation to access HEALTHConnect',
      lineOne: 'Please use one of the following options to create your HEALTHConnect account.',
      listItemOne: 'Use our {selfEnrollURL}.',
      listItemTwo: 'Call our support line at {supportPhone} for assistance.',
      listItemThree: 'When you check in for your next appointment, ' +
      'ask us to send an invitation to create your account.',
      selfEnrollText: 'self-enrollment tool'
    }
  }
};
