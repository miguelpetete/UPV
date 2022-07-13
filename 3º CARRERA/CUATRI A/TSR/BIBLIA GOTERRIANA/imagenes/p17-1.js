const net = require('net')
const prompt = "*** Write the filename: "

process.stdin.resume(); process.stdin.setEncoding("utf8")
process.stdout.write(prompt)

process.stdin.on('data', function (str) {
    let client = net.connect({ port: 9001 }, function () {
        client.write(str.slice(0, str.length - 1))
    })
    client.on('data', function (data) {
        console.log(data.toString()); process.stdout.write(prompt)
    })
})


//node netClient
// *** Write the filename: Hello.txt
//Hola a todos
// Write the filename: Haskell.txt
// Unable to read Haskell.txt file