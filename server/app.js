const express = require('express');
const AppError = require("./utils/appError");
const ErrorHandler = require("./controllers/ErrorController");
const userRouter = require('./routes/userRoutes');
const taskRouter = require('./routes/taskRoutes');
const bodyParser = require("body-parser");
const cors = require('cors');


const app = express();
app.use(cors());

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }))

// parse application/json
app.use(bodyParser.json())
// app.use(express.json());

app.get('/', (req,res) => {
    console.log(res);
    console.log('gk')
    res.send(200);
});

//ROUTES
app.use('/api/v1/tasks', taskRouter);
app.use('/api/v1/user', userRouter);

//For all unspecified routes, return 404
app.all('*', (req, res, next) => {
    next(new AppError(`Can't find ${req.originalUrl} on this server!`, 404));
});

//For all requests that resulted in an error, error is handled by ErrorHandler
app.use(ErrorHandler);

module.exports = app;
