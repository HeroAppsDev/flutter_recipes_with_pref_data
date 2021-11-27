import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter_recipes_with_pref_data/network/model_response.dart';
import 'package:flutter_recipes_with_pref_data/network/recipe_model.dart';

//Use ModelConverter to implement the Chopper Converter abstract class.
class ModelConverter implements Converter {
  //Override convertRequest(), which takes in a request and returns a new request.
  @override
  FutureOr<Request> convertRequest(Request request) {
    final req = applyHeader(
      request,
      contentTypeKey,
      jsonHeaders, //Add a header to the request that says you have a request type of application/json using jsonHeaders. These constants are part of Chopper.
      override: false,
    );

    return encodeJson(req);
  }

  @override
  FutureOr<Response<BodyType>> convertResponse<BodyType, InnerType>(
      Response response) {
    //This method changes the given response to the one you want.
    return decodeJson<BodyType, InnerType>(response);
  }

  Request encodeJson(Request request) {
    //Extract the content type from the request headers.
    final contentType = request.headers[contentTypeKey];

    //Confirm contentType is of type application/json.
    if (contentType != null && contentType.contains(jsonHeaders)) {
      // Make a copy of the request with a JSON-encoded body.
      return request.copyWith(body: json.encode(request.body));
    }

    return request;
  }

  Response<BodyType> decodeJson<BodyType, InnerType>(Response response) {
    final contentType = response.headers[contentTypeKey];

    var body = response.body;
    //Check that you’re dealing with JSON and decode the response into a string named body.
    if (contentType != null && contentType.contains(jsonHeaders)) {
      //Use JSON decoding to convert that string into a map representation.
      body = utf8.decode(response.bodyBytes);
    }

    try {
      final mapData = json.decode(body);

      //When there’s an error, the server returns a field named status.
      if (mapData['status'] != null) {
        return response.copyWith<BodyType>(
            body: Error(Exception(mapData['status'])) as BodyType);
      }

      //Use APIRecipeQuery.fromJson() to convert the map into the model class.
      final recipeQuery = APIRecipeQuery.fromJson(mapData);

      //Return a successful response that wraps recipeQuery.
      return response.copyWith<BodyType>(
          body: Success(recipeQuery) as BodyType);
    } catch (e) {
      //If you get any other kind of error, wrap the response with a generic instance of Error.
      chopperLogger.warning(e);
      return response.copyWith<BodyType>(
          body: Error(e as Exception) as BodyType);
    }
  }
}
