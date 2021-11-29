import 'dart:async';

import 'package:flutter_recipes_with_pref_data/data/models/models.dart';
import 'package:flutter_recipes_with_pref_data/data/repository.dart';

//MemoryRepository extends Repository
class MemoryRepository extends Repository {
  // **Finding stored recipes and ingredients
  //You initialize your current list of recipes.
  final List<Recipe> _currentRecipes = <Recipe>[];

  //Then you initialize your current list of ingredients.
  final List<Ingredient> _currentIngredients = <Ingredient>[];

  //_recipeStream and ingredientStream are private fields for the streams.
  //These will be captured the first time a stream is requested, which prevents new streams from being created for each call.
  Stream<List<Recipe>>? _recipeStream;
  Stream<List<Ingredient>>? _ingredientStream;

  //Creates StreamControllers for recipes and ingredients.
  final StreamController _recipeStreamController =
      StreamController<List<Recipe>>();

  final StreamController _ingredientStreamController =
      StreamController<List<Ingredient>>();

  //Check to see if you already have the stream. If not, call the stream method, which creates a new stream, then return it.
  @override
  Stream<List<Recipe>> watchAllRecipes() {
    _recipeStream ??= _recipeStreamController.stream as Stream<List<Recipe>>;

    return _recipeStream!;
  }

  //Do the same for ingredients.
  @override
  Stream<List<Ingredient>> watchAllIngredients() {
    _ingredientStream ??=
        _ingredientStreamController.stream as Stream<List<Ingredient>>;

    return _ingredientStream!;
  }

  @override
  //Change the method to return a Future.
  Future<List<Recipe>> findAllRecipes() {
    //Wrap the return value with a Future.value().
    return Future.value(_currentRecipes);
  }

  @override
  Future<Recipe> findRecipeById(int id) {
    //Uses firstWhere to find a recipe with the given ID.
    return Future.value(
        _currentRecipes.firstWhere((recipe) => recipe.id == id));
  }

  @override
  Future<List<Ingredient>> findAllIngredients() {
    //Returns your current ingredient list.
    return Future.value(_currentIngredients);
  }

  @override
  Future<List<Ingredient>> findRecipeIngredients(int recipeId) {
    //Finds a recipe with the given ID.
    final recipe =
        _currentRecipes.firstWhere((recipe) => recipe.id == recipeId);

    //Uses where to find all the ingredients with the given recipe ID.
    final recipeIngredients = _currentIngredients
        .where((ingredient) => ingredient.recipeId == recipe.id)
        .toList();

    return Future.value(recipeIngredients);
  }

  //*Adding recipes and ingredient lists

  @override
  //Update the method’s return type to be Future.
  Future<int> insertRecipe(Recipe recipe) {
    //Add the recipe to your list.
    _currentRecipes.add(recipe);
    //Add _currentRecipes to the recipe sink.
    _recipeStreamController.sink.add(_currentRecipes);
    //Call the method to add all the recipe’s ingredients.
    if (recipe.ingredients != null) {
      insertIngredients(recipe.ingredients!);
    }

    //Return the ID of the new recipe. Since you don’t need it, it’ll always return 0.
    return Future.value(0);
  }

  @override
  Future<List<int>> insertIngredients(List<Ingredient> ingredients) {
    //Check to make sure there are some ingredients.
    if (ingredients.isNotEmpty) {
      //Add all the ingredients to your list.
      _currentIngredients.addAll(ingredients);
      _ingredientStreamController.sink.add(_currentIngredients);
    }

    //Return the list of IDs added. An empty list for now.
    return Future.value(<int>[]);
  }

  //*Deleting recipes and ingredients
  @override
  Future<void> deleteRecipe(Recipe recipe) {
    //Remove the recipe from your list.
    _currentRecipes.remove(recipe);

    _recipeStreamController.sink.add(_currentRecipes);
    //Delete all the ingredients for this recipe.
    if (recipe.id != null) {
      deleteRecipeIngredients(recipe.id!);
    }

    return Future.value();
  }

  @override
  Future<void> deleteIngredient(Ingredient ingredient) {
    //Remove the ingredients from your list.
    _currentIngredients.remove(ingredient);
    _ingredientStreamController.sink.add(_currentIngredients);

    return Future.value();
  }

  @override
  Future<void> deleteIngredients(List<Ingredient> ingredients) {
    //Remove all ingredients that are in the passed-in list.
    _currentIngredients
        .removeWhere((ingredient) => ingredients.contains(ingredient));

    _ingredientStreamController.sink.add(_currentIngredients);

    return Future.value();
  }

  @override
  Future<void> deleteRecipeIngredients(int recipeId) {
    //Go through all ingredients and look for ingredients that have the given recipe ID, then remove them.
    _currentIngredients
        .removeWhere((ingredient) => ingredient.recipeId == recipeId);
    _ingredientStreamController.sink.add(_currentIngredients);

    return Future.value();
  }

  //Since this is a memory repository, you don’t need to do anything to initialize
  //and close but you need to implement these methods.
  @override
  Future init() {
    return Future.value();
  }

  @override
  void close() {
    _recipeStreamController.close();
    _ingredientStreamController.close();
  }
}
