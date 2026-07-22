import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_network_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthNetworkDatasource networkDatasource;

  AuthRepositoryImpl(this.networkDatasource);

  @override
  Future<UserEntity> login(String email, String password) async {
    return await networkDatasource.login(email, password);
  }

  @override
  Future<void> logout() async {
    return await networkDatasource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await networkDatasource.getCurrentUser();
  }

  @override
  Stream<User?> watchAuth() {
    return networkDatasource.watchAuth();
  }
}
