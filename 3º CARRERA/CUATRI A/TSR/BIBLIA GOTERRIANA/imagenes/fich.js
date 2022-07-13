const fs = require('fs')
exports.readFile = function (name, ferror, fok) {
    fs.readFile(name, 'utf8', function (err, data) {
        if (err) ferror(name); else fok(data)

    })
}

exports.readFileSync = function (name) {
    var res
    try { res = fs.readFileSync(name, 'utf8') } catch (e) { }
    return res
}

exports.writeFileSync = function (name, data) {

    fs.writeFileSync(name, data)
}