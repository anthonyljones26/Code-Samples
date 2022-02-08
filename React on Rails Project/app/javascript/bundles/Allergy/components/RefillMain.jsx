import PropTypes from 'prop-types';
import React from 'react';
import { injectIntl, intlShape } from 'react-intl';
import Banner from 'tide-banner';
import Notice from 'tide-notice';
import PatientSwitcherWrapper from './PatientSwitcherWrapper';
import Title from 'tide-title';
import AllergyForm from './AllergyForm';
import classNames from 'classnames/bind';
import styles from './RefillMain.scss';

const cx = classNames.bind(styles);

class RefillMain extends React.Component {
  static propTypes = {
    patients: PropTypes.array.isRequired,
    activePatient: PropTypes.number.isRequired,
    updateFormData: PropTypes.func.isRequired,
    intl: intlShape
  }

  constructor(props) {
    super(props);
    this.state = {
      banner: null
    };
  }

  setBanner = (type, message) => {
    this.setState({
      banner: <Banner type = { type }> { message } </Banner>
    });
  }

  render() {
    const { patients, activePatient, intl, updateFormData } = this.props;
    const titleSpacing = cx(['title-container']);
    const noticePadding = cx(['allergy-vials-notice']);

    return (
      <div>
        <div className = 'banner-container'>
          { this.state.banner }
        </div>
        <Title
          title = { intl.formatMessage({ id: 'allergy.title' }) }
          headerClass = { titleSpacing }
        />
        <Notice className = { noticePadding }>
          { intl.formatMessage({ id: 'allergy.notice' }) }
        </Notice>
        <PatientSwitcherWrapper
          patients = { patients }
          activePatient = { activePatient }
        />
        <AllergyForm
          updateFormData = { updateFormData }
          activePatient = { patients[activePatient] }
          setBanner = { this.setBanner }
        />
      </div>
    );
  }
}

export default injectIntl(RefillMain);
