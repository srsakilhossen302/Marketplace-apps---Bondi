import 'package:get/get.dart';
import 'english.dart';
import 'portuguese.dart';

class Translator extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': english,
    'pt_BR': portuguese,
  };
}
