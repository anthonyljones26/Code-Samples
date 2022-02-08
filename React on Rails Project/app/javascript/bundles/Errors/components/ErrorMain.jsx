import PropTypes from 'prop-types';
import React from 'react';
import IconQuestionOutline from 'terra-icon/lib/icon/IconQuestionOutline';
import ErrorPagelet, { ErrorTypes } from 'tide-error-pagelet';
import { injectIntl, intlShape } from 'react-intl';
import { ReactUtil } from 'utils/react.util';

const ErrorMain = ({ status, errorPageLinks, intl }) => {
  const supportPhoneLink = ReactUtil.phoneNumAsText(
    errorPageLinks.supportPhone,
    errorPageLinks.supportPhone
  );

  const selfEnrollLink = ReactUtil.linkAsText(
    errorPageLinks.selfEnrollURL,
    intl.formatMessage({ id: 'allergy.errorPage.noRelationship.selfEnrollText' })
  );

  const mapStatus = (status) => {
    switch (status) {
      case 'unauthorized':
        return ErrorTypes.UNAUTHORIZED;
      case 'forbidden':
        return ErrorTypes.FORBIDDEN;
      case 'not_found':
        return ErrorTypes.NOT_FOUND;
      case 'unprocessable_entity':
        return ErrorTypes.UNPROCESSABLE_ENTITY;
      case 'internal_server_error':
        return ErrorTypes.INTERNAL_SERVER_ERROR;
      case 'no_relationship':
        return ErrorTypes.CUSTOM;
      default:
        return ErrorTypes.CUSTOM;
    }
  };

  const mapIcon = (status) => {
    switch (status) {
      case 'no_relationship':
        return IconQuestionOutline;
      default:
        return null;
    }
  };

  const mapTitle = (status) => {
    switch (status) {
      case 'no_relationship':
        return intl.formatMessage({ id: 'allergy.errorPage.noRelationship.header' });
      default:
        return null;
    }
  };

  const mapDetails = (status) => {
    switch (status) {
      case 'no_relationship':
        return (
          <div>
            <p>
              { intl.formatMessage({ id: 'allergy.errorPage.noRelationship.lineOne' }) }
            </p>
            <ul>
              <li>
                <span dangerouslySetInnerHTML = {
                  { __html: intl.formatMessage({ id: 'allergy.errorPage.noRelationship.listItemOne' },
                    { selfEnrollURL: selfEnrollLink }) }}
                />
              </li>
              <li>
                <span dangerouslySetInnerHTML = {
                  { __html: intl.formatMessage({ id: 'allergy.errorPage.noRelationship.listItemTwo' },
                    { supportPhone: supportPhoneLink }) }}
                />
              </li>
              <li>
                { intl.formatMessage({ id: 'allergy.errorPage.noRelationship.listItemThree' }) }
              </li>
            </ul>
          </div>
        );
      default:
        return null;
    }
  };

  return (
    <ErrorPagelet
      type = { mapStatus(status) }
      customIcon = { mapIcon(status) }
      customTitle = { mapTitle(status) }
    >
      { mapDetails(status) }
    </ErrorPagelet>
  );
};

ErrorMain.propTypes = {
  status: PropTypes.string.isRequired,
  errorPageLinks: PropTypes.object.isRequired,
  intl: intlShape.isRequired,
};

export default injectIntl(ErrorMain);
