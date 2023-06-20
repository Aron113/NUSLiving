const mongoose = require('mongoose');
const dotenv = require('dotenv');
const app = require('./app');
const cors = require('cors');
const corsOptions ={
    origin:'https://nusliving-a83dc.web.app', 
    credentials:true,            //access-control-allow-credentials:true
    optionSuccessStatus:200
}
app.use(cors(corsOptions));

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
