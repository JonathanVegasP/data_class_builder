import 'to_entity_type_builder.dart';
import '../models/data_element.dart';
import 'copy_with_type_builder.dart';
import 'equals_type_builder.dart';
import 'hash_code_type_builder.dart';
import 'mixin_fields_type_builder.dart';
import 'to_string_type_builder.dart';
import 'type_builder.dart';

class MixinTypeBuilder implements TypeBuilder {
  @override
  String declaration({required DataElement element}) {
    final buffer = StringBuffer();
    final name = '_\$${element.name}';
    final fields = MixinFieldsTypeBuilder();
    final hashCode = HashCodeTypeBuilder();
    final equals = EqualsTypeBuilder();
    final copyWith = CopyWithTypeBuilder();
    final toStringType = ToStringTypeBuilder();
    final toEntity = ToEntityTypeBuilder();

    buffer.writeln('mixin $name {');
    buffer.writeln(fields.declaration(element: element));
    buffer.writeln(hashCode.declaration(element: element));
    buffer.writeln(equals.declaration(element: element));
    buffer.writeln(copyWith.declaration(element: element));
    if (element.entity != null) {
      buffer.writeln(toEntity.declaration(element: element));
    }
    buffer.write(toStringType.declaration(element: element));
    buffer.writeln('}');

    return buffer.toString();
  }

  @override
  String fromJson({required DataElement element}) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  String toJson({required DataElement element}) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
