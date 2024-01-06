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
app.post("/members", function (req, res) {
  var id = req.body.id;
  var name = req.body.name;
  var birth = req.body.birth;
  var gender = req.body.gender;
  var email = req.body.email;
  var password = req.body.password;

  con.query(
    "INSERT INTO users (name, birth, gender, email, password) VALUES(?,?,?,?,?)",
    [name, birth, gender, email, password],
    function (error, data) {
      if (error) {
        console.error("Database error:", error);
        res.status(500).json({ error: "Internal Server Error" });
      } else {
        res.json({ result: "1" });
      }
    }
  );
});

// 멤버 1명 가져오기
app.get("/members/:id", function (req, res) {
  var id = req.params.id;

  var sql = "select * from users where id = ?";
  con.query(sql, [id], function (err, result) {
    if (err) {
      res.status(500).json({ error: "Internal Server Error" });
    } else {
      if (res.length === 0) {
        res.status(404).json({ error: "Member not found" });
      } else {
        res.json(result[0]);
      }
    }
  });
});

// 멤버 수정
app.put("/members/:id", function (req, res) {
  var id = req.params.id;
  var updatedData = req.body;
  var sql = "UPDATE users SET ? WHERE id = ?";
  con.query(sql, [updatedData, id], function (err, result) {
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

// 멤버 확인
app.post("/members/each", function (req, res) {
  var email = req.body.email;
  var password = req.body.password;

  con.query(
    "SELECT * FROM users WHERE email = ? AND password = ?",
    [email, password],
    function (error, data) {
      if (error) {
        res.status(500).json({ message: "Internal Server Error" });
      } else {
        if (data.length == 1) {
          res.json(data);
        } else if (data.length >= 1) {
          res.status(404).json({ message: "Too Many User" });
        } else {
          res.status(404).json({ message: "No User" });
        }
      }
    }
  );
});
