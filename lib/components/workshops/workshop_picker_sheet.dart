import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Model/WorkshopsModel/all_workshops_model.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class WorkshopPickerSheet extends StatefulWidget {
  final List<WorkshopsData> workshops;
  final WorkshopsData? selected;

  const WorkshopPickerSheet({
    super.key,
    required this.workshops,
    this.selected,
  });

  static Future<WorkshopsData?> show(
    BuildContext context, {
    required List<WorkshopsData> workshops,
    WorkshopsData? selected,
  }) {
    return showModalBottomSheet<WorkshopsData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WorkshopPickerSheet(
        workshops: workshops,
        selected: selected,
      ),
    );
  }

  @override
  State<WorkshopPickerSheet> createState() => _WorkshopPickerSheetState();
}

class _WorkshopPickerSheetState extends State<WorkshopPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<WorkshopsData> get _filteredWorkshops {
    final query = _search.trim().toLowerCase();
    return widget.workshops.where((workshop) {
      final name = workshop.name?.toLowerCase() ?? '';
      return query.isEmpty || name.contains(query);
    }).toList();
  }

  void _selectWorkshop(WorkshopsData workshop) {
    Navigator.of(context).pop(workshop);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select workshop',
                      style: TextStyle(
                        fontSize: FontSizes.largeText,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(8.r),
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close, size: 22.sp, color: const Color(0xFF667085)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _search = value),
                style: customerDetailInputTextStyle(),
                decoration: customerDetailInputFieldDecoration(hintText: 'Search workshops').copyWith(
                  prefixIcon: Icon(Icons.search, size: 20.sp, color: const Color(0xFF98A2B3)),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Flexible(
              child: _filteredWorkshops.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Text(
                          'No workshops found',
                          style: TextStyle(
                            fontSize: FontSizes.normalText1,
                            color: const Color(0xFF98A2B3),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 16.h),
                      itemCount: _filteredWorkshops.length,
                      separatorBuilder: (_, __) => Divider(height: 1, color: const Color(0xFFEEF2F7)),
                      itemBuilder: (context, index) {
                        final workshop = _filteredWorkshops[index];
                        final isSelected = widget.selected?.id != null && widget.selected?.id == workshop.id;

                        return ListTile(
                          onTap: () => _selectWorkshop(workshop),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                          title: Text(
                            workshop.name ?? '',
                            style: TextStyle(
                              fontSize: FontSizes.normalText1,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle, color: ColorConstants.primaryColor, size: 22.sp)
                              : null,
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
