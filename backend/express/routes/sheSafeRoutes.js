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
    // Call voiceTwilio function
    await SOS.voiceTwilio(req, res, next);

    // Call WhatsappMessage function
    await SOS.sendWhatsapp(req, res, next);

    // Call WhatsappMessage function
    await SOS.sendMessage(req, res, next);

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
