const mysql = require("mysql");

var db_data = require("./.private");
const con = mysql.createConnection(db_data);

module.exports = con;
