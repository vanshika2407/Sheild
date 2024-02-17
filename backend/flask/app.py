from flask import Flask, request, jsonify
import requests
import random
from model import regressor, median_value

from sos import isSos
import json
import numpy as np

app = Flask(__name__)


# hello
def time_to_one_hot(hour, minute):
    # Define the number of four-hour intervals in a day
    num_intervals = 6

    # Calculate the four-hour interval index
    interval_index = (hour // 4) % num_intervals

    # Create an empty one-hot encoding list
    one_hot_encoding = [0] * num_intervals

    # Set the appropriate index to 1 for the calculated interval
    one_hot_encoding[interval_index] = 1

    return one_hot_encoding


def jsonify_data(data):
    json_data = []
    for route in data:
        json_route = []
        for step in route:
            json_step = {}
            for key, value in step.items():
                if isinstance(value, np.ndarray):
                    json_step[key] = value.tolist()
                elif isinstance(value, dict):
                    json_step[key] = {}
                    for sub_key, sub_value in value.items():
                        if isinstance(sub_value, np.ndarray):
                            json_step[key][sub_key] = sub_value.tolist()
                        else:
                            json_step[key][sub_key] = sub_value
                else:
                    json_step[key] = value
            json_route.append(json_step)
        json_data.append(json_route)
    return json_data


@app.route("/isSos", methods=["POST"])
def check_sos():
    dt = request.get_json()
    print(dt)
    text = dt["text"]
    safeword = dt["safeword"]

    res = isSos(text, safeword)
    print(res)
    return res


@app.route("/safeScore", methods=["POST"])
def safe_score():
    # load the json data into a dictionary

    try:
        departure_time = 0
        data = request.get_json()
        print(data)
        sf = []
        for k in range(len(data)):
            temp = []
            for j in range(len(data[k])):
                # print(data[i]["grouped"])
                temp.append(data[k]["grouped"][j][-1])

            start = 00
            safety_score = []
            avg = 0
            cnt = 0
            for i in range(len(temp)):

                params = {"latitude": temp[i][0], "longitude": temp[i][1]}
                response = requests.get("http://localhost/police", params=params)
                response2 = requests.get("http://localhost/metro", params=params)

                # Store the response JSON in a file
                # with open("response.json", "w") as file:
                print(response.json())
                allP = response.json()["allP"]
                allM = response2.json()["allM"]
                nearestP = allP[0]
                avgP = allP[1]
                countP = allP[2]
                nearestM = allM[0]

                population = random.randint(100000, 500000)

                input = time_to_one_hot(start, 0)
                input.append(nearestM or -1)
                input.append(nearestP)
                input.append(avgP)
                input.append(countP)
                input.append(population)

                print("Input: ", input)
                yy = regressor.predict([input])
                safety_score.append((yy / median_value)[0])
                avg += (yy / median_value)[0]
                cnt += 1
                stub = random.randint(0, 4)

                start += stub
                if start > 23:
                    start = 0

            print()
            print(data[k]["polyline"])
            print()
            sf.append(
                {
                    # "scores": safety_score,
                    "safety_score": avg / cnt,
                    "polyline": data[k]["polyline"],
                    "distance": data[k]["distance"],
                    "duration": data[k]["duration"],
                }
            )
            # print(response2.json()["allM"])

            # print(response.json()["allP"])
            print("---")
        # print(data)
        # with open("response.json", "w") as file:
        #     json.dump({"dt": data}, file)
        print(safety_score)
        return json.dumps(sf)
    except Exception as e:
        print(e)

    return "asd"
    # Convert NumPy arrays to lists
    # for route in data:
    #     for step in route:
    #         if isinstance(step, np.ndarray):
    #             step = step.tolist()
    #         elif isinstance(step, dict):
    #             print("--")
    #             print(step)
    #             print("--")
    #             for key, value in step.items():
    #                 if isinstance(value, dict):
    #                     for sub_key, sub_value in value.items():
    #                         if isinstance(sub_value, np.ndarray):
    #                             step[key][sub_key] = sub_value.tolist()
    #                 elif isinstance(value, np.ndarray):
    #                     route[key] = value.tolist()

    # print("--main--")
    # print(data)
    # print("--main--")
    # json_data = jsonify_data(data)
    # return jsonify(data)
    # return json.dump({"dt": data},fp=)


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True, port=8088)
