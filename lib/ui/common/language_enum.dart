
// ignore_for_file: constant_identifier_names

enum LanguageValue {  
   JAVA, PYTHON, C, 

   
}
class LanguageEnum {

static String getValue(LanguageValue languageValue) {
  return languageValue.toString().split(".").last;
}
}
