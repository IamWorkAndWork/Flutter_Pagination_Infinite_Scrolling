import 'package:flutter/material.dart';
import 'package:flutter_pagination_infinite_scrolling/api_service.dart';
import 'package:flutter_pagination_infinite_scrolling/models/github_model.dart';
import 'package:flutter_pagination_infinite_scrolling/models/github_response_model.dart';

enum LoadMoreStatus { LOADING, STABLE }

class DataProvider with ChangeNotifier {
  APIService _apiService;
  GithubResponseModel _dataFetcher;
  int totalPage = 0;
  int pageSize = 10;

  List<GithubModel> get allGithubs {
    // var modelList = List<GithubModel>();

    if (_dataFetcher == null || _dataFetcher.totalCount == null) {
      return List<GithubModel>();
    }

    // _dataFetcher.items.forEach((element) {
    //   var model = element.toGithubModel();
    //   modelList.add(model);
    // });
    var modelList = _dataFetcher.items.map((e) => e.toGithubModel()).toList();
    return modelList;
  }

  double get totalRecords => _dataFetcher.totalCount.toDouble();

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;
  getLoadMoreStatus() => _loadMoreStatus;

  DataProvider() {
    _initStreams();
  }

  void _initStreams() {
    _apiService = APIService();
    _dataFetcher = GithubResponseModel();
  }

  void resetStreams() {
    _initStreams();
  }

  fetchAllGithub(pageNumber) async {
    try {
      if (totalPage == 0 || pageNumber <= totalPage) {
        var itemModel = await _apiService.getData(pageNumber, pageSize);

        if (_dataFetcher.items == null) {
          totalPage = ((itemModel.totalCount - 1) / pageSize).ceil();
          _dataFetcher = itemModel;
        } else {
          _dataFetcher.items.addAll(itemModel.items);
          _dataFetcher = _dataFetcher;

          setLoadingState(LoadMoreStatus.STABLE);
        }
      }
      notifyListeners();

      if (pageNumber > totalPage) {
        setLoadingState(LoadMoreStatus.STABLE);
        notifyListeners();
      }
    } catch (e) {
      print("exception load more : " + e.toString());
      setLoadingState(LoadMoreStatus.STABLE);
    }
  }

  void setLoadingState(LoadMoreStatus loadMoreStatus) {
    _loadMoreStatus = loadMoreStatus;
    notifyListeners();
  }
}
