describe('windows CRLF', function () {
  it('works', function (done) {
    suppose('node', [resolve(__dirname, '../examples/name.js')])
      .when('enter your first name: ').respond('carlos\r\n')
      .when('and your last name: ').respond('rodriguez\r\n')
      .when('hi, carlos rodriguez!\n').respond("'sup!")
      .on('error', assert.ifError)
      .end(function (code) {
        assert(!code);
        done();
      });
  });
});
