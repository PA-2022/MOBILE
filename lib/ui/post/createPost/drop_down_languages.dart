import 'package:flutter/material.dart';

class DropDownLanguages extends StatefulWidget {
  const DropDownLanguages({ Key? key }) : super(key: key);

  @override
  State<DropDownLanguages> createState() => _DropDownLanguagesState();
}

class _DropDownLanguagesState extends State<DropDownLanguages> {
  
  @override
  Widget build(BuildContext context) {
    String selectedValue = "Language";
    return DropdownButton(items: dropdownItems,
    value:  selectedValue, onChanged: (String? newValue){
        setState(() {
          selectedValue = newValue!;
        });
      },
      
      
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems{
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(child: Text("USA"),value: "USA"),
    const DropdownMenuItem(child: Text("Canada"),value: "Canada"),
    const DropdownMenuItem(child: Text("Brazil"),value: "Brazil"),
    const DropdownMenuItem(child: Text("England"),value: "England"),
  ];
  return menuItems;
  }
}
