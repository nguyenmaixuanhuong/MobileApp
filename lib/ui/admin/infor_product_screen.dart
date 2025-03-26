// ignore_for_file: camel_case_types

import 'package:ct484_project/ui/products/products_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../share/dialog_utils.dart';

class InforProductScreen extends StatefulWidget {
  static const routeName = '/infor-product';
  InforProductScreen(
    Product? product, {
    super.key,
  }) {
    if (product == null) {
      this.product = Product(
        id: null,
        nameProduct: '',
        price: 0,
        nameCategory: '',
        description: '',
        imageUrl: '',
      );
    } else {
      this.product = product;
    }
  }
  late final Product product;
  @override
  State<InforProductScreen> createState() => _InforProductScreenState();
}

class _InforProductScreenState extends State<InforProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _editForm = GlobalKey<FormState>();
  late Product _editedProduct;
  var _isLoading = false;
  String? selectedCategory;
  List<String> categories = ['Nhẫn', 'Dây chuyền', 'Vòng'];
  bool _isValidImageUrl(String value) {
    return (value.startsWith('http') ||
        value.startsWith('https') && value.endsWith('.png') ||
        value.endsWith('.jpg') ||
        value.endsWith('.jpeg'));
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(() {
      if (!_imageUrlFocusNode.hasFocus) {
        if (!_isValidImageUrl(_imageUrlController.text)) {
          return;
        }
        setState(() {});
      }
    });
    _editedProduct = widget.product;
    _imageUrlController.text = _editedProduct.imageUrl;

    selectedCategory = widget.product.nameCategory;
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _editForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _editForm.currentState!.save();
    if (selectedCategory != null) {
      _editedProduct = _editedProduct.copyWith(nameCategory: selectedCategory!);
    }
    setState(() {
      _isLoading = true;
    });

    try {
      final productsManager = context.read<ProductsManager>();
      if (_editedProduct.id != null) {
        await productsManager.updateProduct(_editedProduct);
      } else {
        await productsManager.addProduct(_editedProduct);
      }
    } catch (error) {
      if (mounted) {
        await showErrorDialog(context, 'Something went wrong.');
      }
    }

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.product.id != null 
        ? const Text("Chỉnh sửa sản phẩm", style: TextStyle(fontSize: 16),)
         : const Text("Thêm sản phẩm mới",style: TextStyle(fontSize: 16),) ,
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _editForm,
                child: ListView(
                  children: <Widget>[
                    buildSelectCategory(),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildNameProductField(),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildPriceField(),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildDescriptionField(),
                    _buildProductPreview(),
                  ],
                ),
              ),
            ),
    );
  }

  TextFormField _buildNameProductField() {
    return TextFormField(
      initialValue: _editedProduct.nameProduct,
      decoration: const InputDecoration(
        labelText: 'Tên sản phẩm',
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 168, 0, 0)),
          // Màu biên khi focus
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.grey), // Màu biên khi không focus
        ),
      ),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Tên không được để trống';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(nameProduct: value);
      },
    );
  }

  TextFormField _buildPriceField() {
    return TextFormField(
      initialValue: _editedProduct.price.toString(),
      decoration: const InputDecoration(
        labelText: '  Giá',
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 168, 0, 0)),
          // Màu biên khi focus
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.grey), // Màu biên khi không focus
        ),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Đơn giá không được để trống';
        }
        if (double.tryParse(value) == null) {
          return 'Giá trị không chính xác';
        }
        if (double.parse(value) <= 0) {
          return 'Giá không được nhỏ hơn 0';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(price: int.parse(value!));
      },
    );
  }

  TextFormField _buildDescriptionField() {
    return TextFormField(
      initialValue: _editedProduct.description,
      decoration: const InputDecoration(
        labelText: '  Mô tả',
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 168, 0, 0)),
          // Màu biên khi focus
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.grey), // Màu biên khi không focus
        ),
      ),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Mô tả không được để trống';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(description: value);
      },
    );
  }

  Widget _buildProductPreview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(top: 8, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: _imageUrlController.text.isEmpty
              ? Image.network('https://cdn-icons-png.flaticon.com/512/3792/3792702.png')
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    _imageUrlController.text,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        Expanded(
          child: _buildImageURLField(),
        ),
      ],
    );
  }

  TextFormField _buildImageURLField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Hình ảnh sản phẩm'),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      controller: _imageUrlController,
      focusNode: _imageUrlFocusNode,
      onFieldSubmitted: (value) => _saveForm(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter an imagge URL';
        }
        if (!_isValidImageUrl(value)) {
          return 'Please enter a valid image URL';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(imageUrl: value);
      },
    );
  }

  Widget buildSelectCategory() {
    return DropdownMenu(
      width: 325,
      label: const Text('Chọn loại sản phẩm', style: TextStyle(fontSize: 14),),
      initialSelection: selectedCategory != '' ? selectedCategory : null,
      onSelected: (String ? category){
        setState(() {
          selectedCategory = category!;
           _editedProduct =
                  _editedProduct.copyWith(nameCategory: category);
        });
      },
      dropdownMenuEntries:
          categories.map<DropdownMenuEntry<String>>((String category) {
        return DropdownMenuEntry(value: category, label: category);
      }).toList(),

    );
    
  }
}
