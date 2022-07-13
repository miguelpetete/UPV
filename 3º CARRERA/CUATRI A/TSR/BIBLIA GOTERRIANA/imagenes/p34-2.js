let sub = require('zeromq').socket('sub')
sub.connect('tcp://127.0.0.1:9999')
sub.subscribe(process.argv[2] || '1')

sub.on('message', (m) => { console.log(m + '') })


// 1
// 10
// 11
// 12
// 13
// 14
// 15
// 16
// 17
// 18
// 19