const zmq = require('zeromq')

let pub = zmq.socket('pub')
let pull = zmq.socket('pull')
pub.bind('tcp://*:9998')
pull.bind('tcp://*:9999')

pull.on('message', (id, txt) => {
    switch (txt.toString()) {

        case 'HI':
            pub.send(['server', id + ' connected'])
            break

        case 'BYE':
            pub.send(['server', id + ' disconnected'])
            break

        default:
            pub.send([id, txt])

    }
})

/*
B
let rcv = zmq.socket('sub'), snd = zmq.socket('push')
rcv.connect('tcp://*:9998'); snd.connect('tcp://*:9999')

C
let rcv = zmq.socket('sub'); rcv.connect('tcp://158.42.21.67:9998')
let snd = zmq.socket('push'); snd.connect('tcp://158.42.21.67:9999')

D
let rcv = zmq.socket('rep'); rcv.connect('tcp://158.42.21.67:9998')
let snd = zmq.socket('req'); snd.connect('tcp://158.42.21.67:9999')

*/