let pub = require('zeromq').socket('pub')
pub.bind('tcp://*:9999')

let count = 0;

setInterval(() => { pub.send('' + count++) }, 1000)