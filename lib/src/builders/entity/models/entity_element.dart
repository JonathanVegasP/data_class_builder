import 'package:analyzer/dart/element/element.dart';
import '../type_builders/mixin_type_builder.dart';

class EntityElement {
  final String name;
  final bool nullSafety;
  final List<FieldElement> fields;
  final List<ParameterElement> parameterFields;

  factory EntityElement.fromElement(Element element) {
    final name = element.name!;

    if (element is! ClassElement) {
      throw 'EntityBuilder: $name must be a valid class';
    }

    final fields = element.fields;

    if (fields.isEmpty) {
      throw 'EntityBuilder: $name must has declarated field(s)';
    }

    if (element.unnamedConstructor == null) {
      throw 'EntityBuilder: $name must has an unnamed constructor';
    }

    final parameterFields = element.unnamedConstructor!.parameters;

    return EntityElement(
      name: name,
      nullSafety: element.library.isNonNullableByDefault,
      fields: fields,
      parameterFields: parameterFields,
    );
  }

  EntityElement({
    required this.name,
    required this.nullSafety,
    required this.fields,
    required this.parameterFields,
  });

  String declaration() {
    final buffer = StringBuffer();

    final mixinBuilder = MixinTypeBuilder();

    buffer.writeln(mixinBuilder.declaration(this));

    return buffer.toString();
  }
}
