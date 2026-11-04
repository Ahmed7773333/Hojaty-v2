import '../../../../core/di/injector.dart';
import '../data/repositories/books_repository.dart';
import '../presentation/bloc/books_bloc.dart';

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

