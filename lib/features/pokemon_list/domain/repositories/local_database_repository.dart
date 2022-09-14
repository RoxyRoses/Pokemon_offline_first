import 'package:sqflite/sqflite.dart';

import '../../../../database_helper.dart';
import '../entities/pokemon_entity.dart';


class LocalPokemonRepository {
  var databaseFuture = DatabaseHelper.db.database;
  static const POKEMON_TABLE_NAME = 'pokemon';

  Future<List<Pokemon>> getAllPokemons() async {
    late final List<Pokemon> pokemonList;
    final Database database = await databaseFuture;
    ///return the itens from table
    final pokemonMap = await database.query(POKEMON_TABLE_NAME);
    pokemonList =
        pokemonMap.map((pokemon) => Pokemon.fromJson(pokemon)).toList();
    return pokemonList;
  }

  Future<void> updateLocalPokemonDatatable(List<Pokemon> pokemonList) async {
    final Database database = await databaseFuture;
    ///creates a batch to execute multiple operations in one
    Batch batch = database.batch();
    for (var pokemon in pokemonList){
      ///update the info in pokemon table
      batch.insert(
        POKEMON_TABLE_NAME,
        pokemon.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    ///execute batch
    batch.commit();
  }
}