import 'package:flutter/material.dart';

import '../../core/error/weather_failure.dart';
import '../../l10n/app_localizations.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.failure, this.onRetry});

  final WeatherFailure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _message(failure, l10n),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
          ],
        ),
      ),
    );
  }

  String _message(WeatherFailure f, AppLocalizations l10n) => switch (f) {
        NetworkFailure() => l10n.errorNetwork,
        LocationNotFoundFailure(:final cityName) =>
          l10n.errorLocationNotFound(cityName),
        ServerFailure(:final statusCode) => l10n.errorServer(statusCode),
        AuthFailure() => l10n.errorAuth,
        ParseFailure() => l10n.errorParse,
      };
}
