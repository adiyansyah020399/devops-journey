const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());

app.get("/", (req, res) => {

    res.json({
        message: "🚀 Hello from backend container"
    });

});

app.listen(3000, () => {

    console.log("Backend running on port 3000");

});
