import 'package:equatable/equatable.dart';
import 'package:flutter_recipes_with_pref_data/data/models/models.dart';

class Recipe extends Equatable {
  //Recipe properties for the recipe text: label, image and url.
  //id is not final so you can update it.
  int? id;
  final String? label;
  final String? image;
  final String? url;

  //A list of ingredients that the recipe contains along with its calories, weight and time to cook.
  List<Ingredient>? ingredients;
  final double? calories;
  final double? totalWeight;
  final double? totalTime;

  //A constructor with all fields except ingredients, which you’ll add later.
  Recipe(
      {this.id,
      this.label,
      this.image,
      this.url,
      this.calories,
      this.totalWeight,
      this.totalTime});

  //Equatable properties, which you’ll use for comparison.
  @override
  List<Object?> get props =>
      [label, image, url, calories, totalWeight, totalTime];
  // Create a Recipe from JSON data
  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['recipeId'],
        label: json['label'],
        image: json['image'],
        url: json['url'],
        calories: json['calories'],
        totalWeight: json['totalWeight'],
        totalTime: json['totalTime'],
      );

  // Convert our Recipe to JSON to make it easier when you store
  // it in the database
  Map<String, dynamic> toJson() => {
        'recipeId': id,
        'label': label,
        'image': image,
        'url': url,
        'calories': calories,
        'totalWeight': totalWeight,
        'totalTime': totalTime,
      };
}
