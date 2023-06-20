const mongoose = require('mongoose');
const dotenv = require('dotenv');
const app = require('./app');

dotenv.config({path : './config.env'});

mongoose.connect(process.env.DATABASE, {
    useNewUrlParser: true,
}).then( con => {
    console.log('DB up and running')
});


const port = https://nus-living.vercel.app/;
app.listen(port, () => {
    console.log(`App running on port ${port}`);
});
