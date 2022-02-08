import TideServices from 'tide-services';
import Dex from 'tide-dex';

export default class DexUtil {

  static onReady() {
    Dex.getActivePatient().then((activePatient) => {
      DexUtil.refreshWithActivePatient(
        { type: activePatient.type, alias: activePatient.value },
        window.tide.patients
      );
    });
  }
  static refreshWithActivePatient(activePatient, patients) {
    const compareActivePatient = (a) => {
      return (a.alias === activePatient.alias && a.type === activePatient.type);
    };

    // check if the new patient is the same as the current patient
    const currentPatient = patients[ window.tide.activePatient].aliases.findIndex(compareActivePatient);
    if (currentPatient !== -1) {
      return;
    }

    // if not already active, try to find a match within each patient's aliases
    for (let i = 0; i < patients.length; i++) {
      if (patients[i].aliases.findIndex(compareActivePatient) > -1) {
        // update active patient and reload
        TideServices.executePutRequest(
          patients[i].select_url,
          null,
          { Authorization: 'Bearer ' + window.tide.dex.bcsToken }
        )
          .then(() => {
            window.location.reload();
          }, () => {
            // on error, do nothing; reload would likely lead to a recursive reload loop
          });
        break;
      }
    }
  }
}
