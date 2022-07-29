import 'package:codeup/ui/common/image_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/auth_service.dart';
import 'sign_up_body.dart';
import '../viewModel/sign_in_fields_view_model.dart';
import '../viewModel/soft_keyboard_view_model.dart';
import 'sign_up_bottom.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = "/sign-up";
  const SignUpScreen( {Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  
  final SoftKeyboardViewModel _softKeyboardVm = SoftKeyboardViewModel();
  final SignInFieldsViewModel _signInFieldsVm = SignInFieldsViewModel();
  final ImagePickerWidget imagePickerWidget = ImagePickerWidget();
  @override
  Widget build(BuildContext context) {
    
  final AuthService authService = AuthService(signInFieldsVm: _signInFieldsVm);
    const navBarTitle = Text("Sign Up", textAlign: TextAlign.center);
    final appBar = AppBar(
      title: const Center(
        child: navBarTitle,
      ),
    );
    final body = SafeArea(
        child: MultiProvider(
      providers: [
        ChangeNotifierProvider<SignInFieldsViewModel>(
            create: (_) => _signInFieldsVm),
        ChangeNotifierProvider<SoftKeyboardViewModel>(
            create: (_) => _softKeyboardVm),
      ],
      child: Consumer<SoftKeyboardViewModel>(
          builder: (context, softKeyBoardVm, child) {
        return _getBody(false,authService);
      }),
    ));
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }

  Widget _getBody(bool isSoftKeyboardOpened, AuthService authService) {
    Widget res;

    const padding1 = 30.0;
    const padding2 = 16.0;

    final signInScrollView = CustomScrollView(
      slivers: [
        SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.only(
                left: padding1,
                right: padding1,
                top: padding2,
                bottom: padding1,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SignUpBody(),
                  Flexible(
                    child: Container(), 
                  ), 
                  ],
              ),
            ))
      ],
    );

    res = signInScrollView;
    return res;
  }
}
