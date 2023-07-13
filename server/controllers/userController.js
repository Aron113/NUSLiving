const User = require('./../models/userModel');
const catchAsync = require('./../utils/catchAsync');
const AppError = require('./../utils/appError');
const mongoose = require("mongoose");
const Task = require('../models/taskModel');

exports.createUser = catchAsync(async(req, res, next) => {
    const newUser = await User.create(req.body);
    res.status(201).json({
        status : 'success',
        data : {
            newUser
        }
    });
});

exports.getUserByUid = catchAsync(async (req, res, next) => {
    const user = await User.findOne({uid : req.params.uid}).populate('createdTasks').populate('appliedTasks').populate('favouriteTasks');
    if (!user) {
      return next(new AppError('No user found with that ID', 404));
    }
    res.status(200).json({
      status: 'success',
      data: {
        user 
      }
    });
  });

  exports.getUserById = catchAsync(async (req, res, next) => {
    const user = await User.findById(req.params.id).populate('createdTasks').populate('appliedTasks').populate('favouriteTasks');
    if (!user) {
      return next(new AppError('No user found with that ID', 404));
    }
    res.status(200).json({
      status: 'success',
      data: {
        user 
      }
    });
  });

  exports.updateUser = catchAsync(async (req, res, next) => {
    const user = await User.findOneAndUpdate({"uid" : req.params.uid}, req.body,{
      new: true,
      runValidators: true
    }).populate('createdTasks').populate('appliedTasks').populate('favouriteTasks');
    if (!user) {
      return next(new AppError('No user found with that UID', 404));
    }
    res.status(200).json({
      status: 'success',
      data: {
        user
      }
    });
  });

  exports.deleteUser = catchAsync(async (req, res, next) => {
    const user = await User.findOneAndDelete({uid : req.params.uid});
    if (!user) {
        return next(new AppError('No user found with that UID', 404));
    }
    res.status(204).json({
        status: 'success',
        data: null
    });
  });

  exports.updateFavouriteTask = catchAsync(async (req, res, next) => {
    var user = await User.findOne({"uid" : req.params.uid});
    if (req.params.updateType == 'add') {
      user['favouriteTasks'] = user['favouriteTasks'].push(req.params.taskId);
    } else {
        user['favouriteTasks'] =  user['favouriteTasks'].filter(e => e != req.params.taskId);
    }
    const updatedUser = await User.findOneAndUpdate({"uid" : req.params.uid}, user,{
      new: true,
      runValidators: true
    }).populate('favouriteTasks');
    if (!updatedUser) {
      return next(new AppError('No user or task found with that ID', 404));
    }
    res.status(200).json({
      status : 'success',
      data : {
          updatedUser,
      }
    });
  });

  exports.updateAppliedTask = catchAsync(async (req, res, next) => {
    var user = await User.findOne({"uid" : req.params.uid});
    var task = await Task.findById(req.params.taskId);
    if (req.params.updateType == 'add') {
      task['applicants'] = task['applicants'].push(user['_id']);
      user['appliedTasks'] = user['appliedTasks'].push(req.params.taskId);
    } else {
      task['applicants'] = task['applicants'].filter(e => e != user['_id'].toString());
      user['appliedTasks'] =  user['appliedTasks'].filter(e => e!= req.params.taskId);
    }
    const updatedUser = await User.findOneAndUpdate({"uid" : req.params.uid}, user,{
      new: true,
      runValidators: true
    }).populate('createdTasks').populate('appliedTasks').populate('favouriteTasks');
    const updatedTask = await Task.findByIdAndUpdate(req.params.taskId, task,{
      new: true,
      runValidators: true
    }).populate('author').populate('applicants');
    console.log(updatedTask);
    if (!updatedUser || !updatedTask) {
      return next(new AppError('No user or task found with that ID', 404));
    }
    res.status(200).json({
      status : 'success',
      data : {
          updatedUser,updatedTask
      }
    },);
  });

