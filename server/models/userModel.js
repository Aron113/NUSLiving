const mongoose = require("mongoose");

//User schema 
const userSchema = new mongoose.Schema(
    {
        username : {
            type : String, 
            required : [true, "Username must be provided"],
            unique : true,
            trim : true, 
            maxLength : [15, 'A username must have less than or equal to 15 characters'],
            minLength : [5, 'A username must have more than or equal than 5 characters '],
        },
        uid : {
            type : String, 
            required : [true, "A user has to be created with an id associated with the account"],
            unique : true, 
        }, 
        telegramHandle : {
            type : String, 
            required : [true, "A user has to be created with a telegram handle for communication purposes"],
            unique : true, 
        }, 
        year : {
            type : Number, 
            required : true, 
            validator : function(val) {
                return val > 0 && val < 5; 
            }, message : "Year should be between 1 and 4",
        },
        house : {
            type : String, 
            // required : [true, "a user must have a house assignmed by the residence"],
            enum : {
                values : ["aquila",
                "noctua",
                "draco",
                "leo",
                "ursa",], 
                message : "A valid house must be provided"
            }, 
        },
    });

// document middleware formats the telegram handle of a user to the right format 
userSchema.pre('save', function(next){
    if (!this.telegramHandle.startsWith("@")) {
        this.telegramHandle = "@" + this.telegramHandle;
    }
    next();
});

const User = mongoose.model('User', userSchema);

module.exports = User;
// module.exports.userSchema = userSchema;