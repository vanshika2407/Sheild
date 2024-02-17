const express = require("express");
const router = express.Router();
const SafeController = require("../Controllers/SheSafeController");

//This route will give all books
router.get("/", (req, res) => {
    res.send("Hello World");
})
router.get("/police", SafeController.policeNearby);
router.get("/metro", SafeController.MetroNearby);
router.get("/hospitals", SafeController.HospitalsNearby);
router.get("/hotels", SafeController.HotelsNearby);

module.exports = router;
