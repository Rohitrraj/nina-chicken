import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kedai_ayam_nina/features/auth/data/datasources/auth_network_datasource.dart';
import 'package:kedai_ayam_nina/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kedai_ayam_nina/features/auth/domain/repositories/auth_repository.dart';
import 'package:kedai_ayam_nina/features/auth/domain/usecases/auth_usecases.dart';
import 'package:kedai_ayam_nina/features/auth/domain/usecases/watch_auth.dart';
import 'package:kedai_ayam_nina/features/auth/presentations/bloc/auth_bloc.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/bloc/product_mutation_bloc.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/bloc/product_catalog_bloc.dart';
import 'package:kedai_ayam_nina/features/produk/data/datasources/product_firestore_datasource.dart';
import 'package:kedai_ayam_nina/features/produk/data/repositories/product_repository_impl.dart';
import 'package:kedai_ayam_nina/features/produk/domain/repositories/product_repository.dart';
import 'package:kedai_ayam_nina/features/produk/domain/usecases/create_product.dart';
import 'package:kedai_ayam_nina/features/produk/domain/usecases/delete_product.dart';
import 'package:kedai_ayam_nina/features/produk/domain/usecases/update_product.dart';
import 'package:kedai_ayam_nina/features/produk/domain/usecases/get_products.dart';
import 'package:kedai_ayam_nina/features/transactions/data/datasource/transactions_network_datasource.dart';
import 'package:kedai_ayam_nina/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/usecases/create_transaction.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/usecases/get_annual_growth.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/usecases/get_transactions.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/usecases/update_transaction.dart';
import 'package:kedai_ayam_nina/features/transactions/presentations/bloc/transaction_bloc.dart';
import 'package:kedai_ayam_nina/features/transactions/presentations/cubit/transaction_list_cubit.dart';
import 'package:kedai_ayam_nina/features/produk/data/datasources/cloudinary_image_datasource.dart';

final GetIt getIt = GetIt.instance;

Future<void> setup() async {
  // === EXTERNAL ===
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: 'https://api-6k4wrfnuca-uc.a.run.app',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    ),
  );

  // === DATASOURCES ===
  getIt.registerLazySingleton<AuthNetworkDatasource>(
    () => AuthNetworkDatasourceImpl(getIt()),
  );
  getIt.registerLazySingleton<CloudinaryImageDatasource>(
    () => CloudinaryImageDatasourceImpl(dio: getIt(), firebaseAuth: getIt()),
  );
  getIt.registerLazySingleton<ProductFirestoreDatasource>(
    () => ProductFirestoreDatasourceImpl(firestore: getIt()),
  );
  getIt.registerLazySingleton<TransactionsNetworkDatasource>(
    () => TransactionsNetworkDatasourceImpl(dio: getIt()),
  );

  // === REPOSITORIES ===
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(firestoreDatasource: getIt()),
  );
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(networkDatasource: getIt()),
  );

  // === USECASES ===
  getIt.registerLazySingleton(() => Login(getIt()));
  getIt.registerLazySingleton(() => Logout(getIt()));
  getIt.registerLazySingleton(() => GetProducts(getIt()));
  getIt.registerLazySingleton(() => CreateProduct(getIt()));
  getIt.registerLazySingleton(() => UpdateProduct(getIt()));
  getIt.registerLazySingleton(() => DeleteProduct(getIt()));
  getIt.registerLazySingleton(() => CreateTransaction(getIt()));
  getIt.registerLazySingleton(() => UpdateTransaction(getIt()));
  getIt.registerLazySingleton(() => DeleteTransaction(getIt()));
  getIt.registerLazySingleton(() => GetTransactions(getIt()));
  getIt.registerLazySingleton(() => GetAnnualGrowth(getIt()));
  getIt.registerLazySingleton(() => WatchAuth(getIt()));

  // === BLOC ===
  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(login: getIt(), logout: getIt(), watchAuth: getIt()),
  );

  getIt.registerLazySingleton<ProductCatalogBloc>(
    () => ProductCatalogBloc(
      getProducts: getIt(),
      deleteProduct: getIt(),
      cloudinaryImageDatasource: getIt(),
    ),
  );

  getIt.registerFactory<TransactionListCubit>(
    () => TransactionListCubit(getIt()),
  );

  getIt.registerFactory<ProductMutationBloc>(
    () => ProductMutationBloc(
      createProduct: getIt(),
      updateProduct: getIt(),
      cloudinaryImageDatasource: getIt(),
    ),
  );
  getIt.registerFactory(
    () => TransactionBloc(
      createTransaction: getIt(),
      getAnnualGrowth: getIt(),
      deleteTransaction: getIt(),
      updateTransaction: getIt(),
    ),
  );
}
