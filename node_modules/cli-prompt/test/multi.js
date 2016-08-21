describe('multi', function () {
  it('works', function (done) {
    var options = {
      //optional writeable output stream
      //debug: fs.createWriteStream('/tmp/debug.txt')
    };
    suppose('node', [resolve(__dirname, '../examples/multi.js')], options)
      .when('username: (john_doe) ').respond('\n')
      .when('password (must be at least 5 characters): ').respond('asdfff\b\b\n')
      .when('password must be at least 5 characters long\npassword (must be at least 5 characters): ').respond('asdfff\n')
      .when('number of pets: (6) ').respond('eight\n')
      .when('number of pets: (6) ').respond('8\n')
      .when('is this ok?: (y/n) ').respond('okay\n')
      .when('is this ok?: (y/n) ').respond('yes\n')
      .when("{ username: 'john_doe', password: 'asdfff', pets: 8 }\n").respond('great')
      .on('error', assert.ifError)
      .end(function (code) {
        assert(!code);
        done();
      });
  });
});
