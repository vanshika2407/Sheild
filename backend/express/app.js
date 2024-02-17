const express = require('express');
const app = express();
const cors = require('cors');
const router = require('./routes/sheSafeRoutes');
const routesRouter = require('./routes/routesRouter');
//Middleware
app.use(express.json());
app.use(cors());
app.use("/", router)
app.use("/routes", routesRouter)

//localhost:5000/books
app.listen(80, () => {
    console.log("Server is running on port 80");
});
