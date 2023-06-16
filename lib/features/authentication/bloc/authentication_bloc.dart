import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

// class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
//   AuthenticationBloc() : super(AuthenticationInitial()) {
//     on<AuthenticationEvent>((event, emit) {
//       // TODO: implement event handler
//     });
//   }
// }
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(this._authenticationRepository)
      : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is AuthenticationStarted) {
        UserModel user = await _authenticationRepository.getCurrentUser().first;
        if (user.uid != "uid") {
          String? displayName = await _authenticationRepository.retrieveUserName(user);
          emit(AuthenticationSuccess(displayName: displayName));
        } else {
          emit(AuthenticationFailure());
        }
      }
      else if(event is AuthenticationSignedOut){
        await _authenticationRepository.signOut();
        emit(AuthenticationFailure());
      }
    });
  }
}
