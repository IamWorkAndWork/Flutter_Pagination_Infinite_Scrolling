import 'dart:convert';

import 'package:flutter_pagination_infinite_scrolling/config.dart';
import 'package:flutter_pagination_infinite_scrolling/models/github_response_model.dart';
import 'package:http/http.dart' as http;

class APIService {
  Future<GithubResponseModel> getData(pageNumber, pageSize) async {
    String url =
        "search/repositories?sort=stars&q=android&page=$pageNumber&per_page=$pageSize";

    print("load API url = $url");

    final response = await http.get(Config.BASE_URL + url);
    if (response.statusCode == 200) {
      var jsonData = response.body;

      var model = githubResponseModelFromJson(jsonData);
      return model;
    } else {
      throw Exception("Failed to load data");
    }
  }
}
