import 'package:analyzer/dart/element/element.dart';

extension HashCodeBuilder on StringBuffer {
  void writeHashCode(List<ParameterElement> fields) {
    writeln('@override');

    writeln('int get hashCode {');

    writeln('final hash = 0x1fffffff;');

    writeln('final hashCombine = 0x0007ffff;');

    writeln('final hashCombineFinalize = 0x03ffffff;');

    writeln('final hashFinalize = 0x00003fff;');

    writeln('var result = 0;');

    for (final field in fields) {
      writeln('result = hash & (result + ${field.name}.hashCode);');

      writeln('result = hash & (result + ((hashCombine & result) << 10));');

      writeln('result = result ^ (result >> 6);');
    }

    writeln(
        'result = hash & (result + ((hashCombineFinalize & result) << 3));');

    writeln('result = result ^ (result >> 11);');

    writeln('result = hash & (result + ((hashFinalize & result) << 15));');

    writeln('return result;');

    writeln('}');
  }
}
