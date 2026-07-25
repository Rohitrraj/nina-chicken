import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kedai_ayam_nina/core/widgets/main_scaffold_admin.dart';
import 'package:kedai_ayam_nina/features/auth/presentations/bloc/auth_bloc.dart';
import 'package:kedai_ayam_nina/features/auth/presentations/pages/component/main_scaffold_auth.dart';
import 'package:kedai_ayam_nina/features/auth/presentations/pages/login_page.dart';
import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/pages/detail_product.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/pages/detail_product_user.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/pages/product_catalog_page.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/pages/product_mutation_page.dart';
import 'package:kedai_ayam_nina/features/transactions/presentations/pages/annual_growth_page.dart';
import 'package:kedai_ayam_nina/features/transactions/presentations/pages/history_page.dart';
import 'package:kedai_ayam_nina/features/transactions/presentations/pages/transaction_mutation.dart';
import 'package:kedai_ayam_nina/features/user/presentation/pages/dashboard.dart';
import 'package:kedai_ayam_nina/features/user/presentation/pages/catalog.dart';
import 'package:kedai_ayam_nina/features/user/presentation/pages/about_us.dart';
import 'package:kedai_ayam_nina/features/user/presentation/pages/contact_us.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/product_detail/product_detail.dart';
import 'package:kedai_ayam_nina/router/listener_router.dart';
import 'package:kedai_ayam_nina/router/router.dart';

class AppRouter {
  GoRouter myRouter(BlocBase bloc) {
    return GoRouter(
      initialLocation: MyRoute.home.path,
      refreshListenable: ListenerRouter(bloc.stream),
      redirect: (context, state) {
        final admin = [
          MyRoute.adminDashboard.path,
          MyRoute.adminCatalog.path,
          MyRoute.adminOrders.path,
          MyRoute.adminAnalytics.path,
        ];

        if (admin.contains(state.fullPath)) {
          if (bloc.state is! AuthSuccess) {
            return MyRoute.home.path;
          } else {
            null;
          }
        } else {
          if (state.fullPath == MyRoute.login.path) {
            if (bloc.state is AuthSuccess) {
              return MyRoute.adminAnalytics.path;
            } else {
              null;
            }
          }
        }
        return null;
      },
      routes: [
        GoRoute(
          name: MyRoute.home.name,
          path: MyRoute.home.path,
          builder: (context, state) => Dashboard(),
        ),
        GoRoute(
          name: MyRoute.detail.name,
          path: MyRoute.detail.path,
          builder: (context, state) {
            final product = state.extra;

            if (product is! Product) {
              return const ProductDetailUnavailablePage();
            }

            return DetailProductUserPage(product: product);
          },
        ),
        GoRoute(
          name: MyRoute.catalog.name,
          path: MyRoute.catalog.path,
          builder: (context, state) => const CatalogPage(),
        ),
        GoRoute(
          name: MyRoute.about.name,
          path: MyRoute.about.path,
          builder: (context, state) => const AboutUsPage(),
        ),
        GoRoute(
          name: MyRoute.contactUs.name,
          path: MyRoute.contactUs.path,
          builder: (context, state) => const ContactUsPage(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              MainScaffoldAuth(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: MyRoute.login.name,
                  path: MyRoute.login.path,
                  builder: (context, state) => const LoginPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              MainScaffoldAdmin(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: MyRoute.adminDashboard.name,
                  path: MyRoute.adminDashboard.path,
                  builder: (context, state) => const HistoryPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: MyRoute.adminCatalog.path,
                  builder: (context, state) => const ProductCatalogPage(),
                  routes: [
                    GoRoute(
                      path: 'mutation',
                      builder: (context, state) {
                        final product = state.extra as Product?;
                        return ProductMutationPage(product: product);
                      },
                    ),
                    GoRoute(
                      path: 'detail',
                      builder: (context, state) {
                        final product = state.extra as Product;
                        return DetailProductPage(product: product);
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: MyRoute.adminOrders.path,
                  builder: (context, state) => const TransactionMutation(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: MyRoute.adminAnalytics.path,
                  builder: (context, state) => const AnnualGrowthPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
