let pub = require('zeromq').socket('pub')
pub.bind('tcp://*:' + process.argv[2])
let max = process.argv[3]

let topics = process.argv.slice(4)

let idx = 0

setInterval(() => {
    if (idx >= max) process.exit(0)
    let n = Math.floor(idx / topics.length + 1)
    pub.send(topics[idx++ % topics.length] + ' ' + n)
}, 1000)
