const express = require("express");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const Schema = require("../models/user.model");
const router = express.Router();
const validator = require("validator");

router.post("/signup", async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!validator.isEmail(email)) {
      return res.status(400).json({ error: "Invalid email address" });
    }

    const existingUser = await Schema.findOne({ email });
    if (existingUser) {
      return res.status(409).json({ error: "Email address already in use" });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const user = new Schema({
      email,
      password: hashedPassword,
    });
    await user.save();

    const token = jwt.sign({ userId: user._id }, "HS256", {
      expiresIn: "1h",
    });

    res.json({ token });
    console.log(token);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Server error" });
  }
});

router.post("/signin", async (req, res) => {
  console.log(req.body);
  try {
    const { email, password } = req.body;
    if (!validator.isEmail(email)) {
      return res.status(400).json({ error: "Invalid email address" });
    }

    const user = await Schema.findOne({
      email,
    });

    if (!user) {
      return res.status(404).json({ error: "User email not found" });
    }

    // Check if the password is correct
    const passwordMatches = await bcrypt.compare(password, user.password);
    if (!passwordMatches) {
      return res.status(401).json({ error: "Incorrect password" });
    }

    // If everything is correct, generate a token and send it back to the client
    const token = jwt.sign({ userId: user._id }, "HS256", {
      expiresIn: "1h",
    });

    res.json({ token });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Server error, please try again later" });
  }
});

module.exports = router;
