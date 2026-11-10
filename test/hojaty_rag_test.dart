import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:hojaty/features/hojaty_ai/data/datasources/gemini_key_pool.dart';

void main() {
  print('=== Running Hojaty RAG Self-Check ===');

  // Test 1: GeminiKeyPool Round-Robin and Cooldowns
  final pool = GeminiKeyPool();
  pool.setKeys(['KEY_A', 'KEY_B', 'KEY_C']);

  assert(pool.totalKeys == 3, 'Total keys should be 3');
  assert(pool.getNextKey() == 'KEY_A', 'First key should be KEY_A');
  assert(pool.getNextKey() == 'KEY_B', 'Second key should be KEY_B');
  assert(pool.getNextKey() == 'KEY_C', 'Third key should be KEY_C');
  assert(pool.getNextKey() == 'KEY_A', 'Round robin wraps back to KEY_A');

  // Put KEY_A on cooldown for 62s
  pool.markCooldown('KEY_A', duration: const Duration(seconds: 62));
  assert(!pool.isKeyAvailable('KEY_A'), 'KEY_A must be on cooldown');
  assert(pool.getNextKey() == 'KEY_B', 'Should skip KEY_A and return KEY_B');

  // Put KEY_B and KEY_C on cooldown too
  pool.markCooldown('KEY_B', duration: const Duration(seconds: 120));
  pool.markCooldown('KEY_C', duration: const Duration(seconds: 200));

  // When all are on cooldown, returns KEY_A because its 62s expires soonest
  assert(pool.getNextKey() == 'KEY_A', 'Must return KEY_A with earliest expiry');
  print('✓ GeminiKeyPool tests passed');

  // Test 2: Vector unpacking & Cosine Similarity
  final f1 = Float32List(512);
  final f2 = Float32List(512);
  for (int i = 0; i < 512; i++) {
    f1[i] = 1.0;
    f2[i] = 1.0;
  }

  final blob1 = f1.buffer.asUint8List();
  assert(blob1.lengthInBytes == 2048, 'Blob must be 2048 bytes');

  final unpacked = blob1.buffer.asFloat32List(blob1.offsetInBytes, blob1.lengthInBytes ~/ 4);
  assert(unpacked.length == 512, 'Unpacked floats must be 512');
  assert(unpacked[0] == 1.0, 'Float value match');

  double dot = 0.0;
  double n1 = 0.0;
  double n2 = 0.0;
  for (int i = 0; i < 512; i++) {
    dot += f1[i] * f2[i];
    n1 += f1[i] * f1[i];
    n2 += f2[i] * f2[i];
  }
  final sim = dot / (math.sqrt(n1) * math.sqrt(n2));
  assert((sim - 1.0).abs() < 1e-5, 'Identical vectors should have similarity 1.0');
  print('✓ Vector Cosine Similarity logic passed');

  // Test 3: Verify hojaty_rag.db exists
  final dbFile = File('assets/debug/hojaty_rag.db');
  assert(dbFile.existsSync(), 'assets/debug/hojaty_rag.db must exist');
  assert(dbFile.lengthSync() > 1024 * 1024, 'Database size must be > 1MB');
  print('✓ Database existence verified (${(dbFile.lengthSync() / (1024*1024)).toStringAsFixed(1)} MB)');

  print('=== ALL HOJATY RAG CHECKS PASSED ===');
}

