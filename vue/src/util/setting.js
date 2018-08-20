/**
 * Facade in front of local storage to enable additional features to be added.
 *
 * TODO namespace keys automatically
 */
export default {
  load: key => localStorage[key],
  save: (key, value) => {
    localStorage[key] = value;
  },
};
