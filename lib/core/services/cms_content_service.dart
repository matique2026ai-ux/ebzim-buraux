import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/api_client.dart';
import 'package:ebzim_app/core/models/cms_models.dart';

class CMSContentService {
  final Ref _ref;

  CMSContentService(this._ref);

  /// ── HERO SLIDES ──────────────────────────────────────────────────────────
  Future<List<HeroSlide>> getHeroSlides() async {
    try {
      final response = await _ref.read(apiClientProvider).dio.get('hero-slides');
      final List data = response.data is List ? response.data : (response.data['data'] ?? []);
      return data.map((e) => HeroSlide.fromJson(Map<String, dynamic>.from(e))).toList();
    } catch (e) {
      return [];
    }
  }

  /// ── PARTNERS ─────────────────────────────────────────────────────────────
  Future<List<Partner>> getPartners() async {
    try {
      final response = await _ref.read(apiClientProvider).dio.get('partners');
      final List data = response.data is List ? response.data : (response.data['data'] ?? []);
      return data.map((e) => Partner.fromJson(Map<String, dynamic>.from(e))).toList();
    } catch (e) {
      return [];
    }
  }

  /// ── LEADERSHIP ───────────────────────────────────────────────────────────
  Future<List<EbzimLeader>> getLeadership() async {
    try {
      final response = await _ref.read(apiClientProvider).dio.get('leadership');
      final List data = response.data is List ? response.data : (response.data['data'] ?? []);
      return data.map((e) => EbzimLeader.fromJson(Map<String, dynamic>.from(e))).toList();
    } catch (e) {
      return [];
    }
  }

  /// ── ADMIN ACTIONS ────────────────────────────────────────────────────────
  Future<void> createHeroSlide(Map<String, dynamic> data) async => _ref.read(apiClientProvider).dio.post('hero-slides', data: data);
  Future<void> updateHeroSlide(String id, Map<String, dynamic> data) async => _ref.read(apiClientProvider).dio.patch('hero-slides/$id', data: data);
  Future<void> deleteHeroSlide(String id) async => _ref.read(apiClientProvider).dio.delete('hero-slides/$id');

  Future<void> createPartner(Map<String, dynamic> data) async => _ref.read(apiClientProvider).dio.post('partners', data: data);
  Future<void> updatePartner(String id, Map<String, dynamic> data) async => _ref.read(apiClientProvider).dio.patch('partners/$id', data: data);
  Future<void> deletePartner(String id) async => _ref.read(apiClientProvider).dio.delete('partners/$id');

  Future<void> createLeader(Map<String, dynamic> data) async => _ref.read(apiClientProvider).dio.post('leadership', data: data);
  Future<void> updateLeader(String id, Map<String, dynamic> data) async => _ref.read(apiClientProvider).dio.patch('leadership/$id', data: data);
  Future<void> deleteLeader(String id) async => _ref.read(apiClientProvider).dio.delete('leadership/$id');
}

final cmsContentServiceProvider = Provider((ref) => CMSContentService(ref));

final heroSlidesProvider = FutureProvider<List<HeroSlide>>((ref) {
  return ref.watch(cmsContentServiceProvider).getHeroSlides();
});

final partnersProvider = FutureProvider<List<Partner>>((ref) {
  return ref.watch(cmsContentServiceProvider).getPartners();
});

final leadershipProvider = FutureProvider<List<EbzimLeader>>((ref) {
  return ref.watch(cmsContentServiceProvider).getLeadership();
});
