import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'features/price_comparison.dart';
import 'features/order_online.dart';

void main() => runApp(BarcodeScannerApp());

class BarcodeScannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcode Scanner & Price Comparison',
      home: ScannerHomePage(),
    );
  }
}

class ScannerHomePage extends StatefulWidget {
  @override
  _ScannerHomePageState createState() => _ScannerHomePageState();
}

class _ScannerHomePageState extends State<ScannerHomePage> {
  String scannedCode = '';
  Map<String, double> prices = {};

  Future<void> scanBarcode() async {
    var result = await BarcodeScanner.scan();
    setState(() {
      scannedCode = result.rawContent;
    });
    if (scannedCode.isNotEmpty) {
      prices = await PriceComparisonService().comparePrices(scannedCode);
      setState(() {});
    }
  }

  void orderOnline() async {
    if (prices.isNotEmpty) {
      var cheapestVendor = prices.entries.reduce((a, b) => a.value < b.value ? a : b).key;
      await OrderOnlineService().order(scannedCode, cheapestVendor);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed at $cheapestVendor!')), 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scanner & Compare')), 
      body: Column(
        children: [
          ElevatedButton(
            onPressed: scanBarcode,
            child: Text('Scan Barcode'),
          ),
          if (scannedCode.isNotEmpty)
            Text('Scanned: $scannedCode'),
          if (prices.isNotEmpty)
            ...prices.entries.map((e) => ListTile(
              title: Text('${e.key}: \$${e.value.toStringAsFixed(2)}'),
            )),
          if (prices.isNotEmpty)
            ElevatedButton(
              onPressed: orderOnline,
              child: Text('Order at Cheapest Price'),
            ),
        ],
      ),
    );
  }
}