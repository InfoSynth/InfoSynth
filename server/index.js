const express = require('express');
const path = require('path');
const mysql = require('mysql');
const bodyParser = require('body-parser');

const app = express();

app.use(express.json());
var cors = require('cors');

app.use(cors());

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended:true}));

app.listen(8000, function () {
  console.log('listening on 8000')
}); 

var con = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'dbmssql12!!',
    port:3306,
    database: 'dating_app'
    
  });

con.connect(function(err){
  if (err) throw err;
  console.log('Connected');
})

app.get('/get', function(req, res){
    var sql = 'select * from users';
    con.query(sql, function(err, id, fields){
      var user_id = req.params.id;
      if(id){
        var sql='select * from users'
        con.query(sql, function(err, id, fields){
          if(err){
            console.log(err);
          }else{
            res.json(id);
            console.log('users:', user_id);
            console.log('users:', fields);
          }
        })
      }
    })
  })