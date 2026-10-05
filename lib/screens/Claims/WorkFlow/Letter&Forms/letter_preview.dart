import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/letters/letters_action_sheet.dart';
import 'package:icms_app/components/workflow/workflow_page_header.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../Services/DownloadService/download_service.dart';
import '../../../../components/custom_snack_bar.dart';
import '../../../../constants/theme_constants.dart';

class LetterPreviewScreen extends StatefulWidget {
  final String? docUrl;
  final String? file;
  final int? id;
  final String? fileName;

  const LetterPreviewScreen({super.key, this.docUrl, this.file, this.id, this.fileName});

  @override
  State<LetterPreviewScreen> createState() => _LetterPreviewScreenState();
}

class _LetterPreviewScreenState extends State<LetterPreviewScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _showDownloadSheet() async {
    final action = await LettersActionSheet.show(
      context,
      title: widget.fileName ?? 'Preview',
      showPreview: false,
    );
    if (!mounted || action != LettersAction.download) return;

    showSnackBar(context, 'Download started');
    await DownloadService().downloadForm(context, widget.file, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: Column(
          children: [
            WorkflowPageHeader(
              title: widget.fileName ?? 'Preview',
              subtitle: 'PDF preview',
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: SfPdfViewer.network(
                    widget.docUrl!,
                    onDocumentLoaded: (_) {
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) _showDownloadSheet();
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showDownloadSheet,
        backgroundColor: ColorConstants.primaryColor,
        icon: const Icon(CupertinoIcons.arrow_down_doc, color: Colors.white),
        label: const Text(
          'Download',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
