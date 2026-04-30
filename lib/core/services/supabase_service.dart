import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SupabaseService {
  static const String url = 'https://kuoezhgkfxctcxecodak.supabase.co';
  
  // NOTE: This is the service_role key found in the backend. 
  // In a real production app, you should use the 'anon' key for client-side code 
  // and set up Row Level Security (RLS).
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt1b2V6aGdrZnhjdGN4ZWNvZGFrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NzQwNTYxMywiZXhwIjoyMDkyOTgxNjEzfQ.Xl-LDkOENbprpuWC2v-hI28XIKgekdym6q4vdqv1nrs';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  SupabaseClient get client => Supabase.instance.client;
}

final supabaseServiceProvider = Provider((ref) => SupabaseService());
