<template>
  <span v-if="isValid" :title="longFormat">{{shortFormat}}</span>
</template>

<script>
import moment from 'moment-timezone';

import dateUtil from '@/util/date';

// explicit timezone and date formats
const TIMEZONE = 'America/Los_Angeles';
// const NY_TZ = 'America/New_York';
const FORMAT_DATE = 'M/D/YYYY';
const FORMAT_TIME = 'h:mm:ss A';
const FORMAT_DATETIME = `${FORMAT_DATE}, ${FORMAT_TIME}`;

const FORMATTERS = {

  // browser timezone and formatting
  DEFAULT: {
    time(value) {
      return value.toLocaleTimeString();
    },
    date(value) {
      return value.toLocaleDateString();
    },
    datetime(value) {
      return value.toLocaleString();
    },
  },

  // explicit timezone and formatting
  // for dates that should be shown in elysium server's time
  WEST_COAST: {
    time(value) {
      return moment(value).tz(TIMEZONE).format(FORMAT_TIME);
    },
    date(value) {
      return moment(value).tz(TIMEZONE).format(FORMAT_DATE);
    },
    datetime(value) {
      return moment(value).tz(TIMEZONE).format(FORMAT_DATETIME);
    },
  },
};

export default {
  name: 'DateTime',
  props: {
    value: Date,
    timeIfToday: Boolean,
    westCoast: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    isValid() {
      return dateUtil.isValid(this.date);
    },
    date() {
      return this.value && new Date(this.value);
    },
    formatter() {
      const formatter = this.westCoast ? 'WEST_COAST' : 'DEFAULT';
      return FORMATTERS[formatter];
    },
    shortFormat() {
      let formatted;

      if (this.timeIfToday && moment(this.value).isSame(moment(), 'day')) {
        // timestamp is from today, show time
        formatted = this.formatter.time(this.date);
      } else {
        // timestamp is older, show date
        formatted = this.formatter.date(this.date);
      }
      return formatted;
    },
    longFormat() {
      return this.formatter.datetime(this.date);
    },
  },
};
</script>
