var prompt = require('../');

prompt.multi([
  {
    key: 'username',
    default: 'john_doe'
  },
  {
    label: 'password (must be at least 5 characters)',
    key: 'password',
    type: 'password',
    validate: function (val) {
      if (val.length < 5) throw new Error('password must be at least 5 characters long');
    }
  },
  {
    label: 'number of pets',
    key: 'pets',
    type: 'number',
    default: function () {
      return this.password.length;
    }
  },
  {
    label: 'is this ok?',
    type: 'boolean'
  }
], console.log);
