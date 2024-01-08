//user_service.js

const con = require("../../database");

module.exports = {
  create: (data, callBack) => {
    var id = data.body.id;
    var name = data.body.name;
    var birth = data.body.birth;
    var gender = data.body.gender;
    var email = data.body.email;
    var password = data.body.password;
    con.query(
      "INSERT INTO users (name, birth, gender, email, password) VALUES(?,?,?,?,?)",
      [name, birth, gender, email, password],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },

  getUsers: (callBack) => {
    con.query("select * from users", (error, results, fields) => {
      if (error) {
        return callBack(error);
      }
      return callBack(null, results);
    });
  },

  getUserByUserID: (id, callBack) => {
    con.query(
      "select * from users where id = ?",
      [id],
      (error, results, fields) => {
        if (error) {
          callBack(error);
        }
        return callBack(null, results[0]);
      }
    );
  },
  getUserByUserEmail: (email, callBack) => {
    con.query(
      "select * from users where email = ?",
      [email],
      (error, results, fields) => {
        if (error) {
          callBack(error);
        }
        return callBack(null, results[0]);
      }
    );
  },
  updateUser: (data, callBack) => {
    var id = data.body.id;
    var updatedData = data.body;
    con.query(
      "UPDATE users SET ? WHERE id = ?",
      [updatedData, id],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
};
