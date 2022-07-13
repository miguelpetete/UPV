const { emit } = require('process')

const emitter = new (require('events')).EventEmitter
let emittingA = (e, x) => { emitter.emit(e, e, x) }
let emittingB = (e, x) => { return () => { emitter.emit(e, e, x) } }
let listener = (e, x) => { console.log("Event " + e + " after " + x + " seconds") }
emitter.on("one", listener)
emitter.on("two", listener)

let x = 8
setTimeout(() => { emittingA("two", x) }, x * 1000)
x = 4
setTimeout(emittingB("one", x), x * 1000)
x = 2
console.log("Events start soon, curretnly x is " + x)


// Events start soon, curretnly x is 2
// Event one after 4 seconds
// Event two after 2 seconds