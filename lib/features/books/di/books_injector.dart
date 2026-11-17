import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/features/books/data/repositories/books_repository.dart';
import 'package:hojaty/features/books/presentation/bloc/books_bloc.dart';

Future<void> initBooksInjector() async {
  // Repository
  injector.registerLazySingleton<BooksRepository>(
    () => BooksRepository(),
  );

  // BLoC
  injector.registerFactory<BooksBloc>(
    () => BooksBloc(repository: injector()),
  );
}

