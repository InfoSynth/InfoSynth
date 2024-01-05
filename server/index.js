const express = require("express");
const path = require("path");
const mysql = require("mysql");
const bodyParser = require("body-parser");

var db_data = require("./private");

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

// app.post("/member", function (request, res) {
//   // var sql = 'INSERT INTO users (name, birth, etc) VALUES(?, ?, ?)';
//   // var params = ['Supervisor', 'Watcher', 'graphittie'];//파라미터를 값들로 줌(배열로 생성)
//   // conn.query(sql, params, function(err, rows, fields){// 쿼리문 두번째 인자로 파라미터로 전달함(값들을 치환시켜서 실행함. 보안과도 밀접한 관계가 있음(sql injection attack))
//   //     if(err) console.log(err);
//   //     console.log(rows.insertId);
//   // });
//   var username = request.body.username;
//   var password = request.body.password;
//   var email = request.body.email;

//   if (username && password && email) {
//     con.query('SELECT * FROM users WHERE email = ?', [email], function(error, results, fields) {
//       if (error) throw error;
//       if (results.length != 0) request.send();
//       else {
//         con.query('INSERT INTO user (username, password, email) VALUES(?,?,?)', [username, password, email],
//         function (error, data) {
//           if (error) console.log(error);
//           else console.log(data);
//         });
//         response.send('<script type="text/javascript">alert("회원가입을 환영합니다!"); document.location.href="/";</script>');
//       }
//       response.end();
//     });

//   } else {
//       response.send('<script type="text/javascript">alert("모든 정보를 입력하세요"); document.location.href="/register";</script>');
//       response.end();
//   }
// });
