const mongoose = require("mongoose");
const User = require("./userModel");

const taskSchema = mongoose.Schema(
    {
        author : [
            {
            type : mongoose.Types.ObjectId,
            ref : 'User',
            required : [true, "task must have an author"],
            unique : false,
            } 
        ], 
        title : {
            type : String, 
            required : [true, "task must have a title"],
            trim : true, 
            minLength : [5, "title must have at least 5 characters"],
            maxLength : [30, "title must have at most 30 characters"],
            unique : false,
        }, 
        briefDescription : {
            type : String, 
            required : [true, "task must have content"],
            trim : true, 
            minLength : [20, "task content must be at least 20 characters"],
            maxLength : [120, "task content must be at most 120 characters"],
            unique : false,
        },
        dueDate : {
            type : Date,
            required : [true, "task must have due date specified"],
            validator : function(val) {
                return val > Date.now();
            }, message : "due date must be later than now",
            unique : false,
        }, 
        fullDescription : {
            type : String,
            required : [true, "task must have full description provided"],
            trim : true, 
            minLength : [20, "task content must be at least 20 characters"],
            maxLength : [1000, "task content must be at most 300 characters"],
        }, 
        requirements : {
            type : String,
            required : [true, "task must have full description provided"],
            trim : true, 
            minLength : [20, "task content must be at least 20 characters"],
            maxLength : [300, "task content must be at most 300 characters"],
            unique : false,
        }, 
        applicants :  [
            {
            type : mongoose.Types.ObjectId,
            ref : 'User',
            unique : false,
            } 
        ], 
    }
)

const Task = mongoose.model('Task',taskSchema);

module.exports = Task;