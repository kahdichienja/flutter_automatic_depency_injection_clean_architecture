import 'package:flutter/material.dart';
import 'package:twodoteight/data/model/response/base/api_response.dart';
import 'package:twodoteight/data/model/response/test_api_freezed_model.dart';
import 'package:twodoteight/data/repository/api_integration_demo_repo.dart';
import 'package:twodoteight/util/appurls.dart';

class APIIntegrationDemoProvider extends ChangeNotifier {
  final ApiIntegrationDemoRepo apiIntegrationDemoRepo;

  APIIntegrationDemoProvider({required this.apiIntegrationDemoRepo});

  List<TestAPIUserModel> _testAPIUserModel = <TestAPIUserModel>[];
  TestAPIUserModel _testAPIuser = TestAPIUserModel();

  late bool _isloading;
  bool get isloading => _isloading;

  List<TestAPIUserModel> get testAPIUserModel => _testAPIUserModel;
  TestAPIUserModel get testAPIuser => _testAPIuser;

  setBusy(bool apistatus) {
    _isloading = apistatus;
  }

  Future<void> getUsers(BuildContext context) async {
    setBusy(true);
    ApiResponse apiResponse =
        await apiIntegrationDemoRepo.getData(path: '${APIURLS.BASEURL}/users');

    if (apiResponse.response.statusCode == 200) {
      apiResponse.response.data.forEach(
          (users) => _testAPIUserModel.add(TestAPIUserModel.fromJson(users)));

      setBusy(false);
      notifyListeners();
    } else {
      setBusy(false);
      String _error;
      if (apiResponse.error is String) {
        _error = apiResponse.error;
      } else {
        _error = apiResponse.error.errors[0].message;
      }
      // print(_error);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_error), backgroundColor: Colors.red));
      notifyListeners();
    }
    setBusy(false);
    notifyListeners();
    // return isSuccess;
  }

  Future<void> getUser(int userid) async {
    setBusy(true);
    ApiResponse apiResponse = await apiIntegrationDemoRepo.getData(
        path: '${APIURLS.BASEURL}/users/$userid');

    if (apiResponse.response.statusCode == 200) {
      _testAPIuser = TestAPIUserModel.fromJson(apiResponse.response.data);
      print(testAPIuser.name);
      setBusy(false);
      notifyListeners();
    } else {
      setBusy(false);
      String _error;
      if (apiResponse.error is String) {
        _error = apiResponse.error;
      } else {
        _error = apiResponse.error.errors[0].message;
      }
      // print(_error);
      notifyListeners();
    }
    setBusy(false);
    notifyListeners();
  }
}
