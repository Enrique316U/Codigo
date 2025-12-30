import "package:flutter/material.dart";
import "package:green_cloud/models/plant.dart";

final List<Plant> plants = [
  Plant(
    backgroundColor: Colors.green.shade100,
    name: "Aloe Vera",
    image: "assets/images/sansevieria.png",
    waterPercentage: 25,
    temperature: 22.6,
    humidity: 50,
    lightIntensity: 80,
  ),
  Plant(
    backgroundColor: Colors.teal.shade100,
    name: "Satlitiza Nicoli",
    image: "assets/imags/strelitzia.png",
    waterPercentage: 15,
    temperature: 20.4,
    humidity: 33,
    lightIntensity: 70,
  )
];
