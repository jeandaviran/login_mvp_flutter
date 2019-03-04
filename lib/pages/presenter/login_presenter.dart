import 'package:login_mvp/data/remote/rest_data.dart';
import 'package:login_mvp/models/user.dart';

abstract class LoginContract{
  void LoginSuccess(User user);
  void LoginError(String msg);
}

class LoginPresenter{
  LoginContract _view;
  RestData _api = new RestData();
  LoginPresenter(this._view);

  doLogin(String username, String password){
/*    _api
        .login(username, password)
        .then((user) => _view.LoginSuccess(user))
        .catchError((onError) => _view.LoginError(onError.toString()));*/
    if(username.isEmpty || password.isEmpty){
     _view.LoginError("Complete las casillas");
     return;
    }else{
      User user = new User(username, password);
      _view.LoginSuccess(user);
      return;
    }

  }
}