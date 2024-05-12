import 'package:easy_party/consts/colors.dart';
import 'package:easy_party/provider/FirebaseStorage.dart';
import 'package:easy_party/reusableWidgets/button.dart';
import 'package:easy_party/reusableWidgets/inputForAddNewItem.dart';
import 'package:easy_party/reusableWidgets/numberInput.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class addNewProductModal extends StatelessWidget {
  const addNewProductModal({super.key, required this.inviteCode});

  final String inviteCode;

  @override
  Widget build(BuildContext context) {

    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _countController = TextEditingController();
    final TextEditingController _priceController = TextEditingController();

    final storage = Provider.of<FirebaseStorage>(context);


    return AlertDialog(
      backgroundColor: purple,
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(30.0))),
      content: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BaseForAddNewItem(
                  Controller: _nameController,
                  hintText: '',
                  labelText: 'Product name'),
              BaseNumberInput(
                  Controller: _countController,
                  hintText: '',
                  labelText: 'Count'),
              BaseNumberInput(
                  Controller: _priceController,
                  hintText: '',
                  labelText: 'Price per one'),
              BaseButton(
                  buttonText: 'Pick icon', size: 1),
              GestureDetector(
                  onTap: () {
                    storage.newAddProductToEvent(
                        _nameController.text,
                        _priceController.text,
                        _countController.text,
                        inviteCode);
                    Navigator.of(context).pop();
                  },
                  child: BaseButton(
                      buttonText: 'Add item', size: 1)),
            ],
          ),
        ),
      ),
    );
  }
}
