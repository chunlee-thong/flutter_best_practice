import 'package:flutter/material.dart';
import 'package:flutter_boiler_plate/src/api/index.dart';
import 'package:flutter_boiler_plate/src/models/response/other/dummy_model.dart';
import 'package:flutter_boiler_plate/src/widgets/common/pull_refresh_listview.dart';
import 'package:flutter_boiler_plate/src/widgets/ui_helper.dart';
import 'package:sura_flutter/sura_flutter.dart';
import 'package:sura_manager/sura_manager.dart';

class DummyJsonPage extends StatefulWidget {
  const DummyJsonPage({Key? key}) : super(key: key);

  @override
  _DummyJsonPageState createState() => _DummyJsonPageState();
}

class _DummyJsonPageState extends State<DummyJsonPage> {
  FutureManager<List<DummyModel>> dummyManager = FutureManager(
    futureFunction: () => userRepository.fetchDummyJson(1000),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIHelper.CustomAppBar(title: "Dummy JSON"),
      body: FutureManagerBuilder<List<DummyModel>>(
        futureManager: dummyManager,
        onRefreshing: const RefreshProgressIndicator(),
        ready: (context, List<DummyModel> data) {
          return PullRefreshListViewBuilder(
            onRefresh: dummyManager.refresh,
            itemCount: data.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  //child: Icon(Icons.person),
                  //backgroundImage: NetworkImage(SuraUtils.picsumImage(2000 + index)),
                  radius: 32,
                ),
                onTap: () {},
                title: Text("$index: ${data[index].username}"),
                subtitle: Text(data[index].email!),
              );
            },
          );
        },
      ),
    );
  }
}
