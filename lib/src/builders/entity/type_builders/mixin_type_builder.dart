import 'to_string_type_builder.dart';
import 'copy_with_type_builder.dart';
import 'hash_type_builder.dart';
import '../models/entity_element.dart';
import 'equals_type_builder.dart';
import 'fields_type_builder.dart';
import 'type_builder.dart';

class MixinTypeBuilder with TypeBuilder {
  @override
  String declaration(EntityElement element) {
    final buffer = StringBuffer();
    final name = element.name;
    final mixinBuilder = FieldsTypeBuilder();
    final equalsBuilder = EqualsTypeBuilder();
    final hashBuilder = HashTypeBuilder();
    final copyWithBuilder = CopyWithTypeBuilder();
    final toStringBuilder = ToStringTypeBuilder();

    buffer.writeln('mixin _\$$name {');
    buffer.writeln(mixinBuilder.declaration(element));
    buffer.writeln(equalsBuilder.declaration(element));
    buffer.writeln(hashBuilder.declaration(element));
    buffer.writeln(copyWithBuilder.declaration(element));
    buffer.write(toStringBuilder.declaration(element));
    buffer.writeln('}');

    return buffer.toString();
  }
}
