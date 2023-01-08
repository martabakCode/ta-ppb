import 'package:ta_ppb_flutter/src/model/profile.dart';
import 'package:http/http.dart' show Client;
import 'package:ta_ppb_flutter/src/network/api.dart';

class ProfileApi {

  Future<List<Profile>> getProfiles() async {
    var response = await Network().getData('/profile');
    if (response.statusCode == 200) {
      return profileFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<bool> updateProfile(Profile data) async {
    var response = await Network().putData(profileToJson(data),'/profile/${data.id}');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

}
