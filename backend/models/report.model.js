const mongoose = require("mongoose");

const ReportSchema = new mongoose.Schema({
  name: { type: String, required: true },
  department: { type: String, required: true },
  activity: { type: String, required: true },
});

const flutterAuthDB = mongoose.connection.useDb("flutterAuth");
const Schema = flutterAuthDB.model("reports", ReportSchema);

module.exports = Schema;
