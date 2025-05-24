// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/cart/data/repositories/cart_repository_impl.dart'
    as _i642;
import '../../features/cart/domain/repositories/cart_repository.dart' as _i322;
import '../../features/cart/presentation/bloc/cart_bloc.dart' as _i517;
import '../../features/products/data/datasources/product_remote_datasource.dart'
    as _i333;
import '../../features/products/data/repositories/product_repository_impl.dart'
    as _i764;
import '../../features/products/domain/repositories/product_repository.dart'
    as _i963;
import '../../features/products/domain/usecases/get_product_by_id_usecase.dart'
    as _i341;
import '../../features/products/domain/usecases/get_products_usecase.dart'
    as _i15;
import '../../features/products/presentation/bloc/product_detail_bloc.dart'
    as _i6;
import '../../features/products/presentation/bloc/product_list_bloc.dart'
    as _i848;
import '../../features/wishlist/data/repositories/wishlist_repository_impl.dart'
    as _i919;
import '../../features/wishlist/domain/repositories/wishlist_repository.dart'
    as _i4;
import '../../features/wishlist/presentation/bloc/wishlist_bloc.dart' as _i86;
import '../api/dio_client.dart' as _i861;
import 'service_locator.dart' as _i105;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i861.DioClient>(() => _i861.DioClient());
    gh.lazySingleton<_i4.WishlistRepository>(
      () => _i919.WishlistRepositoryImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
      () => _i161.AuthRemoteDataSourceImpl(gh<_i861.DioClient>()),
    );
    gh.lazySingleton<_i322.CartRepository>(
      () => _i642.CartRepositoryImpl(gh<_i460.SharedPreferences>()),
    );
    gh.singleton<_i86.WishlistBloc>(
      () => _i86.WishlistBloc(gh<_i4.WishlistRepository>()),
    );
    gh.lazySingleton<_i333.ProductRemoteDataSource>(
      () => _i333.ProductRemoteDataSourceImpl(gh<_i861.DioClient>()),
    );
    gh.lazySingleton<_i963.ProductRepository>(
      () => _i764.ProductRepositoryImpl(gh<_i333.ProductRemoteDataSource>()),
    );
    gh.singleton<_i517.CartBloc>(
      () => _i517.CartBloc(gh<_i322.CartRepository>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i161.AuthRemoteDataSource>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.factory<_i341.GetProductByIdUseCase>(
      () => _i341.GetProductByIdUseCase(gh<_i963.ProductRepository>()),
    );
    gh.factory<_i15.GetProductsUseCase>(
      () => _i15.GetProductsUseCase(gh<_i963.ProductRepository>()),
    );
    gh.factory<_i848.ProductListBloc>(
      () => _i848.ProductListBloc(gh<_i15.GetProductsUseCase>()),
    );
    gh.factory<_i188.LoginUseCase>(
      () => _i188.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i6.ProductDetailBloc>(
      () => _i6.ProductDetailBloc(gh<_i341.GetProductByIdUseCase>()),
    );
    gh.factory<_i797.AuthBloc>(
      () =>
          _i797.AuthBloc(gh<_i188.LoginUseCase>(), gh<_i787.AuthRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i105.RegisterModule {}
