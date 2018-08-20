export default {
  isValid(value) {
    return value instanceof Date && isFinite(value);
  },
};
