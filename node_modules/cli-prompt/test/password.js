describe('password', function () {
  it('works', function (done) {
    var options = {
      //optional writeable output stream
      //debug: fs.createWriteStream('/tmp/debug.txt')
    };
    suppose('node', [resolve(__dirname, '../examples/password.js')], options)
      .when('tell me a secret: ').respond('earthworn\bm jim\n')
      .when('earthworm jim\n').respond('hey')
      .on('error', assert.ifError)
      .end(function (code) {
        assert(!code);
        done();
      });
  });
});
