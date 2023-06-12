const express = require('express');
const morgan = require('morgan');

const userRouter = require('./routes/userRoutes');
const taskRouter = require('./routes/taskRoutes');

app.use('/api/v1/tours', taskRouter);
app.use('/api/v1/users', userRouter);

module.exports = app;