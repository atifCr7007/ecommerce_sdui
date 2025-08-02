import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_sdui/controllers/marketplace_controller.dart';
import 'package:ecommerce_sdui/models/shop.dart';
import 'package:ecommerce_sdui/models/product.dart';
import 'package:ecommerce_sdui/views/widgets/product_grid_widget.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ecommerce_sdui/utils/stac.dart';

class ShopView extends StatefulWidget {
  final String shopId;

  const ShopView({super.key, required this.shopId});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  Map<String, dynamic>? _shopsUIConfig;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJsonUI();
  }

  Future<void> _loadJsonUI() async {
    final jsonString = await rootBundle.loadString('assets/json_ui/shops_tab.json');
    setState(() {
      _shopsUIConfig = json.decode(jsonString);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _shopsUIConfig == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Stac.fromJson(_shopsUIConfig!, context);
  }
}
