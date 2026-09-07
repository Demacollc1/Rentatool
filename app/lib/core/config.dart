/// Configuración por --dart-define (env/dev.json cuando exista el
/// proyecto Supabase de Demaco).
class AppConfig {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseKey = String.fromEnvironment('SUPABASE_KEY');

  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty;
}

/// Reglas de tarifas de renta como % del costo (spec del portafolio):
/// 4 horas 14% · día 20% · semana 70% · mes 200%.
class RentalRates {
  static const halfDayPct = 0.14;
  static const dayPct = 0.20;
  static const weekPct = 0.70;
  static const monthPct = 2.00;
}
