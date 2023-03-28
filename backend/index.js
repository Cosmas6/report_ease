const express = require("express");
const app = express();
const port = 8080 || process.env.PORT;
const cors = require("cors");
const bodyParser = require("body-parser");
var dbConn = require("./db/dbConn");

app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use("/", require("./routes/user.route"));
app.use("/", require("./routes/report.route"));
dbConn();

app.listen(port, () => {
  console.log("Port running on " + port);
});
