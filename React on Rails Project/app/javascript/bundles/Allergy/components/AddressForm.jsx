import React from 'react';
import PropTypes from 'prop-types';
import Text from 'terra-text/lib/Text';

const AddressForm = ({ address, name, phoneNumber }) => {

  const renderStreetAddress2 = (address) => {
    if (address.streetAddress2 !== '') {
      return <div><Text>{ address.streetAddress2 }</Text><br /></div>;
    }
  };

  const renderPhoneNumber = (phoneNumber) => {
    if (phoneNumber) {
      return <div><Text>{ phoneNumber }</Text></div>;
    }
  };

  return (
    <div>
      <Text>{ name }</Text>
      <br />
      <Text>{ address.streetAddress1 }</Text>
      <br />
      { renderStreetAddress2(address) }
      <Text>{ address.city + ', ' + address.state + ' ' + address.zipcode }</Text>
      <br />
      { renderPhoneNumber(phoneNumber) }
    </div>
  );
};

AddressForm.propTypes = {
  name: PropTypes.string.isRequired,
  address: PropTypes.object.isRequired,
  phoneNumber: PropTypes.string
};

export default AddressForm;
