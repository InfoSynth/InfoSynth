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

//전체 리스트 가져오기
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

//리스트 추가 (회원가입)
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
        res.json({ result: "1" });
      }
    }
  );
});

// 멤버 수정
app.put("/members/:id", function (req, res) {
  var memberId = req.params.id;
  var updatedData = req.body;
  var sql = "UPDATE users SET ? WHERE id = ?";
  con.query(sql, [updatedData, memberId], function (err, result) {
    if (err) {
      res.status(500).json({ error: "Internal Server Error" });
    } else {
      if (result.affectedRows === 0) {
        res.status(404).json({ error: "Member not found" });
      } else {
        res.json({ result: "1" });
      }
    }
  });
});

// 멤버 삭제
app.delete("/members/:id", function (req, res) {
  var memberId = req.params.id;
  var sql = "DELETE FROM users WHERE id = ?";
  con.query(sql, [memberId], function (err, result) {
    if (err) {
      res.status(500).json({ error: "Internal Server Error" });
    } else {
      if (result.affectedRows === 0) {
        res.status(404).json({ error: "Member not found" });
      } else {
        res.json({ result: "1" });
      }
    }
  });
});

// 멤버 1명 가져오기
app.get("/members/each", function (req, res) {
  var user_email = req.body.user_email;

  var sql = "select * from users where user_email = ?";
  con.query(sql, [user_email], function (err, result) {
    if (err) {
      res.status(500).json({ error: "Internal Server Error" });
    } else {
      if (res.length === 0) {
        // 해당 ID의 멤버가 없는 경우 404 Not Found 응답을 보냅니다.
        res.status(404).json({ error: "Member not found" });
      } else {
        res.json(result[0]);
      }
    }
  });
});

// 멤버 확인
app.post("/members/each", function (req, res) {
  var user_name = req.body.user_name;
  var user_email = req.body.user_email;
  var account_id = req.body.account_id;
  var account_password = req.body.account_password;

  con.query(
    "SELECT * FROM users WHERE account_id = ? AND account_password = ?",
    [account_id, account_password],
    function (error, data) {
      if (error) {
        res.status(500).json({ error: "Internal Server Error" });
      } else {
        if (data.length == 1) {
          res.json(data);
          req.session.is_logined = true; // 세션 정보 갱신
          req.session.nickname = username;
          req.session.save(function () {
            res.redirect(`/`);
          });
        } else if (data.length >= 1) {
          res.status(404).json({ message: "User not found" });
        } else {
          res.json({ result: "0" });
        }
      }
    }
  );
});
