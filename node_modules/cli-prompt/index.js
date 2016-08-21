var tty = require('tty')
  , keypress = require('keypress')
  , stdinEnded = false

process.stdin.once('end', function() { stdinEnded = true; });

function prompt (message, hideInput, onValue, onError) {
  if (typeof hideInput === 'function') {
    onError = onValue;
    onValue = hideInput;
    hideInput = false;
  }

  keypress(process.stdin);

  function setRawMode(mode) {
    if (process.stdin.setRawMode) {
      process.stdin.setRawMode(mode);
    }
    else if (process.stderr.isTTY) {
      tty.setRawMode(mode);
    }
  }
  if (hideInput) setRawMode(true);

  if (message !== null) process.stderr.write(message);

  var gotInput = false;

  function done (err) {
    process.stdin.removeListener('keypress', listen);
    process.stdin.removeListener('error', done);
    process.stdin.removeListener('end', done);
    process.stdin.pause();
    if (hideInput) {
      setRawMode(false);
      console.error();
    }
    if (err && onError) {
      onError(err);
    } else if (!gotInput && onError) {
      onError(new Error('stdin has ended'));
    } else {
      onValue(line, function () {}); // for backwards-compatibility, fake end() callback
    }
  }

  if (stdinEnded) {
    process.nextTick(done);
    return;
  }

  function listen (c, key) {
    gotInput = true;
    if (key) {
      if (key.ctrl && key.name === 'c') {
        process.exit();
      }
      else if (key.name === 'return'){
        if (hideInput == true){
          done();
        }
        return;
      } else if (key.name === 'enter' || key.sequence === '\r\n') {
        line = line.trim();
        done();
        return;
      }
      if (key.name === 'backspace') line = line.slice(0, -1);
    }
    if (!key || key.name !== 'backspace') line += c;
  }

  var line = '';
  process.stdin.on('keypress', listen)

  if (onError) {
    process.stdin
      .once('error', done)
      .once('end', done);
  }

  process.stdin.resume();
}
module.exports = prompt;

function password (message, onValue, onError) {
  prompt(message, true, function (val) {
    // password is required
    if (!val) password(message, onValue, onError);
    else onValue(val, function () {}); // for backwards-compatibility, fake end() callback
  }, onError);
}
module.exports.password = password;

function multi (questions, onValue, onError) {
  var idx = 0, ret = {};
  (function ask () {
    var q = questions[idx++];
    if (typeof q === 'string') {
      q = {key: q};
    }
    function record (val) {
      function retry () {
        idx--;
        ask();
      }
      if (q.required && typeof q.default === 'undefined' && !val) return retry();
      if (!val && typeof q.default !== 'undefined') {
        val = def;
      }
      if (q.validate) {
        try {
           var ok = q.validate.call(ret, val);
        }
        catch (e) {
          console.error(e.message);
          return retry();
        }
        if (ok === false) return retry();
      }
      if (q.type === 'number') {
        val = Number(val);
        if (Number.isNaN(val)) return retry();
      }
      else if (q.type === 'boolean') val = val.match(/^(yes|ok|true|y)$/i) ? true : false;
      if (typeof q.key !== 'undefined') ret[q.key] = val;
      if (questions[idx]) ask();
      else onValue(ret);
    }
    var label = (q.label || q.key) + ': ';
    if (q.default) {
      var def = (typeof q.default === 'function') ? val = q.default.call(ret) : q.default;
      label += '(' + def + ') ';
    }
    else if (q.type === 'boolean') {
      label += '(y/n) ';
      q.validate = function (val){
        if (!val.match(/^(yes|ok|true|y|no|false|n)$/i)) return false;
      };
    }
    prompt(label, q.type === 'password', record, onError);
  })();
}
module.exports.multi = multi;
