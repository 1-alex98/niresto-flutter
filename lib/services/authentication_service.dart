
class AuthenticationService {
  String? _loginToken;
  String? participantId;
  String? studyId;

  Future<void> login(String tokenOrURL){
    String token;
    try{
      var queryParameters = Uri.parse(tokenOrURL).queryParameters;
      token = queryParameters["t"]!;
    } catch (e) {
      token = tokenOrURL;
    }
    _loginToken = token;
    return Future(()=>{

    });
  }

  bool isLoggedIn(){
    return _loginToken != null;
  }


}