if (process.argv.length != 4) process.exit()
let i = parseInt(process.argv[2]), f = parseInt(process.argv[3])
if (i > f) process.exit()
let client = require('net').connect({ port: 9000 }, function () {
    setInterval(function () { client.write('' + i++) }, 10)
})
client.on('data', function (data) {
    if (i > f) { console.log(data.toString()); client.end(); process.exit() }
})


/*
node p18-1 3 16 & node p18-1 1 10 & node p18-1 10 20 &
133
55
165
*/
