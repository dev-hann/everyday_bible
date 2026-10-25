import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:meta/meta.dart';

part 'app_database.g.dart';

/// Drift table storing the user's memos.
class Memos extends Table {
  /// Unique memo identifier (creation timestamp in milliseconds).
  TextColumn get id => text()();

  /// Raw memo text; the first line acts as the title.
  TextColumn get body => text()();

  /// Creation timestamp in milliseconds since the epoch.
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table storing app settings as string key-value pairs.
class Settings extends Table {
  /// Unique setting key.
  TextColumn get key => text()();

  /// Setting value serialized as a string.
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Drift table storing chat conversations.
@DataClassName('ChatSessionRow')
class ChatSessions extends Table {
  /// Unique session identifier (creation timestamp in milliseconds).
  TextColumn get id => text()();

  /// Short display title derived from the first user message.
  TextColumn get title => text()();

  /// Creation timestamp in milliseconds since the epoch.
  IntColumn get createdAt => integer()();

  /// Last activity timestamp in milliseconds since the epoch.
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table storing the messages of chat sessions.
@DataClassName('ChatMessageRow')
class ChatMessages extends Table {
  /// Unique message identifier (creation timestamp in milliseconds).
  TextColumn get id => text()();

  /// Identifier of the session this message belongs to.
  TextColumn get sessionId => text()();

  /// Message author, `user` or `assistant`.
  TextColumn get role => text()();

  /// Raw message text.
  TextColumn get content => text()();

  /// Creation timestamp in milliseconds since the epoch.
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Local database holding the app's memo, chat, and settings tables.
@DriftDatabase(tables: [Memos, Settings, ChatSessions, ChatMessages])
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(driftDatabase(name: 'everyday_bible'));

  /// Testing constructor — runs the database against the provided executor
  /// (typically an in-memory `NativeDatabase`).
  @visibleForTesting
  AppDatabase.forTesting(super.e);

  /// Shared singleton instance of the database.
  static final AppDatabase instance = AppDatabase._();

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(chatSessions);
            await m.createTable(chatMessages);
          }
        },
      );
}
