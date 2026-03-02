import 'dart:io';
import 'package:farmer_app/presentation/pages/widgets/header_card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController harvestedDateController = TextEditingController();

  String? selectedUnit;

  final List<String> unitList = [
    "kg",
    "g",
    "ton",
    "quintal",
    "litre",
    "ml",
    "piece",
    "dozen",
    "box",
    "packet",
  ];

  File? _image;
  final ImagePicker _picker = ImagePicker();

  static const Color primaryGreen = Color(0xFF1B5E20);

  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryGreen,
              onPrimary: Colors.white,
              onSurface: primaryGreen,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        harvestedDateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }


  // Future<Map<String,dynamic>> addProduct(){
    
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          headerCard(
            title: "Add Product",
            icon: Icons.arrow_back,
            onIconPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildTextField(nameController, "Product Name"),
                          buildTextField(categoryController, "Category"),
                          buildTextField(subCategoryController, "Sub Category"),
                          buildTextField(
                            priceController,
                            "Price",
                            isNumber: true,
                          ),
                          buildTextField(
                            quantityController,
                            "Quantity",
                            isNumber: true,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: DropdownButtonFormField<String>(
                              value: selectedUnit,
                              hint: const Text("Select Unit"),
                              decoration: InputDecoration(
                                labelText: "Unit",
                                labelStyle: const TextStyle(
                                  color: primaryGreen,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: primaryGreen,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: unitList
                                  .map(
                                    (unit) => DropdownMenuItem(
                                      value: unit,
                                      child: Text(unit),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedUnit = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please select Unit";
                                }
                                return null;
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: TextFormField(
                              controller: harvestedDateController,
                              readOnly: true,
                              onTap: selectDate,
                              cursorColor: primaryGreen,
                              decoration: InputDecoration(
                                labelText: "Harvested Date",
                                labelStyle: const TextStyle(
                                  color: primaryGreen,
                                ),
                                suffixIcon: const Icon(
                                  Icons.calendar_today,
                                  color: primaryGreen,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: primaryGreen,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Harvested Date is required";
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              height: 140,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryGreen),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: _image == null
                                  ? const Center(
                                      child: Text(
                                        "Tap to Select Image",
                                        style: TextStyle(
                                          color: primaryGreen,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : Image.file(_image!, fit: BoxFit.cover),
                            ),
                          ),

                          const SizedBox(height: 35),

                          SizedBox(
                            width: 280,
                            height: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFF57C00),
                                    Color(0xFFFFB74D),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                                onPressed: ()async {
                                  if (_formKey.currentState!.validate()) {
                                    // final data = await addProduct();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: primaryGreen,
                                        content: Text(
                                          "Product Added Successfully",
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  "Add Product",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        cursorColor: primaryGreen,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: primaryGreen),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryGreen, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label is required";
          }
          return null;
        },
      ),
    );
  }
}
