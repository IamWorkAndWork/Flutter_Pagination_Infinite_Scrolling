import 'package:flutter/material.dart';
import 'package:flutter_pagination_infinite_scrolling/api_service.dart';
import 'package:flutter_pagination_infinite_scrolling/models/github_model.dart';
import 'package:flutter_pagination_infinite_scrolling/models/github_response_model.dart';
import 'package:flutter_pagination_infinite_scrolling/provider/data_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    var provider = Provider.of<DataProvider>(context, listen: false);
    provider.resetStreams();
    provider.fetchAllGithub(_page);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        provider.setLoadingState(LoadMoreStatus.LOADING);
        provider.fetchAllGithub(++_page);
      }
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Infinite Scrolling Github"),
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          if (dataProvider.allGithubs != null &&
              dataProvider.allGithubs.length > 0) {
            return _listView(dataProvider);
          }
          return Center(
            child: CircularProgressIndicator(), //first loading
          );
        },
      ),
    );
  }

  Widget _listView(DataProvider dataProvider) {
    return Scrollbar(
      child: ListView.separated(
        itemBuilder: (context, index) {
          if ((index == dataProvider.allGithubs.length - 1) &&
              dataProvider.allGithubs.length < dataProvider.totalRecords) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: CircularProgressIndicator(), //show on bottom list
              ),
            );
          }
          return _buildRow(dataProvider.allGithubs[index]);
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: dataProvider.allGithubs.length,
        controller: _scrollController,
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
      ),
    );
  }

  Widget _buildRow(GithubModel gihtubModel) {
    return ListTile(
      onTap: () {},
      title: Text(
        gihtubModel.name,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        gihtubModel.description,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
    );
  }

  // void testLoad() async {
  //   try {
  //     GithubResponseModel data = await APIService().getData(1);
  //     print("success data length = ${data.items.length}");
  //   } catch (e) {
  //     print("error : $e");
  //   }
  // }
}
