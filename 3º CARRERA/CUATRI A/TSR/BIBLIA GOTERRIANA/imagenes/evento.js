const { ECANCELED } = require('constants')
const ev = require('events')
emisor = new ev.EventEmitter()
exports.define = function (id) {
    var n = 0
    emisor.on(id, () => { console.log('evento', id + ':', ++n) })
    return () => { emisor.emit(id) }
}