const express = require("express");
const router = express.Router();
const { Client } = require("@googlemaps/google-maps-services-js");
const axios = require("axios");

const client = new Client({});

router.get("/", async (req, res) => {
  const origin = req.query.origin;
  const destination = req.query.destination;
  const routes = await getRoutes(origin, destination);

  console.log(routes);
  try {
    const response = await axios.post(
      "http://127.0.0.1:8088/safeScore",
      routes
    );
    console.log(response.data);
    res.json({ api: response.data, routes: routes });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }

  // res.json(response.data);
});

const getRoutes = async (origin, destination) => {
  try {
    const dt = await client.directions({
      params: {
        origin: origin,
        destination: destination,
        key: "AIzaSyD5fvYs9ENbAEbYROVycp3eVnkiEDceor0",
        alternatives: true,
        mode: ["driving", "walking", "transit"],
      },
      timeout: 1000,
    });
    const data = dt.data;

    // Initialize groupedSteps array to store the grouped steps for each route
    const groupedSteps = [];

    // Iterate over each route
    for (let i = 0; i < data.routes.length; i++) {
      const route = data.routes[i];
      // console.log(route.legs[0]);
      console.log("--");
      console.log(route.overview_polyline);
      console.log("--");
      const steps = route.legs[0].steps;
      let currentGroup = [];
      let currentDistance = 0;
      const routeGroupedSteps = []; // Grouped steps for the current route
      let avg_lat = 0;
      let avg_long = 0;

      // Iterate over each step in the route
      for (let j = 0; j < steps.length; j++) {
        const step = steps[j];
        const stepDistance = step.distance.value;

        if (currentDistance < 1000 || currentDistance + stepDistance <= 1000) {
          if (currentGroup.length === 0) {
            avg_lat = step.start_location.lat;
            avg_long = step.start_location.lng;
          }
          currentGroup.push(step);
          currentDistance += stepDistance;
        } else {
          avg_lat = (avg_lat + step.end_location.lat) / 2;
          avg_long = (avg_long + step.end_location.lng) / 2;
          currentGroup.push([avg_lat, avg_long]);
          routeGroupedSteps.push(currentGroup);
          currentGroup = [step];
          currentDistance = stepDistance;
        }
      }

      // Handle the last group
      if (currentGroup.length > 0) {
        avg_lat = currentGroup[0].start_location.lat;
        avg_long = currentGroup[0].start_location.lng;
        const lastStep = currentGroup[currentGroup.length - 1];
        const avg_lat_1 = lastStep.end_location.lat;
        const avg_long_1 = lastStep.end_location.lng;
        currentGroup.push([
          (avg_lat_1 + avg_lat) / 2,
          (avg_long_1 + avg_long) / 2,
        ]);
        routeGroupedSteps.push(currentGroup);
      }

      // Push the grouped steps for the current route to groupedSteps array
      groupedSteps.push({
        grouped: routeGroupedSteps,
        polyline: route.overview_polyline,
        distance: route.legs[0].distance.text,
        duration: route.legs[0].duration.text,
      });
    }

    // Now groupedSteps contains grouped steps for each route

    //
    // const steps = data.routes[0].legs[0].steps;
    // let currentGroup = [];
    // let currentDistance = 0;
    // const groupedSteps = [];
    // avg_lat = 0
    // for (let i = 0; i < steps.length; i++) {
    //     const step = steps[i];
    //     const stepDistance = step.distance.value;

    //     if (currentDistance < 1000 || currentDistance + stepDistance <= 1000) {
    //         if (currentGroup.length == 0) {
    //             avg_lat = step.start_location.lat
    //             avg_long = step.start_location.lng
    //         }
    //         currentGroup.push(step);
    //         currentDistance += stepDistance;
    //     } else {

    //         avg_lat = (avg_lat + step.end_location.lat) / 2
    //         avg_long = (avg_long + step.end_location.lng) / 2
    //         currentGroup.push([avg_lat, avg_long])

    //         groupedSteps.push(currentGroup);
    //         currentGroup = [step];
    //         currentDistance = stepDistance;
    //     }
    // }

    // if (currentGroup.length > 0) {
    //     avg_lat = currentGroup[0].start_location.lat
    //     avg_long = currentGroup[0].start_location.lng

    //     avg_lat_1 = currentGroup[currentGroup.length - 1].end_location.lat
    //     avg_long_1 = currentGroup[currentGroup.length - 1].end_location.lng

    //     currentGroup.push([(avg_lat_1 + avg_lat) / 2, (avg_long_1 + avg_long) / 2])
    //     groupedSteps.push(currentGroup);
    // }

    // console.log(data)
    // fs.writeFileSync("data.json", JSON.stringify(data));

    return groupedSteps;
    // fs.writeFileSync('data.json', JSON.stringify(dt.data));
  } catch (error) {
    console.log(error);
  }
};

module.exports = router;
