import 'package:flutter/material.dart';
import 'package:flutter_boiler_plate/src/widgets/ui_helper.dart';
import 'package:sura_manager/sura_manager.dart';

import '../../api/index.dart';
import '../../models/response/user/user_model.dart';
import '../../widgets/common/pull_refresh_listview.dart';

class DummyPage extends StatefulWidget {
  DummyPage({Key? key}) : super(key: key);
  @override
  _DummyPageState createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {
  FutureManager<UserResponse> userController = FutureManager(reloading: false);
  int currentPage = 1;
  int? totalPage = 10;

  Future fetchData([bool reload = false]) async {
    if (reload) {
      currentPage = 1;
    }
    userController.asyncOperation(
      () async {
        await Future.delayed(Duration(seconds: 1));
        var data = await userRepository.fetchUserList(
          count: 10,
          page: currentPage,
        );

        return data;
      },
      onSuccess: (response) {
        if (userController.hasData) {
          response.users = [...userController.data!.users!, ...response.users!];
        }
        if (response.users!.isNotEmpty) {
          currentPage += 1;
        }
        totalPage = response.pagination!.totalPage;
        return response;
      },
      reloading: reload,
    );
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIHelper.CustomAppBar(
        title: "Fetch all users with pagination",
        actions: [
          IconButton(
            onPressed: userController.refresh,
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureManagerBuilder<UserResponse>(
        futureManager: userController,
        onRefreshing: const RefreshProgressIndicator(),
        ready: (context, UserResponse data) {
          return PullRefreshListViewBuilder.paginated(
            onRefresh: () => fetchData(true),
            itemCount: data.users!.length,
            padding: EdgeInsets.zero,
            hasMoreData: currentPage <= totalPage!,
            itemBuilder: (context, index) {
              final user = data.users![index];
              return ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                ),
                onTap: () {},
                title: Text("${user.firstName} ${user.lastName}"),
                subtitle: Text(user.email!),
              );
            },
            onGetMoreData: fetchData,
          );
        },
      ),
    );
  }
}
