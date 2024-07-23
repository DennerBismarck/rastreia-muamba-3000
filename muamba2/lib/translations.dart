import 'package:get/get.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'login': 'Login',
          'signup': 'Signup',
        },
        'pt_BR': {
          'login': 'Entrar',
          'signup': 'Cadastrar',
        },
      };
}
