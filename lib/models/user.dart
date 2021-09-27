class User {
  String _refID = '';
  String _userID = '';
  String _userName = '';
  String _userMobile = '';
  String _userAbout = '';
  String _userAddress = '';
  String _userPhoto = '';

  String get userPhoto => _userPhoto;

  set userPhoto(String value) {
    _userPhoto = value;
  }

  String get refID => _refID;

  set refID(String value) {
    _refID = value;
  }

  @override
  String toString() {
    return 'User{_refID: $_refID, _userID: $_userID, _userName: $_userName, _userMobile: $_userMobile, _userAbout: $_userAbout, _userAddress: $_userAddress, _userPhoto: $_userPhoto}';
  }

  String get userID => _userID;

  set userID(String value) {
    _userID = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  String get userMobile => _userMobile;

  set userMobile(String value) {
    _userMobile = value;
  }

  String get userAbout => _userAbout;

  set userAbout(String value) {
    _userAbout = value;
  }

  String get userAddress => _userAddress;

  set userAddress(String value) {
    _userAddress = value;
  }
}
