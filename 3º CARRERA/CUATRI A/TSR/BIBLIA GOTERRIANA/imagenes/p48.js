const fich = require('./fich')
fich.writeFileSync('xxx','Hello World')
fich.readFile('xxx', (f)=>{
    console.log('Error de lectura en '+f)
    }, (d)=>{
        console.log(d.toString().split(' '))
})
console.log('done')