const express = require("express");
const userController = require("../controllers/userController");

const router = express.Router();

/* Should prompt users to create an account, a page different from editing a profile
once they have managed to sign in using firebase auth*/

router.route('/signup')
    .post(userController.createUser);

router.route('/:id')
    .get(userController.getUser)
    .patch(userController.updateUser)
    .delete(userController.deleteUser);


module.exports = router; 