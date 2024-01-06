const express = require("express");
const path = require("path");
const mysql = require("mysql");
const bodyParser = require("body-parser");

var db_data = require("./.private");

const app = express();

app.use(express.json());
var cors = require("cors");

app.use(cors());

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.listen(8000, function () {
  console.log("listening on 8000");
});

var con = mysql.createConnection(db_data);

con.connect(function (err) {
  if (err) throw err;
  console.log("Connected");
});

app.get("/members", function (req, res) {
  var sql = "select * from users";
  con.query(sql, function (err, results, fields) {
    if (err) {
      res.status(500).json({ error: "Internal Server Error" });
    } else {
      res.json(results);
    }
  });
});

app.post("/members", function (request, response) {
  var user_name = request.body.user_name;
  var user_email = request.body.user_email;
  var account_id = request.body.account_id;
  var account_password = request.body.account_password;

  con.query(
    "INSERT INTO users (user_name, user_email, account_id, account_password) VALUES(?,?,?,?)",
    [user_name, user_email, account_id, account_password],
    function (error, data) {
      if (error) {
        console.log(error);
        response.status(500).json({ error: "Internal Server Error" });
      } else {
        console.log(data.insertId);
        response.json({ message: "User inserted successfully" });
      }
    }
  );
});
