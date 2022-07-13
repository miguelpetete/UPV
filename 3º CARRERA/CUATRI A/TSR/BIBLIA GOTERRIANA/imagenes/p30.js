so.on('message', (seg[0], seg[1], seg[2], seg[3], seg[4], seg[5]) => { /*Mgmnt code */ })

so.on('message', function () { let seg = Array.from(arguments); /*Mgmnt code */ })

so.on('message', ([seg]) => { /* Mgmnt code. */ })