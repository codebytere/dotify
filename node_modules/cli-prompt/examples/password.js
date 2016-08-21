var prompt = require('../');

prompt.password('tell me a secret: ', function (val) {
  console.log(val);
});
