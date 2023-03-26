import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

const List<String> categories = <String>['Meat', 'Seafood', 'Fruit', 'Vegetables',
                                         'Frozen', 'Drinks', 'Bread', 'Sweets',
                                         'Dairy', 'Ready meals',
                                         'Dry & canned goods', 'Other'];

class NewItemForm extends StatefulWidget {
  const NewItemForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewItemFormState createState() => _NewItemFormState();
}

@override
class _NewItemFormState extends State<NewItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _barcodeField = TextEditingController();
  var _itemName = TextEditingController();
  var _expDate = TextEditingController();
  var _openDate = TextEditingController();
  bool click = true;
  String dropdownValue = categories.first;

  void _discardChangesDialog() {
    if(_itemName.text.isEmpty && _barcodeField.text.isEmpty &&
       _openDate.text.isEmpty && _expDate.text.isEmpty) {
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: const Text('Discard changes?'),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('DISCARD'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        //mainAxisAlignment: MainAxisAlignment.center,
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: FloatingActionButton(
                    child: Icon(Icons.close),
                    onPressed: () => _discardChangesDialog(), //Close sheet
                  ),
              )
            ],
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Text(
                'ADD ITEM',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
          ),
          SizedBox( height: MediaQuery.of(context).size.height * 0.03),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    var res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SimpleBarcodeScannerPage(),
                        ));
                    setState(() {
                      if (res is String) {
                        _barcodeField.text = res;
                      }
                    });
                    //Res will be the EAN-code
                    //Here add OFF-api call and populate item name and category
                    //fields if the product was found
                    //_itemName.text =
                    //_itemCat.text =
                  },
                  icon: Icon(Icons.camera_alt),
                  label: const Text('SCAN ITEM'),
                ),
              ),
              SizedBox( height: MediaQuery.of(context).size.height * 0.03),
              SizedBox(
                width: 150,
                child: TextFormField(
                  controller: _barcodeField,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                   labelText: 'Barcode',
                  ),
                ),
              ),
            ],
          ),
          SizedBox( height: MediaQuery.of(context).size.height * 0.03),
          SizedBox(
            child: TextFormField(
              controller: _itemName,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Item name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter item name";
                }
                return null;
              },
            ),
          ),
          SizedBox( height: MediaQuery.of(context).size.height * 0.03),
          SizedBox(
            child: DropdownButtonFormField<String>(
              value: dropdownValue,
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          SizedBox( height: MediaQuery.of(context).size.height * 0.03),
          SizedBox(
            child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    click = !click;
                  });
                },
                icon: Icon((click == false) ? Icons.favorite : Icons.favorite_border),
                label: Text('Mark as an "everyday" item'),
            ),
          ),
          TextFormField(
              controller: _expDate,
              decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  labelText: "EXPIRATION DATE"
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:DateTime(2000),
                    lastDate: DateTime(2101));
                if(pickedDate != null) {
                  String expirationDate = pickedDate.day.toString() + "." +  pickedDate.month.toString() + "." + pickedDate.year.toString();
                  _expDate.text = expirationDate;
                } else {
                  _expDate.text = "";
                };
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter expiration date";
                }
                return null;
              },
            ),
          TextFormField(
            controller: _openDate,
            decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: "OPENED"
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate:DateTime(2000),
                  lastDate: DateTime(2101));
              if(pickedDate != null) {
                String openedDate = pickedDate.day.toString() + "." +  pickedDate.month.toString() + "." + pickedDate.year.toString();
                _openDate.text = openedDate;
              } else {
                _openDate.text = "";
              };
            },
          ),
          SizedBox( height: MediaQuery.of(context).size.height * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                child: ElevatedButton(
                  onPressed: () => _discardChangesDialog(),
                    child: Text('CANCEL'),
                  ),
                ),

              SizedBox( width: MediaQuery.of(context).size.width * 0.03,),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                child: ElevatedButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()) {
                      print("OK");
                    }
                  },
                  child: Text('ADD ITEM'),
                ),
              ),
            ],
            ),
            ],
          )
    );
  }
}

