import 'models/models.dart';

abstract class Repository {
  //--Finding recipes and ingredients

  //Return all recipes in the repository.
  Future<List<Recipe>> findAllRecipes();
  //watchAllRecipes() watches for any changes to the list of recipes.
  //For example, if the user did a new search, it updates the list of recipes and notifies listeners accordingly.
  Stream<List<Recipe>> watchAllRecipes();
  //watchAllIngredients() listens for changes in the list of ingredients displayed on the Groceries screen.
  Stream<List<Ingredient>> watchAllIngredients();
  //Find a specific recipe by its ID.
  Future<Recipe> findRecipeById(int id);
  //Return all ingredients.
  Future<List<Ingredient>> findAllIngredients();
  //Find all the ingredients for the given recipe ID.
  Future<List<Ingredient>> findRecipeIngredients(int recipeId);

  //--Adding recipes and ingredients
  //Insert a new recipe.
  Future<int> insertRecipe(Recipe recipe);
  //Add all the given ingredients.
  Future<List<int>> insertIngredients(List<Ingredient> ingredients);

  //Deleting unwanted recipes and ingredients
  //Delete the given recipe.
  Future<void> deleteRecipe(Recipe recipe);
  //Delete the given ingredient.
  Future<void> deleteIngredient(Ingredient ingredient);
  //Delete all the given ingredients.
  Future<void> deleteIngredients(List<Ingredient> ingredients);
  //Delete all the ingredients for the given recipe ID.
  Future<void> deleteRecipeIngredients(int recipeId);

  //Initializing and closing the repository
  //Allow the repository to initialize. Databases might need to do some startup work.
  Future init();
  //Close the repository.
  void close();
}
