const { Client } = require("@googlemaps/google-maps-services-js");
const fs = require("fs");

const client = new Client({});
const placeIdsP = [];
const placeIdsM = [];
const placeIdsH = [];
const placeIdsHotel = [];

const policeNearby = async (req, res, next) => {
  const currentLocation = {
    lat: req.query.latitude,
    lng: req.query.longitude,
  };
  const distancesP = [];
  let policeJson = {};
  let policeObj = {};
  try {
    const allP = [];
    const dt = await client.placesNearby({
      params: {
        types: ["police"],
        location: `${currentLocation.lat},${currentLocation.lng}`,
        radius: 1000,
        key: "AIzaSyD5fvYs9ENbAEbYROVycp3eVnkiEDceor0",
      },

      timeout: 1000,
    });
    // console.log("dt:", dt.data);
    const placesWithDistanceP = [];

    for (let i = 0; i < dt.data.results.length; i++) {
      const place = dt.data.results[i];
      const placeLocation = place.geometry.location;
      const distanceP = calculateDistance(currentLocation, placeLocation);
      // console.log("distanceP", distanceP)
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
    policeJson = JSON.stringify(dt.data);
    // fs.writeFileSync("dataP.json", JSON.stringify(dt.data));

    allP.push(minDistanceP);
    allP.push(avgDistanceP);
    allP.push(countP);
    // console.log(
    //   " Min Distance:",
    //   allP[0],
    //   "Average Distance: ",
    //   allP[1],
    //   "Count: ",
    //   allP[2]
    // );
    const newPlacesArrayP = placeIdsP.map((place) => {
      return {
        latitude: place.geometry.location.lat,
        longitude: place.geometry.location.lng,
        name: place.name,
        phoneNumber:
          place.formatted_phone_number?.place.formatted_phone_number || [],
        weekdayText: place.current_opening_hours?.weekday_text || [],
        formattedAddress: place.formatted_address,
        rating: place.rating,
      };
    });
    policeObj = {
      policeJson: policeJson,
      allP: allP,
      placeIdsP: newPlacesArrayP,
    };
  } catch (error) {
    console.log(error);
  }
  return res.status(200).json(policeObj);
};

//Metro Stations
const MetroNearby = async (req, res, next) => {
  const currentLocation = {
    lat: req.query.latitude,
    lng: req.query.longitude,
  };
  const distancesM = [];
  let MetroJson = {};
  const allM = [];
  let MetroObj = {};
  try {
    const mt = await client.placesNearby({
      params: {
        types: ["subway_station"],
        location: `${currentLocation.lat},${currentLocation.lng}`,
        radius: 1000,
        key: "AIzaSyD5fvYs9ENbAEbYROVycp3eVnkiEDceor0",
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
    allM.push(minDistanceM);
    allM.push(countM);
    MetroJson = JSON.stringify(mt.data);
    const newPlacesArrayM = placeIdsM.map((place) => {
      return {
        latitude: place.geometry.location.lat,
        longitude: place.geometry.location.lng,
        name: place.name,
        //phoneNumber:
        // place.formatted_phone_number?.place.formatted_phone_number || [],
        weekdayText: place.current_opening_hours?.weekday_text || [],
        formattedAddress: place.formatted_address,
        rating: place.rating,
      };
    });
    MetroObj = {
      MetroJson: MetroJson,
      allM: allM,
      placeIdsM: newPlacesArrayM,
    };
  } catch (error) {
    console.log(error);
  }
  // console.log(MetroObj);
  return res.status(200).json(MetroObj);
};

//Hospitals
const HospitalsNearby = async (req, res, next) => {
  const currentLocation = {
    lat: req.query.latitude,
    lng: req.query.longitude,
  };
  const distancesH = [];
  const allH = [];
  const HospitalJson = {};
  try {
    const ht = await client.placesNearby({
      params: {
        types: ["hospital"],
        location: `${currentLocation.lat},${currentLocation.lng}`,
        radius: 1000,
        key: "AIzaSyD5fvYs9ENbAEbYROVycp3eVnkiEDceor0",
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
    HospitalJson = JSON.stringify(ht.data);
    allH.push(minDistanceH);
    allH.push(countH);
  } catch (error) {
    console.log(error);
  }

  const newPlacesArrayH = placeIdsH.map((place) => {
    return {
      latitude: place.geometry.location.lat,
      longitude: place.geometry.location.lng,
      name: place.name,
      phoneNumber:
        place?.formatted_phone_number?.place?.formatted_phone_number || [],
      weekdayText: place.current_opening_hours?.weekday_text || [],
      formattedAddress: place.formatted_address,
      rating: place.rating,
    };
  });
  const HospitalObj = {
    HospitalJson: HospitalJson,
    allH: allH,
    placeIdsH: newPlacesArrayH,
  };
  return res.status(200).json(HospitalObj);
};

//Hotel
const HotelsNearby = async (req, res, next) => {
  const currentLocation = {
    lat: req.query.latitude,
    lng: req.query.longitude,
  };
  const distancesHot = [];
  const allHot = [];
  const HotelsJson = {};
  try {
    const hot = await client.placesNearby({
      params: {
        types: ["hotel"],
        location: `${currentLocation.lat},${currentLocation.lng}`,
        radius: 1000,
        key: "AIzaSyD5fvYs9ENbAEbYROVycp3eVnkiEDceor0",
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
    HotelsJson = JSON.stringify(hot.data);
    allHot.push(minDistanceHot);
    allHot.push(countHot);
  } catch (error) {
    console.log(error);
  }

  const newPlacesArrayHot = placeIdsHotel.map((place) => {
    return {
      latitude: place.geometry.location.lat,
      longitude: place.geometry.location.lng,
      name: place.name,
      phoneNumber:
        place?.formatted_phone_number?.place?.formatted_phone_number || [],
      weekdayText: place.current_opening_hours?.weekday_text || [],
      formattedAddress: place.formatted_address,
      rating: place.rating,
    };
  });

  const HotelsObj = {
    HotelsJson: HotelsJson,
    allHot: allHot,
    placeIdsHotel: newPlacesArrayHot,
  };
  return res.status(200).json(HotelsObj);
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
        key: "AIzaSyD5fvYs9ENbAEbYROVycp3eVnkiEDceor0",
      },

      timeout: 1000,
    });
    return p;
  } catch (err) {
    console.log(err);
  }
};

// async function getAll() {
//   await policeNearby();
//   await MetroNearby();
//   await HospitalsNearby();
//   await HotelsNearby();
// }

//getAll();
exports.policeNearby = policeNearby;
exports.MetroNearby = MetroNearby;
exports.HospitalsNearby = HospitalsNearby;
exports.HotelsNearby = HotelsNearby;
