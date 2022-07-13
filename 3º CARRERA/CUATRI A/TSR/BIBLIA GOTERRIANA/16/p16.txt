const emitter = new (require('events')).EventEmitter
var e = ["uno", "dos"], n= [1, 1], h = []

var emitX = function(x) {
	return function() {emitter.emit(x)}
}

var listenerX = function(x, n) {
	return function() {console.log((n++)+" eventos tipo "+x+".")}
}

for (var i = 0; i < e.length; i++) {
	emitter.on(e[i], listenerX(e[i], n[i]))
	h[i] = setInterval(emitX(e[i]), n[i] * 1000)
}

setTimeout(function() {
	for (var i = 0; i < e.length; i++) clearInterval(h[i])
}, 2100)
