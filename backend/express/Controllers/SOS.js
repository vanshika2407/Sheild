const accountSid = "AC706392020643ef46293ccb54c5b19028";
const authToken = "9b1168bc8bc5e4c259cdf6ed7c852835";

// const sendWhatsapp = async (req, res, next) => {
//   const name = req.query.name;
//   const lat = req.query.latitude;
//   const lng = req.query.longitude;
//   //   const client = require("twilio")(
//   //     "ACb0bd2bde89479e44753306098a58d7b3",
//   //     "e2e9396785dd81ac2df7ecfaf3c02c95"
//   //   );

//   const client = require("twilio")(accountSid, authToken);
//   return await client.messages.create({
//     body: `EMERGENCY! ${name} need help!. Please send assistance immediately. Thank you!.`,
//     from: "whatsapp:+14155238886",
//     to: "whatsapp:+919545491506",
//     persistentAction: `geo:${lat},${lng}|${name}`,
//   });
// };

const sendWhatsapp = async (req, res, next) => {
  try {
    const name = req.query.name;
    const lat = req.query.latitude;
    const lng = req.query.longitude;

    const accountSid = "your_account_sid";
    const authToken = "your_auth_token";

    const client = require("twilio")(accountSid, authToken);

    const message = await client.messages.create({
      body: `EMERGENCY! ${name} needs help! Please send assistance immediately. Thank you!`,
      from: "whatsapp:+14155238886",
      to: "whatsapp:+919545491506",
      persistentAction: `geo:${lat},${lng}|${name}`,
    });

    console.log(`Message SID: ${message.sid}`);

    return res
      .status(200)
      .json({ success: true, message: "Emergency message sent successfully." });
  } catch (error) {
    console.error("Error sending WhatsApp message:", error);
    return res
      .status(500)
      .json({ success: false, message: "Error sending WhatsApp message." });
  }
};

const voiceTwilio = async (req, res, next) => {
  //   const accountSid = "AC706392020643ef46293ccb54c5b19028";
  //   const authToken = "b7e1df452934c2cafb40189e7663d303";
  const client = require("twilio")(accountSid, authToken);
  //   const client = require("twilio")(
  //     "ACb0bd2bde89479e44753306098a58d7b3",
  //     "e2e9396785dd81ac2df7ecfaf3c02c95"
  //   );

  const twilioNumber = "+13203217462";
  const destinationNumber = "+919987602844";

  try {
    const call = await client.calls.create({
      to: destinationNumber,
      from: twilioNumber,
      url: "http://raw.githubusercontent.com/vanshika2407/shesafeTrial/main/SheSafe2.xml",
      //url: "http://demo.twilio.com/docs/voice.xml", // Replace with your TwiML URL
    });

    console.log(`Call SID: ${call.sid}`);
    res.send(`Call SID: ${call.sid}`);
  } catch (error) {
    console.error(error);
    res.status(500).send("Error initiating call");
  }
};

const sendMessage = async (req, res, next) => {
  const name = req.query.name;
  const lat = req.query.latitude;
  const lng = req.query.longitude;
  const client = require("twilio")(accountSid, authToken);
  return await client.messages.create({
    body: `SOS Alert! ${name} needs help at this location : ${lat},${lng}`,
    from: "+13203217462",
    to: `+919987602844`,
    persistentAction: `geo:${lat},${lng}|${name}`,
  });
  //   .then(message => console.log);
};

exports.sendWhatsapp = sendWhatsapp;
exports.voiceTwilio = voiceTwilio;
exports.sendMessage = sendMessage;
