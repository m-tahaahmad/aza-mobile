import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Services/DownloadService/download_service.dart';
import 'package:icms_app/Services/LetterService/letter_service.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/components/letters/letters_action_sheet.dart';
import 'package:icms_app/components/letters/letters_document_selection_sheet.dart';
import 'package:icms_app/components/letters/letters_helpers.dart';
import 'package:icms_app/components/letters/letters_row.dart';
import 'package:icms_app/components/workflow/workflow_page_header.dart';
import 'package:icms_app/constants/globals.dart';
import 'package:icms_app/screens/Claims/WorkFlow/Letter&Forms/letter_preview.dart';

import '../../../../constants/theme_constants.dart';

class LetternForms extends StatefulWidget {
  final int? id;

  const LetternForms({super.key, this.id});

  @override
  State<LetternForms> createState() => _LetternFormsState();
}

class _LetternFormsState extends State<LetternForms> {
  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() {});
  }

  Future<void> _handleLetterTap(LetterType letter) async {
    if (letter.requiresDocuments) {
      final selectedNames = await LettersDocumentSelectionSheet.show(
        context,
        fileName: letter.title,
      );
      if (!mounted) return;
      if (selectedNames != null && selectedNames.isNotEmpty) {
        await _showActionSheetForDocuments(letter, selectedNames);
      }
    } else {
      await _showNormalActionSheet(letter);
    }
  }

  Future<void> _showNormalActionSheet(LetterType letter) async {
    final action = await LettersActionSheet.show(context, title: letter.title);
    if (!mounted || action == null) return;

    if (action == LettersAction.preview) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return LetterPreviewScreen(
          docUrl: '$baseUrl${letter.slug}/$claimId',
          file: letter.slug,
          id: widget.id,
          fileName: letter.title,
        );
      }));
    } else if (action == LettersAction.download) {
      showSnackBar(context, 'Download in progress – check notification bar');
      await DownloadService().downloadForm(context, letter.slug, widget.id);
    }
  }

  Future<void> _showActionSheetForDocuments(LetterType letter, List<String> selectedNames) async {
    final action = await LettersActionSheet.show(context, title: letter.title);
    if (!mounted || action == null) return;

    if (action == LettersAction.preview) {
      if (widget.id == null) {
        showSnackBar(context, 'Download failed');
        return;
      }
      final url = await generateLetterWithDocuments(context, letter.slug, widget.id!, selectedNames);
      if (!mounted) return;
      if (url != null && url.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return LetterPreviewScreen(
            docUrl: url,
            file: letter.slug,
            id: widget.id,
            fileName: letter.title,
          );
        }));
      } else {
        showSnackBar(context, 'Failed to generate letter');
      }
    } else if (action == LettersAction.download) {
      showSnackBar(context, 'Download in progress – check notification bar');
      await DownloadService().downloadLetterWithDocuments(context, letter.slug, widget.id, selectedNames);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: ColorConstants.primaryColor,
      onRefresh: _handleRefresh,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F5F9),
        body: SafeArea(
          child: Column(
            children: [
              WorkflowPageHeader(
                title: 'Letter & Forms',
                subtitle: 'Generate and download claim letters',
                onBack: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                  children: [
                    CustomerDetailSectionCard(
                      title: 'Available letters',
                      icon: Icons.description_outlined,
                      child: Column(
                        children: [
                          for (var i = 0; i < kLetterTypes.length; i++) ...[
                            if (i > 0) customerDetailDivider(),
                            LettersRow(
                              letter: kLetterTypes[i],
                              onTap: () => _handleLetterTap(kLetterTypes[i]),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
