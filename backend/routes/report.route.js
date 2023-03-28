const express = require("express");
const Schema = require("../models/report.model");
const router = express.Router();

router.post("/create-report", async (req, res) => {
  try {
    const report = new Schema({
      name: req.body.name,
      department: req.body.department,
      activity: req.body.activity,
    });
    const savedReport = await report.save();
    console.log(savedReport);
    res.json(savedReport);
  } catch (err) {
    console.error(err);
    res.json(err);
  }
});

router.get("/list-reports", async (req, res) => {
  try {
    const reports = await Schema.find();
    res.json(reports);
  } catch (err) {
    console.error(err);
    res.json(err);
  }
});

router.put("/update-report/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const updates = req.body;
    const options = { new: true };
    const result = await Schema.findByIdAndUpdate(id, updates, options);
    if (result === null) {
      res.status(404).json({ message: "Report not found" });
    } else {
      res.json({ message: "Report updated" });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
});

router.delete("/delete-report/:id", async (req, res) => {
  try {
    const id = req.params.id;
    console.log(id);
    const result = await Schema.findByIdAndDelete(id);
    if (result === null) {
      res.status(404).json({ message: "Report not found" });
    } else {
      res.json({ message: "Report deleted" });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
});

module.exports = router;
