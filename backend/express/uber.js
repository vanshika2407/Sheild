const express = require("express");
const axios = require("axios");

const app = express();
const port = 3000;

const uberClientId = "Jacf-UMskDjwbEe-kA18BQA1NYXYCzNg";
const uberClientSecret = "o1kQ9Vrwwvg9CiKuVBuNYNqXAI2W6g98sUOaVoOg";
const redirectUri = "http://localhost:3000/callback";
const state = "7HOQPy2FK8n1mwMiUrTb3EfDauWk5ILR";

app.get("/", (req, res) => {
  // Step 1: Redirect the user to Uber's authorization URL
  const authorizationUrl = `https://login.uber.com/oauth/v2/authorize?client_id=${uberClientId}&response_type=code&redirect_uri=${redirectUri}&scope=request+profile&state=${state}`;
  res.redirect(authorizationUrl);
});

app.get("/callback", async (req, res) => {
  // Step 2: Handle the callback with the authorization code
  const authorizationCode = req.query.code;
  const returnedState = req.query.state;

  // Check the state to prevent CSRF attacks
  if (returnedState !== state) {
    return res.status(400).send("Invalid state parameter");
  }

  // Step 3: Exchange the authorization code for an access token
  try {
    const tokenResponse = await axios.post(
      "https://login.uber.com/oauth/v2/token",
      null,
      {
        params: {
          client_id: uberClientId,
          client_secret: uberClientSecret,
          grant_type: "authorization_code",
          redirect_uri: redirectUri,
          code: authorizationCode,
        },
      }
    );

    const accessToken = tokenResponse.data.access_token;

    // Step 4: Use the access token to request a ride
    const rideResponse = await axios.post(
      "https://api.uber.com/v1.2/requests",
      {
        product_id: "your_product_id", // Replace with the product ID corresponding to the Uber service you want
        start_latitude: 37.7749,
        start_longitude: -122.4194,
        end_latitude: 37.7749,
        end_longitude: -122.4194,
      },
      {
        headers: {
          Authorization: `Bearer ${accessToken}`,
        },
      }
    );

    // Handle the ride request response (inspect the response object)
    console.log("Ride Request Response:", rideResponse.data);

    // Redirect the user to the Uber app or web page for further details and confirmation
    const redirectUrl = `https://m.uber.com/ul/?client_id=${uberClientId}&pickup=my_location&dropoff[formatted_address]=${encodeURIComponent(
      "Destination Address"
    )}&dropoff[latitude]=${37.7749}&dropoff[longitude]=-122.4194`;
    res.redirect(redirectUrl);
  } catch (error) {
    console.error(
      "Error during token exchange or ride request:",
      error.message
    );
    res.status(500).send("Error during token exchange or ride request");
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
