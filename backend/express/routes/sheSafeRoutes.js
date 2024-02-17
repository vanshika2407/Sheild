const express = require("express");
const router = express.Router();
const SafeController = require("../Controllers/SheSafeController");
const SOS = require("../Controllers/SOS");

router.get("/", (req, res) => {
  res.send("Hello World");
});
router.get("/police", SafeController.policeNearby);
router.get("/metro", SafeController.MetroNearby);
router.get("/hospitals", SafeController.HospitalsNearby);
router.get("/hotels", SafeController.HotelsNearby);
router.get("/initiate-call-and-msg", async (req, res, next) => {
  try {
    const name = req.query.name;
    const lat = req.query.latitude;
    const lng = req.query.longitude;
    const client = require('twilio')("ACb0bd2bde89479e44753306098a58d7b3", "e2e9396785dd81ac2df7ecfaf3c02c95");

    // const client = require("twilio")(accountSid, authToken);
    return await client.messages.create({
      body: `EMERGENCY! ${name} need help!. Please send assistance immediately. Thank you!.`,
      from: "whatsapp:+14155238886",
      to: "whatsapp:+919545491506",
      persistentAction: `geo:${lat},${lng}|${name}`,
    });
    // Call voiceTwilio function
    // await SOS.voiceTwilio(req, res, next);

    // // Call WhatsappMessage function
    // await SOS.sendWhatsapp(req, res, next);

    // // Call WhatsappMessage function
    // await SOS.sendMessage(req, res, next);

    // Send a response indicating both actions were triggered
    res
      .status(200)
      .json({ message: "Voice call and message initiated successfully" });
  } catch (error) {
    // Handle errors
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

module.exports = router;
