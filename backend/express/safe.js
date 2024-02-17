const { Client } = require("@googlemaps/google-maps-services-js");
const fs = require("fs");

const client = new Client({});
const placeIdsP = [];
const placeIdsM = [];
const placeIdsH = [];
const placeIdsHotel = [];

const policeNearby = async () => {
  const currentLocation = { lat: 19.132, lng: 72.8361 };
  const distancesP = [];
  try {
    const dt = await client.placesNearby({
      params: {
        types: ["police"],
        location: "19.132,72.8361",
        radius: 1000,
        key: "AIzaSyDtnPmw3rJGTqdCbNl_GAHvNK6XHEO-0aU",
      },

      timeout: 1000,
    });

    const placesWithDistanceP = [];

    for (let i = 0; i < dt.data.results.length; i++) {
      const place = dt.data.results[i];
      const placeLocation = place.geometry.location;
      const distanceP = calculateDistance(currentLocation, placeLocation);
      distancesP.push(distanceP);
      placeIdsP.push((await Details(place.place_id)).data.result);
      placesWithDistanceP.push({
        ...place,
        distance: distanceP,
      });
    }

    const minDistanceP = Math.min(...distancesP);
    const countP = dt.data.results.length;
    const sumDistanceP = distancesP.reduce(
      (sum, distance) => sum + distance,
      0
    );
    const avgDistanceP = sumDistanceP / countP;
    fs.writeFileSync("dataP.json", JSON.stringify(dt.data));
    allP = [];
    allP.push(minDistanceP);
    allP.push(avgDistanceP);
    allP.push(countP);
    console.log(
      " Min Distance:",
      allP[0],
      "Average Distance: ",
      allP[1],
      "Count: ",
      allP[2]
    );
    console.log("Police: ", placeIdsP);
  } catch (error) {
    console.log(error);
  }
};

//Metro Stations
const MetroNearby = async () => {
  const currentLocation = { lat: 19.132, lng: 72.8361 };
  const distancesM = [];
  try {
    const mt = await client.placesNearby({
      params: {
        types: ["subway_station"],
        location: "19.132,72.8361",
        radius: 1000,
        key: "AIzaSyDtnPmw3rJGTqdCbNl_GAHvNK6XHEO-0aU",
      },

      timeout: 1000,
    });

    const placesWithDistanceM = [];

    for (let i = 0; i < mt.data.results.length; i++) {
      const place = mt.data.results[i];
      const placeLocation = place.geometry.location;
      const distanceM = calculateDistance(currentLocation, placeLocation);
      distancesM.push(distanceM);
      placeIdsM.push((await Details(place.place_id)).data.result);
      placesWithDistanceM.push({
        ...place,
        distance: distanceM,
      });
    }

    const minDistanceM = Math.min(...distancesM);
    const countM = mt.data.results.length;
    fs.writeFileSync("dataM.json", JSON.stringify(mt.data));
    allM = [];
    allM.push(minDistanceM);
    allM.push(countM);
    console.log(" Min Distance:", allM[0], "Count: ", allM[1]);
    console.log("Metro: ", placeIdsM);
  } catch (error) {
    console.log(error);
  }
};

//Hospitals
const HospitalsNearby = async () => {
  const currentLocation = { lat: 19.132, lng: 72.8361 };
  const distancesH = [];
  try {
    const ht = await client.placesNearby({
      params: {
        types: ["hospital"],
        location: "19.132,72.8361",
        radius: 1000,
        key: "AIzaSyDtnPmw3rJGTqdCbNl_GAHvNK6XHEO-0aU",
      },

      timeout: 1000,
    });

    const placesWithDistanceH = [];

    for (let i = 0; i < ht.data.results.length; i++) {
      const place = ht.data.results[i];
      const placeLocation = place.geometry.location;
      const distanceH = calculateDistance(currentLocation, placeLocation);
      distancesH.push(distanceH);
      placeIdsH.push((await Details(place.place_id)).data.result);
      placesWithDistanceH.push({
        ...place,
        distance: distanceH,
      });
    }
    const minDistanceH = Math.min(...distancesH);
    const countH = ht.data.results.length;
    fs.writeFileSync("dataH.json", JSON.stringify(ht.data));
    allH = [];
    allH.push(minDistanceH);
    allH.push(countH);
    console.log(" Min Distance:", allH[0], "Count: ", allH[1]);
    console.log("Hospitals: ", placeIdsH);
  } catch (error) {
    console.log(error);
  }
};

//Hotel
const HotelsNearby = async () => {
  const currentLocation = { lat: 19.132, lng: 72.8361 };
  const distancesHot = [];
  try {
    const hot = await client.placesNearby({
      params: {
        types: ["hotel"],
        location: "19.132,72.8361",
        radius: 1000,
        key: "AIzaSyDtnPmw3rJGTqdCbNl_GAHvNK6XHEO-0aU",
      },

      timeout: 1000,
    });

    const placesWithDistanceHot = [];

    for (let i = 0; i < hot.data.results.length; i++) {
      const place = hot.data.results[i];
      const placeLocation = place.geometry.location;
      const distanceHot = calculateDistance(currentLocation, placeLocation);
      distancesHot.push(distanceHot);
      placeIdsHotel.push((await Details(place.place_id)).data.result);
      placesWithDistanceHot.push({
        ...place,
        distance: distanceHot,
      });
    }

    const minDistanceHot = Math.min(...distancesHot);
    const countHot = hot.data.results.length;
    fs.writeFileSync("dataHot.json", JSON.stringify(hot.data));
    allHot = [];
    allHot.push(minDistanceHot);
    allHot.push(countHot);
    console.log(" Min Distance:", allHot[0], "Count: ", allHot[1]);
    console.log("Hotels: ", placeIdsHotel);
  } catch (error) {
    console.log(error);
  }
};

// Haversine formula to calculate distance between two points on the Earth
function calculateDistance(point1, point2) {
  const R = 6371; // Radius of the Earth in kilometers
  const dLat = degToRad(point2.lat - point1.lat);
  const dLng = degToRad(point2.lng - point1.lng);

  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(degToRad(point1.lat)) *
    Math.cos(degToRad(point2.lat)) *
    Math.sin(dLng / 2) *
    Math.sin(dLng / 2);

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  const distance = R * c; // Distance in kilometers

  return distance;
}

function degToRad(degrees) {
  return degrees * (Math.PI / 180);
}

const Details = async (placeId) => {
  try {
    const p = await client.placeDetails({
      params: {
        place_id: placeId,
        key: "AIzaSyDtnPmw3rJGTqdCbNl_GAHvNK6XHEO-0aU",
      },

      timeout: 1000,
    });
    return p;
  } catch (err) {
    console.log(err);
  }
};

async function getAll() {
  await policeNearby();
  await MetroNearby();
  await HospitalsNearby();
  await HotelsNearby();
}

getAll();
