import React from 'react';
import PropTypes from 'prop-types';
import PatientSwitcher from 'tide-patient-switcher';
import TideServices from 'tide-services';
import Dex from 'tide-dex';

const PatientSwitcherWrapper = ({ patients, activePatient }) => {

  const getPreferredAlias = (patient, preferredType) => {
    if (patient && preferredType) {
      if (patient.aliases.length === 0) {
        return null;
      }
      const alias = patient.aliases.find(alias => alias.type === preferredType) || patient.aliases[0];
      return { type: alias.type, value: alias.alias };
    } else {
      return null;
    }
  };

  const handleItemSelection = (event, patient) => {
    event.preventDefault();

    TideServices.executePutRequest(
      patient.select_url,
      {},
      { Authorization: 'Bearer ' + window.tide.dex.bcsToken }
    )
      .then(() => {
        if (Dex.hasActiveACL()) {
          const patientAlias = getPreferredAlias(patient, window.tide.config.preferredAliasType);
          if (patientAlias) {
            Dex.setActivePatient(patientAlias);
          } else {
            window.location.reload();
          }
        } else {
          window.location.reload();
        }
      }, () => {
        // on error, reload to give user feedback even if the patient did not successfully change
        window.location.reload();
      });
  };

  return (
    <PatientSwitcher
      patients = { patients }
      activePatientIndex = { activePatient }
      onSelect = { (e, patient) => handleItemSelection(e, patient) }
    />
  );
};

PatientSwitcherWrapper.propTypes = {
  patients: PropTypes.array.isRequired,
  activePatient: PropTypes.number.isRequired
};

export default PatientSwitcherWrapper;
