require('net').createServer(function (c) {

    c.on('data', function (file) {
        require('fs').readFile(file, function (err, data) {
            if (err) c.write('unable to read ' + file + ' file')
            else c.write(data)
        })
    })

}).listen(9001)

/*
A
c.on('data', function (data) {
    require('fs').readFile(data, function (err, data) {
        if (err) c.write('unable to read ' + data + ' file')
        else c.write(data)
    })
})

B
c.on('data', function (file) {
    c.write(require('fs').readFileSync(file))
})

C
c.on('data', function (file) {
    require('fs').readFile(file, function (err, data) {
        if (err) c.write('unable to read ' + file + ' file')
        else c.write(data)
    })
})

D
c.on('data', function (file) {
    try { c.write(require('fs').readFileSync(file)) }
    catch {
        throw ('unable to read ' + file + ' file')
    }
})
*/