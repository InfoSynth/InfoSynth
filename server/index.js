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

app.post("/login", function (req, res) {
  var user_name = req.body.user_name;
  var user_email = req.body.user_email;
  var account_id = req.body.account_id;
  var account_password = req.body.account_password;

  con.query(
    "SELECT * FROM users WHERE account_id = ? AND account_password = ?", [account_id,account_password],
    function (error, data) {
      if (error) {
        res.status(500).json({ error: "Internal Server Error" });
      } else {
        if (data.length == 1) {
          res.json(data);
          req.session.is_logined = true;      // 세션 정보 갱신
          req.session.nickname = username;
          req.session.save(function () {
            res.redirect(`/`);
          });
        } else if(data.length >= 1){
          res.status(404).json({ message: "User not found" });
        } else {
          res.send(`<script type="text/javascript">alert("로그인 정보가 일치하지 않습니다."); document.location.href="/auth/login";</script>`);
        }
      }
    }
  );
});
