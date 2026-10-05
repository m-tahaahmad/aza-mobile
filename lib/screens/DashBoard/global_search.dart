import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/app_loader.dart';
import 'package:icms_app/components/claims/pending_claim_card.dart';
import 'package:icms_app/components/search/global_search_field.dart';
import 'package:icms_app/components/search/global_search_header.dart';
import 'package:provider/provider.dart';

import '../../Model/PendingClaims/pending_claim_response_model.dart';
import '../../Providers/PendingClaimProvider/pending_claim_provider.dart';
import '../../Services/API/api_response.dart';
import '../../Services/PendingClaimServices/pending_claim_services.dart';
import '../../constants/font_sizes.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  Future<ApiResponse<PendingClaimResponseModel>>? getPendingClaims;
  String search = '??';
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _handleSearchSubmit(String value) {
    if (value.trim().isEmpty) {
      setState(() {
        search = '??';
        getPendingClaims = null;
      });
      return;
    }

    setState(() {
      search = value.trim();
      getPendingClaims = PendingClaimServices().getPendingClaims(
        context,
        claimsType: search,
        isSearch: true,
      );
    });
  }

  String _subtitleForState({
    required bool hasSearched,
    required int resultCount,
  }) {
    if (!hasSearched) return 'Enter a claim to search';
    if (resultCount == 1) return '1 result';
    return '$resultCount results';
  }

  Widget _emptyStateMessage(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF64748B),
            fontSize: FontSizes.largeText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSearched = getPendingClaims != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: Column(
          children: [
            Consumer<PendingClaimProvider>(
              builder: (context, provider, _) {
                final resultCount = hasSearched
                    ? (provider.pendingClaimResponseModel?.data ?? []).length
                    : 0;
                return GlobalSearchHeader(
                  subtitle: _subtitleForState(
                    hasSearched: hasSearched,
                    resultCount: resultCount,
                  ),
                  onBack: () => Navigator.of(context).pop(),
                );
              },
            ),
            GlobalSearchField(
              controller: searchController,
              onSubmitted: _handleSearchSubmit,
            ),
            Expanded(
              child: !hasSearched
                  ? _emptyStateMessage('Search by claim number, registration or company')
                  : FutureBuilder<ApiResponse<PendingClaimResponseModel>>(
                      future: getPendingClaims,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: AppLoader());
                        }

                        if (!snapshot.hasData) {
                          return _emptyStateMessage('Failed to search claims.');
                        }

                        final response = snapshot.data!;
                        if (response.status == Status.error) {
                          return _emptyStateMessage(
                            response.message ?? 'Failed to search claims.',
                          );
                        }

                        return Consumer<PendingClaimProvider>(
                          builder: (context, pendingClaimProvider, child) {
                            final searchedClaims =
                                pendingClaimProvider.pendingClaimResponseModel?.data ?? [];

                            if (searchedClaims.isEmpty) {
                              return _emptyStateMessage('No claims found.');
                            }

                            return ListView.builder(
                              itemCount: searchedClaims.length,
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                              itemBuilder: (context, index) {
                                final item = searchedClaims[index];
                                return PendingClaimCard(
                                  claim: item,
                                  showStageBadge: true,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
