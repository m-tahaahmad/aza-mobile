import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Model/PendingClaims/pending_claim_response_model.dart';
import 'package:icms_app/components/app_pressable.dart';
import 'package:icms_app/constants/font_sizes.dart';
import 'package:icms_app/components/dashboard/dashboard_card_styles.dart';
import 'package:icms_app/components/dashboard/dashboard_stage_colors.dart';
import 'package:icms_app/components/search/global_search_helpers.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/globals.dart';
import 'package:icms_app/utils/color_utils.dart';

class PendingClaimCard extends StatelessWidget {
  final PendingClaimData claim;
  final VoidCallback? onTap;
  final bool showStageBadge;

  const PendingClaimCard({
    super.key,
    required this.claim,
    this.onTap,
    this.showStageBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final company = claim.policy?.insuranceCompany?.name ?? notAvailable;
    final claimId = claim.intimationNo ?? notAvailable;
    final assignedOn = claim.assignedAt?.toString().isNotEmpty == true ? claim.assignedAt.toString() : notAvailable;
    final registration = claim.regNo?.toString().isNotEmpty == true ? claim.regNo.toString() : notAvailable;
    final assignedBy = claim.assignedBy?.toString().isNotEmpty == true ? claim.assignedBy.toString() : notAvailable;
    final workshop = claim.workshop?.workshop?.name?.toString().isNotEmpty == true
        ? claim.workshop!.workshop!.name.toString()
        : 'Not assigned';
    final stageKey = claim.stageKey?.trim();
    final statusFallback = claim.status?.toString().trim();
    final showBadge = showStageBadge &&
        ((stageKey != null && stageKey.isNotEmpty) ||
            (statusFallback != null && statusFallback.isNotEmpty));

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: _resolveCardBackground(claim),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AppPressable(
        onTap: onTap,
        borderRadius: 18.r,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'COMPANY',
                          style: TextStyle(
                            fontSize: FontSizes.extraSmallText,
                            letterSpacing: 1.3,
                            color: const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          company,
                          style: TextStyle(
                            fontSize: FontSizes.largeText,
                            color: const Color(0xFF1F2937),
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showBadge)
                    _stageBadge(
                      stageKey: stageKey,
                      statusFallback: statusFallback,
                    )
                  else if (onTap != null)
                    Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF2F4F8),
                      ),
                      child: Icon(
                        CupertinoIcons.chevron_right,
                        color: const Color(0xFF98A2B3),
                        size: 16.sp,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: ColorConstants.secondaryColor.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.doc_text, size: 14.sp, color: ColorConstants.primaryColor),
                    SizedBox(width: 6.w),
                    Text(
                      claimId,
                      style: TextStyle(
                        fontSize: FontSizes.normalText1,
                        fontWeight: FontWeight.w700,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              Divider(height: 1, thickness: 1, color: const Color(0xFFEEF2F7)),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Expanded(
                    child: _detailCell(
                      label: 'ASSIGNED ON',
                      value: assignedOn,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _detailCell(
                      label: 'REGISTRATION',
                      value: registration,
                      isChip: registration != notAvailable && registration.isNotEmpty,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _detailCell(
                      label: 'ASSIGNED BY',
                      value: assignedBy,
                      showAvatar: true,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _detailCell(
                      label: 'WORKSHOP',
                      value: workshop,
                      mutedValue: workshop == 'Not assigned',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _resolveCardBackground(PendingClaimData claim) {
    if (claim.isOverdue == true) {
      final overdueBg = parseHexColor(claim.overdueColor);
      if (overdueBg != null) {
        return overdueBg;
      }
    }
    return Colors.white;
  }

  Widget _stageBadge({
    String? stageKey,
    String? statusFallback,
  }) {
    final colorKey = stageColorKey(stageKey: stageKey, statusFallback: statusFallback);
    final label = stageDisplayLabel(stageKey: stageKey, statusFallback: statusFallback);
    final style = colorKey != null
        ? DashboardStageColors.styleForStage(colorKey)
        : DashboardCardStyle.grey;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: style.iconBackgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: FontSizes.smallText,
          fontWeight: FontWeight.w700,
          color: style.iconColor,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _detailCell({
    required String label,
    required String value,
    bool isChip = false,
    bool mutedValue = false,
    bool showAvatar = false,
  }) {
    final textColor = mutedValue ? const Color(0xFFB5BFCE) : const Color(0xFF374151);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: FontSizes.extraSmallText,
            letterSpacing: 1.2,
            color: const Color(0xFF94A3B8),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 6.h),
        if (showAvatar)
          Row(
            children: [
              Container(
                width: 22.w,
                height: 22.w,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE7ECFF),
                ),
                child: Text(
                  value.isNotEmpty ? value[0].toUpperCase() : 'S',
                  style: TextStyle(
                    fontSize: FontSizes.smallText,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF3F5BD9),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: FontSizes.normalText2,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          )
        else if (isChip)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: const Color(0xFFF2F4F7),
              border: Border.all(color: const Color(0xFFDDE3ED)),
            ),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: FontSizes.normalText2,
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: FontSizes.normalText2,
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}
