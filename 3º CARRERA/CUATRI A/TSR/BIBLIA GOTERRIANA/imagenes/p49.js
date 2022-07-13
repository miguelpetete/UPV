const e = require('./evento')
var uno = e.define( 'uno')
var dos = e.define( 'dos')

setInterval(uno, 500)
setInterval(dos, 400)
setTimeout(()=>{process.exit(0)}, 1100)