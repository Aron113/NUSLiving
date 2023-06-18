const express = require("express");
const taskController = require("../controllers/taskController");

const router = express.Router();

/* Should prompt users to create an account, a page different from editing a profile
once they have managed to sign in using firebase auth*/

router.route('/')
    .get(taskController.getAllTasks);

router.route('/create/:uid')
    .post(taskController.createTask);

router.route('/:id')
    .get(taskController.getTask)
    .patch(taskController.updateTask)
    .delete(taskController.deleteTask);

module.exports = router;