import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  //Add the properties an ingredient needs.
  //You don’t declare recipeId or id as final so you can change those values later.
  int? id;
  int? recipeId;
  final String? name;
  final double? weight;

  //Declare a constructor with all the fields.
  Ingredient({this.id, this.recipeId, this.name, this.weight});

  //When equality checks are performed, Equatable uses the props value.
  //Here, you provide the fields you want to use to check for equality.
  @override
  List<Object?> get props => [recipeId, name, weight];

  // Create a Ingredient from JSON data
  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        id: json['ingredientId'],
        recipeId: json['recipeId'],
        name: json['name'],
        weight: json['weight'],
      );

// Convert our Ingredient to JSON to make it easier when you
// store it in the database
  Map<String, dynamic> toJson() => {
        'ingredientId': id,
        'recipeId': recipeId,
        'name': name,
        'weight': weight,
      };
}
