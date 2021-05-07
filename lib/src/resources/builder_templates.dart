import 'package:analyzer/dart/element/element.dart';

mixin BuilderTemplates {
  static String onError(ClassElement element) {
    final name = element.name;

    return '''
    part 'file_name.data.dart';
    
    abstract class $name with _\$$name {
      /** Cannot declare variables in the class scope */
        
      /** const factory/factory */ $name(/** Fields.../{Fields...}/[Fields...] */) = _$name;
    
      factory $name.fromJson(Map<String,dynamic> json) = _$name.fromJson;
      
      /** Methods... */
    }
    ''';
  }
}