const e = require('./evento')
var uno = e.define('uno')
var dos = e.define('dos')
setInterval(()=>{uno(); dos()}, 1000)