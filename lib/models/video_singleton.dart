

class SingletonModalClass{
  SingletonModalClass.internal();
  static final _singleton = SingletonModalClass.internal();
  String _tempToken = '007eJxTYJg/weWYuffH6VozUjc3pmkvsJllscR5Wtq72yHVp5cJFH9UYLAwSEkyMUtONTO1NDUxTLO0MDEwMU1KMzZNtLQ0MjYwF8xMTW4IZGQwuTmZlZEBAkF8FoaS1OISBgYASJse4g==';
  String _appId = "80db46ce659541f984045bf35a992307";
  String _channelName = "test";
  String _documentId = "docId";

  String get videoTempToken => _tempToken;
  String get videoAppId => _appId;
  String get videoChannelName => _channelName;
  String get videoDocumentId => _documentId;

  void setCallTempToken(value){
    _tempToken = value;
  }
  void setCallAppId(value){
    _appId = value;
  }
  void setCallChannelName(value){
    _channelName = value;
  }

  void setDocumentId(value){
    _documentId = value;
  }

  factory SingletonModalClass(){
    return _singleton;
  }
  //
  // SingletonModalClass.initializerFunction() {
  //   print('initialized');
  // }


  // SingletonModalClass.initializerFunction(){
  //   print('initialized');
  // }
}