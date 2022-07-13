
/*
A
snd.send([client, msg])

B
snd.send(client, msg)

C
let message = { id: client, txt: msg }
snd.send(JSON.stringify(message))

*/