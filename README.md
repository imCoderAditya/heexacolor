
# Hexa Converter

A simple and lightweight Dart package to convert hexadecimal color codes into Flutter `Color` objects.

```
flutter pub add heexacolor

```

```
dependencies:
  heexacolor: ^0.0.2
```

## 🚀 Example & ✨ Features

```dart
// ✅ Convert Hex to Flutter Color easily
// ✅ Supports #RRGGBB and #AARRGGBB formats
// ✅ Clean and lightweight


HexColor("#fcba03")


import 'package:flutter/material.dart';
import 'package:heexacolor/heexacolor.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: HexColor("#4287f5"),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: HexColor("#fcba03"),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Hexa Converter Example',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
``` 