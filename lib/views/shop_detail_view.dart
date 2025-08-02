import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_sdui/controllers/shop_detail_controller.dart';
import 'package:ecommerce_sdui/utils/stac.dart';
import 'package:ecommerce_sdui/utils/debug_logger.dart';

class ShopDetailView extends StatefulWidget {
  final String shopId;

  const ShopDetailView({super.key, required this.shopId});

  @override
  State<ShopDetailView> createState() => _ShopDetailViewState();
}

class _ShopDetailViewState extends State<ShopDetailView> {
  late ShopDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ShopDetailController());
    _loadShopDetail();
  }

  Future<void> _loadShopDetail() async {
    try {
      await _controller.loadShopDetail(widget.shopId);
    } catch (e) {
      DebugLogger.jsonParsing('ShopDetailView error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (_controller.error.value != null) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Shop Detail'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  _controller.error.value!,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _loadShopDetail(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      if (_controller.shopDetailUIConfig.value == null) {
        return const Scaffold(
          body: Center(
            child: Text('Shop detail configuration not available'),
          ),
        );
      }

      return Stac.fromJson(_controller.shopDetailUIConfig.value!, context);
    });
  }

  @override
  void dispose() {
    Get.delete<ShopDetailController>();
    super.dispose();
  }
}
