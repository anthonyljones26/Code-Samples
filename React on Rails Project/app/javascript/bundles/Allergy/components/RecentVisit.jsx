import React from 'react';
import PropTypes from 'prop-types';
import { injectIntl, intlShape } from 'react-intl';
import SelectField from 'terra-form-select/lib/SelectField';
import RecentVisitWarning from './RecentVisitWarning';

const RecentVisit = ({ updateRecentVisit, recentVisit, display, intl }) => {
  if (!display) {
    return null;
  }
  return (
    <div>
      <SelectField
        value = { recentVisit === null ? '' : recentVisit.toString() }
        selectId = 'recent-visit-select-field'
        label = { intl.formatMessage({ id: 'allergy.recentVisit.label' }) }
        placeholder = { intl.formatMessage({ id: 'allergy.recentVisit.placeholder' }) }
        onChange = { updateRecentVisit }
        maxWidth = '100%'
        variant = 'search' // This option prevents screen jump to top
        selectAttrs = {{ onFocus: (({ target }) => target.readOnly = true) }} //removing search ability on focus
        required
      >
        <SelectField.Option
          value = 'true'
          display = { intl.formatMessage({ id: 'allergy.recentVisit.yes' }) }
        />
        <SelectField.Option
          value = 'false'
          display = { intl.formatMessage({ id: 'allergy.recentVisit.no' }) }
        />
      </SelectField>
      <RecentVisitWarning display = { recentVisit === false } />
    </div>
  );
};

RecentVisit.propTypes = {
  updateRecentVisit: PropTypes.func.isRequired,
  recentVisit: PropTypes.bool,
  display: PropTypes.bool,
  intl: intlShape
};

RecentVisit.defaultProps = {
  display: true
};

export default injectIntl(RecentVisit);
