import 'package:flutter/material.dart';

import '../../domain/entities/weather_forecast.dart';
import '../../domain/entities/weather_period.dart';
import '../../l10n/app_localizations.dart';

class WeatherLoadedView extends StatelessWidget {
  const WeatherLoadedView({
    super.key,
    required this.forecasts,
    this.onCityTap,
  });

  final List<WeatherForecast> forecasts;
  final void Function(String cityName)? onCityTap;

  @override
  Widget build(BuildContext context) {
    if (forecasts.length == 1) {
      return _DetailView(forecast: forecasts.first);
    }
    return _AllRegionsView(forecasts: forecasts, onCityTap: onCityTap);
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({required this.forecast});

  final WeatherForecast forecast;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.blue),
            const SizedBox(width: 4),
            Text(
              forecast.locationName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          l10n.forecastSubtitle,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: forecast.periods.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) =>
                _PeriodCard(period: forecast.periods[index]),
          ),
        ),
      ],
    );
  }
}

class _PeriodCard extends StatelessWidget {
  const _PeriodCard({required this.period});

  final WeatherPeriod period;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_fmtDate(period.startTime)}  ${_fmtTime(period.startTime)} – ${_fmtTime(period.endTime)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const Divider(height: 16),
            Row(
              children: [
                const Icon(Icons.cloud, size: 20, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Expanded(child: Text(period.weatherDescription)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.thermostat,
                  label:
                      '${period.minTemperature}°C – ${period.maxTemperature}°C',
                ),
                const SizedBox(width: 12),
                _InfoChip(
                  icon: Icons.water_drop,
                  label: l10n.precipitation(period.precipitationProbability),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              period.comfortIndex,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  String _fmtDate(DateTime dt) =>
      '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';

  String _fmtTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

class _AllRegionsView extends StatelessWidget {
  const _AllRegionsView({required this.forecasts, this.onCityTap});

  final List<WeatherForecast> forecasts;
  final void Function(String)? onCityTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.public, color: Colors.blue),
            const SizedBox(width: 4),
            Text(
              l10n.allRegionsTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: forecasts.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) => _CitySummaryRow(
              forecast: forecasts[index],
              onTap: onCityTap,
            ),
          ),
        ),
      ],
    );
  }
}

class _CitySummaryRow extends StatelessWidget {
  const _CitySummaryRow({required this.forecast, this.onTap});

  final WeatherForecast forecast;
  final void Function(String)? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final first = forecast.periods.isNotEmpty ? forecast.periods.first : null;

    return ListTile(
      onTap: onTap != null ? () => onTap!(forecast.locationName) : null,
      leading: const Icon(Icons.location_on_outlined, color: Colors.blue),
      title: Text(
        forecast.locationName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: first != null
          ? Text(
              first.weatherDescription,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: first != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${first.minTemperature}°C – ${first.maxTemperature}°C',
                  style: const TextStyle(fontSize: 13),
                ),
                Text(
                  l10n.precipitation(first.precipitationProbability),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            )
          : null,
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.blue.shade700),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}