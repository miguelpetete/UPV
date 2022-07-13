

// A
// var sum = 0
// require('net').createServer(function (c) {
//     c.on('data', function (data) {
//         sum += parseInt(data); c.write('' + sum)
//     })
//     c.on('error', function () { })
// }).listen(9000)

// B
require('net').createServer(function (c) {
    var sum = 0
    c.on('data', function (data) {
        sum += parseInt(data); c.write('' + sum)
    })
    c.on('error', function () { })
}).listen(9000)

// C
// require('net').createServer(function (c) {
//     var sum = 0
//     c.on('data', function (data) {
//         c.write('' + (sum + parseInt(data)))
//     })
//     c.on('error', function () { })
// }).listen(9000)

// D
// var add = function (s, d) { return s += parseInt(d) }
// require('net').createServer(function (c) {
//     var sum = 0
//     c.on('data', function (data) {
//         c.write('' + add(sum, data))
//     })
//     c.on('error', function () { })
// }).listen(9000)