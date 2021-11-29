import 'dart:convert';
import 'dart:math';

//You import Chopper to create instances of Response.
import 'package:chopper/chopper.dart';
//show means that you want a specific class or classes to be visible in your app.
//In this case, you want rootBundle to be visible for loading JSON files.
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_recipes_with_pref_data/network/model_response.dart';
import 'package:flutter_recipes_with_pref_data/network/recipe_model.dart';
import 'package:flutter_recipes_with_pref_data/network/service_interface.dart';

import 'package:http/http.dart' as http;

class MockService implements ServiceInterface {
  //Use _currentRecipes1 and _currentRecipes2 to store the results loaded from the two JSON files.
  late APIRecipeQuery _currentRecipes1;
  late APIRecipeQuery _currentRecipes2;

  //nextRecipe is an instance of Random that creates a number between 0 and 1.
  Random nextRecipe = Random();

  //The create() method, which Provider will call, just calls loadRecipes()
  void create() {
    loadRecipes();
  }

  void loadRecipes() async {
    //rootBundle loads the JSON file as a string.
    var jsonString = await rootBundle.loadString('assets/recipes1.json');
    //jsonDecode() creates a map that APIRecipeQuery will use to get a list of recipes.
    _currentRecipes1 = APIRecipeQuery.fromJson(
      jsonDecode(jsonString),
    );

    jsonString = await rootBundle.loadString('assets/recipes2.json');

    _currentRecipes2 = APIRecipeQuery.fromJson(jsonDecode(jsonString));
  }

  @override
  Future<Response<Result<APIRecipeQuery>>> queryRecipes(
      String query, int from, int to) {
    //Use your random field to pick a random integer, either 0 or 1.
    switch (nextRecipe.nextInt(2)) {
      case 0:
        //Wrap your APIRecipeQuery result in Success, Response and Future.
        return Future.value(
          Response(
            http.Response('Dummy', 200, request: null),
            Success<APIRecipeQuery>(_currentRecipes1),
          ),
        );

      case 1:
        return Future.value(
          Response(
            http.Response('Dummy', 200, request: null),
            Success<APIRecipeQuery>(_currentRecipes2),
          ),
        );

      default:
        return Future.value(
          Response(
            http.Response('Dummy', 200, request: null),
            Success<APIRecipeQuery>(_currentRecipes1),
          ),
        );
    }
  }
}
