// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import '../modules/cliente/models/cliente_model.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 8678320860722980458),
      name: 'Cliente',
      lastPropertyId: const IdUid(4, 43559448999343630),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6070590378792891744),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 2545891491810619916),
            name: 'nomeCliente',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 6774459224143380666),
            name: 'cnpjCpf',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 43559448999343630),
            name: 'valor',
            type: 8,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Shortcut for [Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [Store.new] for an explanation of all parameters.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// Returns the ObjectBox model definition for this project for use with
/// [Store.new].
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(1, 8678320860722980458),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    Cliente: EntityDefinition<Cliente>(
        model: _entities[0],
        toOneRelations: (Cliente object) => [],
        toManyRelations: (Cliente object) => {},
        getId: (Cliente object) => object.id,
        setId: (Cliente object, int id) {
          object.id = id;
        },
        objectToFB: (Cliente object, fb.Builder fbb) {
          final nomeClienteOffset = fbb.writeString(object.nomeCliente);
          final cnpjCpfOffset = fbb.writeString(object.cnpjCpf);
          fbb.startTable(5);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addOffset(1, nomeClienteOffset);
          fbb.addOffset(2, cnpjCpfOffset);
          fbb.addFloat64(3, object.valor);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 4);
          final nomeClienteParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, '');
          final cnpjCpfParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 8, '');
          final valorParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 10, 0);
          final object = Cliente(
              id: idParam,
              nomeCliente: nomeClienteParam,
              cnpjCpf: cnpjCpfParam,
              valor: valorParam);

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [Cliente] entity fields to define ObjectBox queries.
class Cliente_ {
  /// see [Cliente.id]
  static final id = QueryIntegerProperty<Cliente>(_entities[0].properties[0]);

  /// see [Cliente.nomeCliente]
  static final nomeCliente =
      QueryStringProperty<Cliente>(_entities[0].properties[1]);

  /// see [Cliente.cnpjCpf]
  static final cnpjCpf =
      QueryStringProperty<Cliente>(_entities[0].properties[2]);

  /// see [Cliente.valor]
  static final valor = QueryDoubleProperty<Cliente>(_entities[0].properties[3]);
}
