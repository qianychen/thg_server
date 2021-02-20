const mysql = require('mysql')
var conn = mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'thg_shop',
    multipleStatements : true
})
conn.connect()
module.exports = conn