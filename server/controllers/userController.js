const User = require('./../models/userModel');
const catchAsync = require('./../utils/catchAsync');
const AppError = require('./../utils/appError');

exports.createUser = catchAsync(async(req, res, next) => {
    const newUser = await User.create(req.body);
    res.status(201).json({
        status : 'success',
        data : {
            newUser
        }
    });
});

// exports.createUser = async(req, res, next) => {
//   try {
//     const newUser = await User.create(req.body);
//     res.status(201).json({
//         status : 'success',
//         data : {
//             newUser
//         }
//     });
//   } 
//   catch(err) {
//     console.log(err);
//     res.status(500).send('error');
//   }
// };

exports.getUser = catchAsync(async (req, res, next) => {
    const user = await User.findById(req.params.id);
    console.log('getuser');
  
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
    const user = await User.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true
    });
  
    if (!user) {
      return next(new AppError('No tour found with that ID', 404));
    }
  
    res.status(200).json({
      status: 'success',
      data: {
        tour
      }
    });
  });

  exports.deleteUser = catchAsync(async (req, res, next) => {
    const user = await User.findByIdAndDelete(req.params.id);
    
    if (!user) {
        return next(new AppError('No tour found with that ID', 404));
    }
    res.status(204).json({
        status: 'success',
        data: null
    });
  });

