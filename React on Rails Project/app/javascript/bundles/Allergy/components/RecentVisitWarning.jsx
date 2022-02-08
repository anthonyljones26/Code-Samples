import React from 'react';
import PropTypes from 'prop-types';
import { FormattedMessage } from 'react-intl';
import Banner from 'tide-banner';
import Dex from 'tide-dex';

import { injectIntl, intlShape } from 'react-intl';

const RecentVisitWarning = ({ display, intl }) => {
  if (!display) {
    return null;
  }

  const itemOnClick = (link) => {
    Dex.routeTo(link.alias ? { alias: link.alias } : { path: link.path });
  };

  const linkAsText = (link, urlText) => {
    return (
      <a
        onClick = { () => itemOnClick(link) }
        href = { 'javascript:void(0);' }
      >
        { urlText }
      </a>
    );
  };

  const scheduleLink = linkAsText(
    window.tide.config.urls.schedulingUrl,
    intl.formatMessage({ id: 'allergy.recentVisit.error.scheduleUrl' })
  );

  const formattedMessage = (scheduleLink) => {
    return (
      <FormattedMessage
        id = 'allergy.recentVisit.error.base'
        values = {{ scheduleUrl: scheduleLink }}
      />
    );
  };

  return (
    <Banner className = 'recent-visit-warning' type = 'warning'>
      { formattedMessage(scheduleLink) }
    </Banner>
  );
};

RecentVisitWarning.propTypes = {
  display: PropTypes.bool,
  intl: intlShape.isRequired,
};

RecentVisitWarning.defaultProps = {
  display: true,
};

export default injectIntl(RecentVisitWarning);
