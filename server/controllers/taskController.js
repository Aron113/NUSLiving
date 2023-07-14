const Task = require('./../models/taskModel');
const catchAsync = require('./../utils/catchAsync');
const AppError = require('./../utils/appError');
const APIFeatures = require('../utils/apiFeatures');
const userController = require('./userController');
const User = require('./../models/userModel');

exports.createTask = catchAsync(async(req, res, next) => {
    const newTask = await Task.create(req.body);
    if (newTask){
      var author = await User.findOne({"uid" : req.params.uid});
      author['createdTasks'] = author['createdTasks'].push(newTask._id);
      const user = await User.findOneAndUpdate({"uid" : req.params.uid}, author,{
        new: true,
        runValidators: true
      }).populate('createdTasks').populate('appliedTasks').populate('favouriteTasks');
      if (!user) {
      return next(new AppError('No user found with that ID', 404));
      }
      res.status(200).json({
          status : 'success',
          data : {
              newTask,
          }
      });
    }
});

exports.getTask = catchAsync(async (req, res, next) => {
    const Task = await Task.findById(req.params.id).populate('author');
    if (!Task) {
      return next(new AppError('No Task found with that ID', 404));
    }
    res.status(200).json({
      status: 'success',
      data: {
        Task 
      }
    });
  });

  exports.getAllTasks = catchAsync(async (req, res, next) => {
    const features = new APIFeatures(Task.find(), req.query)
      .filter()
      .sort()
      .limitFields()
      .paginate();
    const tasks = await features.query;
  
    // SEND RESPONSE
    res.status(200).json({
      status: 'success',
      results: tasks.length,
      data: {
        tasks
      }
    });
  });

  exports.updateTask = catchAsync(async (req, res, next) => {
      const task = await Task.findByIdAndUpdate(req.params.id, req.body, {
        new: true,
        runValidators: true
      });
    if (!task) {
      return next(new AppError('No task found with that ID', 404));
    }
    res.status(200).json({
      status: 'success',
      data: {
        task
      }
    });
  });

  exports.deleteTask = catchAsync(async (req, res, next) => {
    const task = await Task.findByIdAndDelete(req.params.id);
    if (!task) {
        return next(new AppError('No task found with that ID', 404));
    }
    console.log(task);
    res.status(204).json({
        status: 'success',
        data: null
    });
  });

