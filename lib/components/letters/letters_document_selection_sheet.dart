import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Model/DocumentsModel/document_response_model.dart';
import 'package:icms_app/Providers/DocumentsProvider/documents_provider.dart';
import 'package:icms_app/Services/API/api_response.dart';
import 'package:icms_app/Services/Documents/document_service.dart';
import 'package:icms_app/components/app_loader.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';
import 'package:provider/provider.dart';

class LettersDocumentSelectionSheet extends StatefulWidget {
  final BuildContext parentContext;
  final String fileName;

  const LettersDocumentSelectionSheet({
    super.key,
    required this.parentContext,
    required this.fileName,
  });

  static Future<List<String>?> show(
    BuildContext context, {
    required String fileName,
  }) {
    return showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LettersDocumentSelectionSheet(
        parentContext: context,
        fileName: fileName,
      ),
    );
  }

  @override
  State<LettersDocumentSelectionSheet> createState() => _LettersDocumentSelectionSheetState();
}

class _LettersDocumentSelectionSheetState extends State<LettersDocumentSelectionSheet> {
  bool _isLoading = true;
  String? _fetchError;
  final List<String> _selectedNames = [];

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    final response = await DocumentService().getAllDocument(widget.parentContext);
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fetchError = (response.status == Status.completed && response.responseData != null)
          ? null
          : (response.message ?? 'Failed to load documents');
    });
    if (_fetchError != null && mounted) {
      showSnackBar(context, _fetchError!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.75;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 8.w, 8.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.fileName,
                        style: TextStyle(
                          fontSize: FontSizes.largeText,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Select documents to include',
                        style: TextStyle(
                          fontSize: FontSizes.normalText1,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF667085),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, size: 22.sp, color: const Color(0xFF667085)),
                ),
              ],
            ),
          ),
          Flexible(
            child: _isLoading
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 48.h),
                    child: const Center(child: AppLoader()),
                  )
                : _fetchError != null
                    ? Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Text(
                          _fetchError!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: FontSizes.normalText1,
                            color: const Color(0xFFE53935),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Consumer<DocumentsProvider>(
                        builder: (_, provider, __) {
                          final list = provider.documentResponseModel?.data ?? <DocumentData>[];
                          if (list.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.all(24.w),
                              child: Text(
                                'No documents available',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: FontSizes.normalText1,
                                  color: const Color(0xFF98A2B3),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
                            shrinkWrap: true,
                            itemCount: list.length,
                            separatorBuilder: (_, __) => customerDetailDivider(),
                            itemBuilder: (_, i) {
                              final doc = list[i];
                              final name = doc.name ?? '';
                              final isSelected = _selectedNames.contains(name);
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12.r),
                                  onTap: () => _toggleDocument(name),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10.h),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 22.w,
                                          height: 22.w,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? ColorConstants.primaryColor
                                                : Colors.white,
                                            borderRadius: BorderRadius.circular(6.r),
                                            border: Border.all(
                                              color: isSelected
                                                  ? ColorConstants.primaryColor
                                                  : const Color(0xFFD0D5DD),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: isSelected
                                              ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                                              : null,
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Text(
                                            name,
                                            style: TextStyle(
                                              fontSize: FontSizes.normalText1,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF1F2937),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
          Container(
            color: const Color(0xFFF3F5F9),
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: (_isLoading || _selectedNames.isEmpty)
                    ? null
                    : () => Navigator.of(widget.parentContext).pop(List<String>.from(_selectedNames)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primaryColor,
                  disabledBackgroundColor: ColorConstants.primaryColor.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: FontSizes.normalText2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleDocument(String name) {
    setState(() {
      if (_selectedNames.contains(name)) {
        _selectedNames.remove(name);
      } else {
        _selectedNames.add(name);
      }
    });
  }
}
