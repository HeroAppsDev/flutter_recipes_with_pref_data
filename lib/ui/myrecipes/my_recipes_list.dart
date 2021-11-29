import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipes_with_pref_data/data/repository.dart';
import 'package:flutter_recipes_with_pref_data/data/models/models.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class MyRecipesList extends StatefulWidget {
  const MyRecipesList({Key? key}) : super(key: key);

  @override
  _MyRecipesListState createState() => _MyRecipesListState();
}

class _MyRecipesListState extends State<MyRecipesList> {
  List<Recipe> recipes = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildRecipeList(context),
    );
  }

  Widget _buildRecipeList(BuildContext context) {
    //Uses Provider to get your Repository.
    final repository = Provider.of<Repository>(context, listen: false);
    //Uses StreamBuilder, which uses a List<Recipe> stream type.
    return StreamBuilder<List<Recipe>>(
      //Uses the new watchAllRecipes() to return a stream of recipes for the builder to use.
      stream: repository.watchAllRecipes(),
      //Uses the builder callback to receive your snapshot.
      builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
        //Checks the state of the connection. When the state is active, you have data.
        if (snapshot.connectionState == ConnectionState.active) {
          final recipes = snapshot.data ?? [];

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (BuildContext context, int index) {
              final recipe = recipes[index];
              return SizedBox(
                height: 100,
                child: Slidable(
                  startActionPane: ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion: const ScrollMotion(),

                    // A pane can dismiss the Slidable.
                    dismissible: DismissiblePane(onDismissed: () {}),

                    // All actions are defined in the children parameter.
                    children: [
                      // A SlidableAction can have an icon and/or a label.
                      SlidableAction(
                          label: 'Delete',
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.black,
                          icon: Icons.delete,
                          onPressed: deleteRecipe(repository, recipe)),
                      const SlidableAction(
                        onPressed: null,
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.share,
                        label: 'Share',
                      ),
                    ],
                  ),
                  // The end action pane is the one at the right or the bottom side.
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                          label: 'Delete',
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.black,
                          icon: Icons.delete,
                          onPressed: deleteRecipe(repository, recipe))
                    ],
                  ),
                  child: Card(
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CachedNetworkImage(
                              imageUrl: recipe.image ?? '',
                              height: 120,
                              width: 60,
                              fit: BoxFit.cover),
                          title: Text(recipe.label ?? ''),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  Function(BuildContext)? deleteRecipe(Repository repository, Recipe recipe) {
    if (recipe.id != null) {
      //The repository to delete any recipe ingredients.
      repository.deleteRecipeIngredients(recipe.id!);
      //The repository to delete the recipe.
      repository.deleteRecipe(recipe);
      setState(() {});
    } else {
      debugPrint('## Recipe id is null');
    }
  }
}
