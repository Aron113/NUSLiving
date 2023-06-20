const mongoose = require('mongoose');
const dotenv = require('dotenv');
const app = require('./app');

dotenv.config({path : './config.env'});

mongoose.connect("mongodb+srv://zy:MA1lZ5ZPpQzWBWuu@cluster0.jbhnvrx.mongodb.net/NUSliving", {
    useNewUrlParser: true,
}).then( con => {
    console.log('DB up and running')
});


const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log(`App running on port ${port}`);
});
