const { count } = require('console')
const fs = require('fs')

const path = process.argv[2] || '.'

fs.readdir(path, function (err, files) {
    if (err) return
    let count = files.length
    let size = 0
    files.forEach(function (filename) {
        fs.readFile(path + '/' + filename, function (err, data) {
            count--
            if (err) return
            size += data.length
            if (count <= 0) console.log('Directory size is ' + size)
            /*COMPLETAR */

        })

    })

})

//A
/*
size += data.length
console.log('Directory size is ' + size)

//B
count--
if (err) return
size += data.length
if (count <= 0) console.log('Directory size is ' + size)

//C
if (err) return
count--
size += data.length
if (count <= 0) console.log('Directory size is ' + size)

//D
if (err) return
size += data.length
if (count <= 0) console.log('Directory size is ' + size)
*/