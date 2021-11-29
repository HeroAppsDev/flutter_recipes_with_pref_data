import 'package:chopper/chopper.dart';
import 'package:flutter_recipes_with_pref_data/network/model_converter.dart';
import 'package:flutter_recipes_with_pref_data/network/recipe_model.dart';

import 'service_interface.dart';
import 'model_response.dart';

part 'recipe_service.chopper.dart';

const String apiKey = '865bee1f976f09ac534c238cfe866738';
const String apiId = '7c09b422';
const String apiUrl = 'https://api.edamam.com';

@ChopperApi()
abstract class RecipeService extends ChopperService
    implements ServiceInterface {
  @override
  @Get(
      path:
          'search') //@Get is an annotation that tells the generator this is a GET request with a path named search,
  Future<Response<Result<APIRecipeQuery>>> queryRecipes(
      @Query('q') String query, @Query('from') int from, @Query('to') int to);

  static RecipeService create() {
    //Create a ChopperClient instance.
    final client = ChopperClient(
        //Pass in a base URL using the apiUrl constant.
        baseUrl: apiUrl,
        //Pass in two interceptors. _addQuery() adds your key and ID to the query.
        //HttpLoggingInterceptor is part of Chopper and logs all calls. It’s handy while you’re developing to see traffic between the app and the server.
        interceptors: [_addQuery, HttpLoggingInterceptor()],
        //Set the converter as an instance of ModelConverter.
        converter: ModelConverter(),
        //Use the built-in JsonConverter to decode any errors.
        errorConverter: const JsonConverter(),
        //Define the services created when you run the generator script.
        services: [
          _$RecipeService(),
        ]);
    //Return an instance of the generated service.
    return _$RecipeService(client);
  }
}

Request _addQuery(Request req) {
  //Creates a Map, which contains key-value pairs from the existing Request parameters.
  final params = Map<String, dynamic>.from(req.parameters);

  //Adds the app_id and the app_key parameters to the map.
  params['app_id'] = apiId;
  params['app_key'] = apiKey;

  //Returns a new copy of the Request with the parameters contained in the map.
  return req.copyWith(parameters: params);
}
