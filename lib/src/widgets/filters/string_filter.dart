import 'package:dynamic_searchbar/src/constants/enums.dart';
import 'package:dynamic_searchbar/src/widgets/global_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StringFilter extends HookWidget {
  const StringFilter({
    Key? key,
    required this.searchKey,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  final String searchKey;
  final String hintText;
  final Function(String, StringOperator) onChanged;

  List<DropdownMenuItem<StringOperator>> get dropdownItems {
    List<DropdownMenuItem<StringOperator>> menuItems = StringOperator.values
        .map((operator) =>
            DropdownMenuItem(value: operator, child: Text(operator.name)))
        .toList();

    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: searchKey);
    final selectedOperator = useState(StringOperator.values.first);

    final themeData = GlobalSearchbar.of(context)?.themeData;
    var decoration = themeData?.stringFilterTheme.decoration ??
        InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            size: 18.0,
            color: themeData?.iconColor ?? Theme.of(context).primaryColorLight,
          ),
          hintText: hintText,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(
              color: themeData?.primaryColor ?? Theme.of(context).primaryColor,
              width: 1.0,
            ),
          ),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              controller: controller,
              onChanged: (text) => onChanged(text, selectedOperator.value),
              style: themeData?.stringFilterTheme.style,
              decoration: decoration,
            ),
          ),
          Container(
            height: 48.0,
            padding: const EdgeInsets.only(left: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                  ),
                  child: DropdownButton<StringOperator>(
                    value: selectedOperator.value,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    onChanged: (operator) {
                      selectedOperator.value = operator!;

                      onChanged(controller.text, operator);
                    },
                    items: dropdownItems,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
