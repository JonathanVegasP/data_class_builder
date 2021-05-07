import 'package:analyzer/dart/element/element.dart';
import 'package:base_exception/base_exception.dart';

import '../resources/builder_templates.dart';

class DataClassException extends BaseException {
  DataClassException(ClassElement element)
      : super('To build a data class you need to declare as below:\n'
            '${BuilderTemplates.onError(element)}');

  DataClassException.invalidParameterForFromJson(ClassElement element)
      : super('The fromJson parameter must be only a Map<String,dynamic> type. '
            'Declare as below:\n${BuilderTemplates.onError(element)}');

  DataClassException.cannotDeclareVariables(ClassElement element)
      : super('Cannot declare variables in the class ${element.name} scope. '
            'Declare as below:\n${BuilderTemplates.onError(element)}');

  const DataClassException.cannotDeclareOptionalParameterNonNullable(
      String field)
      : super('Cannot declare optional nonNullable parameters as [$field]\n');

  const DataClassException.cannotDeclareNonNullableNamedParameterWithoutRequired(
      String field)
      : super('Cannot declare non nullable named parameter without required '
            'keyword. Declare as: {required $field}');
}
