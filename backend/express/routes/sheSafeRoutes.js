const express = require("express");
const router = express.Router();
const SafeController = require("../Controllers/SheSafeController");
const SOS = require("../Controllers/SOS");

router.get("/police", SafeController.policeNearby);
router.get("/metro", SafeController.MetroNearby);
router.get("/hospitals", SafeController.HospitalsNearby);
router.get("/hotels", SafeController.HotelsNearby);
router.get("/voice", SOS.voiceTwilio);
router.get("/wp", SOS.sendWhatsapp);
router.get("/message", SOS.sendMessage);

module.exports = router;

// router.get("/initiate-call-and-msg", async (req, res, next) => {
//   try {
//     // Call voiceTwilio function
//     await SOS.voiceTwilio(req);

//     // Call sendWhatsapp function
//     //await SOS.sendWhatsapp(req);

//     // Call sendMessage function
//     //await SOS.sendMessage(req);

//     // Send a response indicating both actions were triggered
//     res.status(200).json({
//       message: "Voice call and message initiated successfully",
//     });
//   } catch (error) {
//     // Handle errors
//     console.error(error);
//     res.status(500).json({ error: "Internal Server Error" });
//   }
// });
