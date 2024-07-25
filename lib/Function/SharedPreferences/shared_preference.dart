import '../../Utils/Global/global.dart';

Future<void> uploadDataOnSharedPrefs(Map<String,String> userData)async {
  SharedPreferencesHelper.setString(userData);
}