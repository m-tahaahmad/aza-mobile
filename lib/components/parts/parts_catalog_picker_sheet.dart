import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';
import 'package:icms_app/Services/API/api_response.dart';
import 'package:icms_app/Services/PartsService/parts_service.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

enum PartsCatalogKind { labour, part }

class PartsCatalogPickerSheet extends StatefulWidget {
  final List<Part> partItems;
  final Set<int> alreadySelectedIds;
  final bool singleSelect;
  final PartsCatalogKind kind;

  const PartsCatalogPickerSheet({
    super.key,
    required this.partItems,
    required this.alreadySelectedIds,
    required this.kind,
    this.singleSelect = false,
  });

  static Future<List<Part>?> show(
    BuildContext context, {
    required List<Part> partItems,
    required Set<int> alreadySelectedIds,
    required PartsCatalogKind kind,
    bool singleSelect = false,
  }) {
    return showModalBottomSheet<List<Part>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PartsCatalogPickerSheet(
        partItems: partItems,
        alreadySelectedIds: alreadySelectedIds,
        kind: kind,
        singleSelect: singleSelect,
      ),
    );
  }

  @override
  State<PartsCatalogPickerSheet> createState() => _PartsCatalogPickerSheetState();
}

class _PartsCatalogPickerSheetState extends State<PartsCatalogPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _pendingIds = {};
  late List<Part> _catalog;
  int? _pendingId;
  String _search = '';
  bool _creating = false;

  @override
  void initState() {
    super.initState();
    _catalog = List<Part>.from(widget.partItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Part> get _filteredParts {
    final query = _search.trim().toLowerCase();
    return _catalog.where((part) {
      final name = part.name?.toLowerCase() ?? '';
      return query.isEmpty || name.contains(query);
    }).toList();
  }

  bool get _canCreate {
    final query = _search.trim();
    if (query.isEmpty) return false;
    return !_catalog.any((part) => (part.name ?? '').trim().toLowerCase() == query.toLowerCase());
  }

  int get _newSelectionCount {
    if (widget.singleSelect) {
      return _pendingId != null && !widget.alreadySelectedIds.contains(_pendingId) ? 1 : 0;
    }
    return _pendingIds.where((id) => !widget.alreadySelectedIds.contains(id)).length;
  }

  void _selectPart(Part part) {
    final id = part.id;
    if (id == null || widget.alreadySelectedIds.contains(id)) return;
    setState(() {
      if (widget.singleSelect) {
        _pendingId = _pendingId == id ? null : id;
      } else if (_pendingIds.contains(id)) {
        _pendingIds.remove(id);
      } else {
        _pendingIds.add(id);
      }
    });
  }

  void _addSelected() {
    if (widget.singleSelect) {
      if (_pendingId == null || widget.alreadySelectedIds.contains(_pendingId)) {
        Navigator.of(context).pop();
        return;
      }
      final part = _catalog.firstWhere((p) => p.id == _pendingId);
      Navigator.of(context).pop([part]);
      return;
    }

    final toAdd = _catalog
        .where((part) => part.id != null && _pendingIds.contains(part.id) && !widget.alreadySelectedIds.contains(part.id))
        .toList();
    Navigator.of(context).pop(toAdd);
  }

  bool _isPartSelected(int? id) {
    if (id == null) return false;
    if (widget.alreadySelectedIds.contains(id)) return true;
    return widget.singleSelect ? _pendingId == id : _pendingIds.contains(id);
  }

  Future<void> _createFromSearch() async {
    final query = _search.trim();
    if (query.isEmpty || _creating || !_canCreate) return;

    setState(() => _creating = true);
    final result = widget.kind == PartsCatalogKind.labour
        ? await PartsService().createLabourPart(context, query)
        : await PartsService().createPart(context, query);
    if (!mounted) return;

    final created = result.responseData;
    if (result.status != Status.completed || created == null) {
      setState(() => _creating = false);
      return;
    }

    setState(() {
      if (!_catalog.any((part) => part.id != null && part.id == created.id)) {
        _catalog.add(created);
      }
      _creating = false;
    });
    Navigator.of(context).pop([created]);
  }

  Widget _createTile() {
    final query = _search.trim();
    return ListTile(
      enabled: !_creating,
      leading: _creating
          ? SizedBox(
              width: 22.w,
              height: 22.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: ColorConstants.primaryColor,
              ),
            )
          : Icon(Icons.add, size: 22.sp, color: ColorConstants.primaryColor),
      title: Text(
        'Create "$query"',
        style: TextStyle(
          fontSize: FontSizes.normalText1,
          fontWeight: FontWeight.w600,
          color: _creating ? const Color(0xFF98A2B3) : ColorConstants.primaryColor,
        ),
      ),
      onTap: _creating ? null : _createFromSearch,
    );
  }

  Widget _emptyState() {
    if (_canCreate) {
      return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 8.h),
        children: [_createTile()],
      );
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Text(
          'No parts found',
          style: TextStyle(
            fontSize: FontSizes.normalText1,
            color: const Color(0xFF98A2B3),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _partsList() {
    final filtered = _filteredParts;
    final showCreate = _canCreate;
    final itemCount = filtered.length + (showCreate ? 1 : 0);

    final list = ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 8.h),
      itemCount: itemCount,
      separatorBuilder: (_, __) => Divider(height: 1, color: const Color(0xFFEEF2F7)),
      itemBuilder: (context, index) {
        if (showCreate && index == filtered.length) {
          return _createTile();
        }

        final part = filtered[index];
        final id = part.id;
        final alreadyAdded = id != null && widget.alreadySelectedIds.contains(id);
        final isSelected = _isPartSelected(id);

        if (widget.singleSelect) {
          return RadioListTile<int>(
            value: id ?? -1,
            enabled: !alreadyAdded,
            activeColor: ColorConstants.primaryColor,
            contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
            title: Text(
              part.name ?? '',
              style: TextStyle(
                fontSize: FontSizes.normalText1,
                fontWeight: FontWeight.w600,
                color: alreadyAdded ? const Color(0xFF98A2B3) : const Color(0xFF1F2937),
              ),
            ),
            subtitle: alreadyAdded
                ? Text(
                    'Already added',
                    style: TextStyle(
                      fontSize: FontSizes.smallText,
                      color: const Color(0xFF98A2B3),
                    ),
                  )
                : null,
          );
        }

        return CheckboxListTile(
          value: isSelected,
          onChanged: alreadyAdded ? null : (_) => _selectPart(part),
          activeColor: ColorConstants.primaryColor,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
          title: Text(
            part.name ?? '',
            style: TextStyle(
              fontSize: FontSizes.normalText1,
              fontWeight: FontWeight.w600,
              color: alreadyAdded ? const Color(0xFF98A2B3) : const Color(0xFF1F2937),
            ),
          ),
          subtitle: alreadyAdded
              ? Text(
                  'Already added',
                  style: TextStyle(
                    fontSize: FontSizes.smallText,
                    color: const Color(0xFF98A2B3),
                  ),
                )
              : null,
        );
      },
    );

    if (!widget.singleSelect) return list;

    return RadioGroup<int>(
      groupValue: _pendingId,
      onChanged: (value) {
        if (value == null) return;
        Part? part;
        for (final p in filtered) {
          if (p.id == value) {
            part = p;
            break;
          }
        }
        if (part != null) _selectPart(part);
      },
      child: list,
    );
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
                      widget.singleSelect ? 'Select part' : 'Select parts',
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
                decoration: customerDetailInputFieldDecoration(hintText: 'Search parts').copyWith(
                  prefixIcon: Icon(Icons.search, size: 20.sp, color: const Color(0xFF98A2B3)),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Flexible(
              child: _filteredParts.isEmpty ? _emptyState() : _partsList(),
            ),
            Container(
              color: const Color(0xFFF3F5F9),
              padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: _newSelectionCount > 0 ? _addSelected : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.primaryColor,
                    disabledBackgroundColor: ColorConstants.primaryColor.withValues(alpha: 0.35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    widget.singleSelect
                        ? (_newSelectionCount > 0 ? 'Add part' : 'Select a part')
                        : (_newSelectionCount > 0 ? 'Add $_newSelectionCount part${_newSelectionCount == 1 ? '' : 's'}' : 'Add parts'),
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
      ),
    );
  }
}
