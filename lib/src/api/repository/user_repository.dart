import '../../models/others/local_user_credential.dart';
import '../../models/response/user/user_model.dart';
import '../../utils/service_locator.dart';
import 'base_api_service.dart';

class UserRepository extends BaseApiService {
  static const String _LOGIN_USER = "/api/user/login";
  //If your path "/" at the end, it means that there's further route
  static const String _GET_USER_INFO = "/api/user/info/";

  Future<UserResponse> fetchUserList({int page = 1, int count = 99999}) async {
    return onRequest(
      path: "/api/user/all",
      query: {
        "page": page,
        "count": count,
      },
      onSuccess: (response) {
        return UserResponse.fromJson(response.data);
      },
    );
  }

  Future<UserModel> fetchUserInfo() async {
    String? userId = getIt<LocalUserCredential>().userId;
    return onRequest(
      path: _GET_USER_INFO + "$userId",
      onSuccess: (response) {
        return UserModel.fromJson(response.data[DATA_FIELD]);
      },
    );
  }
}
