import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import '../../features/pokemon_list/domain/entities/pokemon_entity.dart';
import '../../features/pokemon_list/domain/repositories/local_database_repository.dart';
import '../../features/pokemon_list/domain/repositories/remote_database_repository.dart';

part 'pokemon_state.dart';

class PokemonCubit extends Cubit<PokemonState> {
  final RemotePokemonRepository remotePokemonRepository;
  final LocalPokemonRepository localPokemonRepository;
  final Connectivity connectivity;
  PokemonCubit(this.remotePokemonRepository, this.localPokemonRepository, this.connectivity)
      : super(PokemonInitial());

  Future<void> getPokemonList() async {
    ///checks the connection status from device
    final connectivityStatus = await connectivity.checkConnectivity();
    ///if n connection found, get the local list
    if(connectivityStatus == ConnectivityResult.none) {
      getLocalPokemonList();
    }else{
      getRemotePokemonList();
    }
  }

  Future<void> getRemotePokemonList() async {
    try {
      emit(PokemonLoading());
      final result = await remotePokemonRepository.getAllPokemons();
      emit(RemotePokemonLoaded(pokemonList: result));
    } catch (error) {
      emit(PokemonError());
    }
  }

  Future<void> getLocalPokemonList() async {
    try {
      emit(PokemonLoading());
      //delay to fake http request fetch time
      await Future.delayed(const Duration(milliseconds: 500));
      final result = await localPokemonRepository.getAllPokemons();
      emit(LocalPokemonLoaded(pokemonList: result));
    } catch (error) {
      emit(PokemonError());
    }
  }

  Future<void> updateLocalPokemonDatabase(List<Pokemon> pokemonList) async {
    try {
      await localPokemonRepository.updateLocalPokemonDatatable(pokemonList);
      emit(LocalPokemonSync());
    } catch (error) {
      emit(PokemonError());
    }
  }
}