import 'package:flutter_boiler_plate/src/models/response/other/dummy_model.dart';
import 'package:flutter_boiler_plate/src/services/cache_service.dart';

import '../../models/response/user/user_model.dart';
import 'base_api_service.dart';

class UserRepository extends BaseApiService {
  UserRepository() : super(cacheService: StorageHttpCacheService());

  static const String _GET_ALL_USER = "/api/user/all";
  static const String _GET_USER_INFO = "/api/user/info/";
  static const String _GET_LARGE_DUMMY_JSON = "/api/app/dummy/json";

  Future<UserResponse> fetchUserList({int page = 1, int count = 99999}) async {
    return onRequest(
      path: _GET_ALL_USER,
      query: {
        "page": page,
        "count": count,
      },
      onSuccess: (response) {
        return UserResponse.fromJson(response.data);
      },
    );
  }

  Future<UserModel> fetchUserInfo(String userId) async {
    return onRequest(
      path: _GET_USER_INFO + "$userId",
      onSuccess: (response) {
        return UserModel.fromJson(response.data[DATA_FIELD]);
      },
    );
  }

  Future<List<DummyModel>> fetchDummyJson(int size) async {
    return onRequest(
      path: _GET_LARGE_DUMMY_JSON,
      query: {
        "size": size,
      },
      onSuccess: (response) {
        List data = response.data["data"];
        return data.map((e) => DummyModel.fromJson(e)).toList();
      },
    );
  }
}
