// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class GameStorageModelAdapter extends TypeAdapter<GameStorageModel> {
  @override
  final typeId = 0;

  @override
  GameStorageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameStorageModel(
      id: fields[0] as String,
      name: fields[1] as String,
      coverImagePath: fields[2] as String,
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GameStorageModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.coverImagePath)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameStorageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyDrawStateStorageModelAdapter
    extends TypeAdapter<DailyDrawStateStorageModel> {
  @override
  final typeId = 1;

  @override
  DailyDrawStateStorageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyDrawStateStorageModel(
      dateKey: fields[0] as String,
      remainingDrawCount: (fields[1] as num).toInt(),
      isLocked: fields[2] as bool,
      recommendedGameId: fields[3] as String?,
      recommendedGameNameSnapshot: fields[4] as String?,
      recommendedGameCoverImagePathSnapshot: fields[5] as String?,
      lastDrawAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DailyDrawStateStorageModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.dateKey)
      ..writeByte(1)
      ..write(obj.remainingDrawCount)
      ..writeByte(2)
      ..write(obj.isLocked)
      ..writeByte(3)
      ..write(obj.recommendedGameId)
      ..writeByte(4)
      ..write(obj.recommendedGameNameSnapshot)
      ..writeByte(5)
      ..write(obj.recommendedGameCoverImagePathSnapshot)
      ..writeByte(6)
      ..write(obj.lastDrawAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyDrawStateStorageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlayHistoryStorageModelAdapter
    extends TypeAdapter<PlayHistoryStorageModel> {
  @override
  final typeId = 2;

  @override
  PlayHistoryStorageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayHistoryStorageModel(
      id: fields[0] as String,
      dateKey: fields[1] as String,
      gameId: fields[2] as String,
      gameNameSnapshot: fields[3] as String,
      gameCoverImagePathSnapshot: fields[4] as String,
      drawnAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PlayHistoryStorageModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dateKey)
      ..writeByte(2)
      ..write(obj.gameId)
      ..writeByte(3)
      ..write(obj.gameNameSnapshot)
      ..writeByte(4)
      ..write(obj.gameCoverImagePathSnapshot)
      ..writeByte(5)
      ..write(obj.drawnAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayHistoryStorageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
