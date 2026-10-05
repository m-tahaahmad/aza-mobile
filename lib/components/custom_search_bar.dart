import 'package:flutter/material.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController? textController;
  final Function? onChange;
  final Function? onSubmitted;
  final double? width;
  final TextInputAction? textInputAction;

  const CustomSearchBar({
    super.key,
    this.textController,
    this.onChange,
    this.width,
    this.onSubmitted,
    this.textInputAction,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Container(
            decoration: BoxDecoration(
                color: ColorConstants.searchbarBackground,
                border: Border.all(color: Colors.white),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            width: widget.width ?? MediaQuery.of(context).size.width,
            child: Center(
              child: TextField(
                controller: widget.textController,
                textInputAction: widget.textInputAction,
                style: TextStyle(
                  fontSize: FontSizes.normalText2,
                  color: Colors.white,
                ),
                onChanged: widget.onChange as void Function(String)?,
                onSubmitted: widget.onSubmitted as void Function(String)?,
                cursorColor: ColorConstants.primaryColor,
                cursorHeight: FontSizes.largeText,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: ColorConstants.primaryColor,
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
