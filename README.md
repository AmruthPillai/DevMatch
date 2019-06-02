<img src="./assets/logo.png" alt="DevMatch" height="200px" />

# Find teammates for your next hackathon, smart and easy
## International Flutter Hackthon - Hack '19 / Flutter Bangalore Hub

## Introduction

**DevMatch** allows you to search for teammates for your next hackathon, by cross referencing your GitHub profile statistics with other people who are searching for mates. We have written our backend using [Cloud Functions](hhttps://firebase.google.com/docs/functions) to perform the analysis and aggregation of data from GitHub, and using powerful tools such as [Lodash](https://lodash.com/), we were able to gather vital stats with tested precision and speed. All our user data is stored on [Cloud Firestore](https://firebase.google.com/docs/firestore).

We use one of our own open source libraries, [GeoFlutterFire](https://github.com/DarshanGowda0/GeoFlutterFire), to collect users who are in searching mode and in a close proximity location, to ensure that we get users who are only within a given range.

## Demo

<img src="https://i.imgur.com/GkRWcPF.gif" alt="GIF Video" />

## The Secret Sauce

Further more, we use a custom TensorFlow Lite model deployed on Firebase's [ML Kit](https://firebase.google.com/products/ml-kit/) to run a basic recommender engine on the set of users who are currently on searching mode within a given location. We use a variety of statistics to check who would be a best match teammate using the data collected.

Some data points that we capture are:
* The follower/following ratio of each user, to gauge the popularity
* The activity and frequency of the user's commits and repos, to calculate how active the potential teammate is on GitHub
* The languages used within the repos of a user, to classify whether he/she is a backend or frontend dev (It makes sense to pair up with one of the other as it would lead to a complete product by the end of the hack)

## The Team

This wouldn't have been possible without our dream team:
* **Amruth Pillai** - [@AmruthPillai](https://github.com/AmruthPillai/)
* **Darshan Gowda** - [@DarshanGowda0](https://github.com/DarshanGowda0/)
* **Vinod Patel** - [@thevpatel](https://github.com/thevpatel/)
* **Satya Attili** - [@satyaattili](https://github.com/satyaattili/)
