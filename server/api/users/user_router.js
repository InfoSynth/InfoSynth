const {
  createUser,
  // getUserByUserID,
  getUserByUserEmail,
  getUsers,
  updateUser,
  login,
  updateUserProfile,
  updateUserBackground,
} = require("./user_controller");
const router = require("express").Router();

const { checkToken } = require("../../auth/token_validation");

router.post("/", createUser);
router.get("/", checkToken, getUsers);
// router.get("/:id", checkToken, getUserByUserID);
router.get("/:email", checkToken, getUserByUserEmail);
router.put("/", checkToken, updateUser);
router.post("/login", login);

router.patch("/users/backgroundimage", checkToken, updateUserBackground);
router.patch("/users/profileimage", checkToken, updateUserProfile);

module.exports = router;
