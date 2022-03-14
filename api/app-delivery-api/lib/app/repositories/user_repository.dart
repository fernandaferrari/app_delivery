import 'package:app_delivery_api/app/core/database.dart';
import 'package:app_delivery_api/app/core/exceptions/email_already_registered.dart';
import 'package:app_delivery_api/app/core/exceptions/user_notfound_exception.dart';
import 'package:app_delivery_api/app/core/helpers/cripty_helper.dart';
import 'package:postgres/postgres.dart';

import '../entities/user.dart';

class UserRepository {
  Future<User> login(String email, String senha) async {
    PostgreSQLConnection? conn;
    try {
      conn = await Database().openConnection();
      await conn.open();

      final result = await conn.query(
          'SELECT * FROM usuario where email = @email and senha = @senha',
          substitutionValues: {
            "email": email,
            "senha": CriptyHelper.generatedSha256Hash(senha)
          });

      if (result.isEmpty) {
        throw UserNotFoundException();
      }
      final userData = result.first.toList();

      return User(
          id: userData[0], nome: userData[1], email: userData[2], senha: '');
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }

  Future<void> save(User user) async {
    PostgreSQLConnection? conn;
    try {
      conn = await Database().openConnection();

      await conn.open();

      final isUserRegister = await conn.query(
          'SELECT * FROM usuario where email = @email ',
          substitutionValues: {"email": user.email});

      if (isUserRegister.isEmpty) {
        await conn.query(
            "INSERT INTO usuario (nome,email,senha) VALUES (@nome,@email,@senha)",
            substitutionValues: {
              'nome': user.nome,
              'email': user.email,
              'senha': CriptyHelper.generatedSha256Hash(user.senha)
            });
      } else {
        throw EmailAlreadyRegistered();
      }
    } on PostgreSQLException catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }
}
