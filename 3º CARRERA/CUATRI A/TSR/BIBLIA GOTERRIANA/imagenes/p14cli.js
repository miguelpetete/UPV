//netClient
const net = require('net')
let client = net.connect({ port: 9000 }, function () {
    client.write('World')
})
client.on('data', function (data) {
    console.log('' + data); client.end();
})