//netServer
require('net').createServer(function (c) {
    c.on('data', function () { c.write('Hello') })
}).listen(9000)
