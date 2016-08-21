cli-prompt
==========

A tiny CLI prompter

[![build status](https://secure.travis-ci.org/carlos8f/node-cli-prompt.png)](http://travis-ci.org/carlos8f/node-cli-prompt)

Install
-------

```javascript
$ npm install --save cli-prompt
```

Usage
-----

### `prompt(message, onValue, [onError])`

- `message`: text prompt for the user
- `onValue`: function to be called (after user hits enter/return) with the entered text
- `onError`: optional function to receive an error, if STDIN has already ended, for example.

Note: cli-prompt will not work if STDIN has ended. If provided, onError will be called in this case.

Example
-------

```js
var prompt = require('cli-prompt');

prompt('enter your first name: ', function (val) {
  var first = val;
  prompt('and your last name: ', function (val) {
    console.log('hi, ' + first + ' ' + val + '!');
  }, function (err) {
    console.error('unable to read last name: ' + err);
  });
}, function (err) {
  console.error('unable to read first name: ' + err);
});
```

### Password/hidden input

```js
var prompt = require('cli-prompt');

prompt.password('tell me a secret: ', console.log, console.error);
```

### Multiple questions

```js
var prompt = require('cli-prompt');

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
], console.log, console.error);
```

---

### Thanks

- Thanks to @kevinoid for implementing STDIN end/error detection.
- Thanks to @mm-gmbd and @apieceofbart for contributing Windows support patches.

- - -

### Developed by [Terra Eclipse](http://www.terraeclipse.com)
Terra Eclipse, Inc. is a nationally recognized political technology and
strategy firm located in Aptos, CA and Washington, D.C.

- - -

### License: MIT

- Copyright (C) 2012 Carlos Rodriguez (http://s8f.org/)
- Copyright (C) 2012 Terra Eclipse, Inc. (http://www.terraeclipse.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
