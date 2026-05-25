import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/location_constants.dart';
import '../../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/weather_notifier.dart';
import '../providers/weather_state.dart';
import '../widgets/error_view.dart';
import '../widgets/initial_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/weather_loaded_view.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  TextEditingController? _fieldController;
  FocusNode? _fieldFocusNode;

  void _onSearch() {
    _fieldFocusNode?.unfocus();
    final city = _fieldController?.text.trim() ?? '';
    ref.read(weatherNotifierProvider.notifier).search(city);
  }

  void _toggleLocale() {
    final current = ref.read(localeProvider);
    ref.read(localeProvider.notifier).state =
        current.languageCode == 'zh' ? const Locale('en') : const Locale('zh');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(weatherNotifierProvider);
    final isLoading = state is WeatherLoading;
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          TextButton(
            onPressed: _toggleLocale,
            child: Text(
              locale.languageCode == 'zh' ? 'EN' : '中',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return LocationConstants.all;
                      }
                      return LocationConstants.all.where(
                        (city) => city.contains(textEditingValue.text),
                      );
                    },
                    onSelected: (String city) {
                      _fieldController?.text = city;
                    },
                    fieldViewBuilder: (
                      context,
                      textEditingController,
                      focusNode,
                      onFieldSubmitted,
                    ) {
                      _fieldController = textEditingController;
                      _fieldFocusNode = focusNode;
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          hintText: l10n.searchHint,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        onSubmitted: (_) {
                          onFieldSubmitted();
                          _onSearch();
                        },
                        textInputAction: TextInputAction.search,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: isLoading ? null : _onSearch,
                  child: Text(l10n.searchButton),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(child: _buildContent(state)),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildContent(WeatherState state) => switch (state) {
        WeatherInitial() => const InitialView(),
        WeatherLoading() => const LoadingView(),
        WeatherLoaded(:final forecasts) => WeatherLoadedView(
            forecasts: forecasts,
            onCityTap: (city) =>
                ref.read(weatherNotifierProvider.notifier).search(city),
          ),
        WeatherError(:final failure) => ErrorView(
            failure: failure,
            onRetry: _onSearch,
          ),
      };
}
