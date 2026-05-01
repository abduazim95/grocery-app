import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/features/admin/data/dtos/business_detail.dart';
import 'package:grocery/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:grocery/shared/models/business.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_provider.g.dart';

@riverpod
Future<List<Business>> businesses(Ref ref) =>
    ref.watch(adminRepositoryProvider).getBusinesses();

@riverpod
Future<BusinessDetail> businessDetail(Ref ref, String id) =>
    ref.watch(adminRepositoryProvider).getBusinessDetail(id);
