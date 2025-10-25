import 'package:flutter/material.dart';
import 'package:inscore_app/shared/custom_text.dart';
import 'package:provider/provider.dart';
import '../../../providers/home_provider.dart';
import '../../../services/api_service.dart';
import '../data/home_repository.dart';
import 'widgets/home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(
        HomeRepository(context.read<ApiService>()),
      )..fetchHomeData(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
        title: CustomText(
          'Home',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,),
          textAlign: TextAlign.left,
        ),
      ),
        body: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && !provider.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (provider.hasError && !provider.hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        provider.errorMessage ?? 'Terjadi kesalahan',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => provider.fetchHomeData(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (!provider.hasData) {
              return const Center(
                child: Text('Tidak ada data'),
              );
            }

            return RefreshIndicator(
              onRefresh: () => provider.refresh(),
              child: HomeContent(homeData: provider.homeData!),
            );
          },
        ),
      ),
    );
  }
}
