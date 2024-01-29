
### flutter localization step by step
https://flutter.cn/docs/development/accessibility-and-localization/internationalization

https://lokalise.com/blog/flutter-i18n/

https://localizely.com/blog/flutter-localization-step-by-step/?tab=using-gen-l10n

#### Step 1: Add dependencies
```sh
flutter pub add flutter_localizations --sdk=flutter
flutter pub add intl:any
```
#### Step 2: Enable generation of localization files
To enable automatic generation of localization files, update the flutter section of the pubspec.yaml file.

``` ymal
# The following section is specific to Flutter packages.
flutter:
    generate: true
  # Other config...
```

#### Step 3: Configure localization tool
Create a new l10n.yaml file in the root of the Flutter project. 

```ymal
arb-dir: lib/l10n
template-arb-file: intl_en.arb
output-localization-file: app_localizations.dart
```

#### Step 4: Add translation files
Next, let's add the l10n directory with three ARB files: intl_zh.arb, intl_en.arb.


The intl_en.arb file:
```json
{
  "helloWorld": "Hello World!"
}
```

The intl_zh.arb file:
```json
{
  "helloWorld": "北京欢迎你"
}

```

Note: The Flutter ARB file allows ICU syntax in messages. However, the gen_l10n tool is still in the active-development phase and does not yet fully support the entire ICU syntax. 

Localization in the iOS apps
```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleLocalizations</key>
<array>
  <string>ar</string>
  <string>en</string>
  <string>es</string>
</array>
```

#### Step 5: Run the app to trigger code generation
Note: Each time you run flutter pub get or flutter run command, you will trigger code generation. For generating the same files independently of the application, you can use the flutter gen-l10n command as an alternative.

update your l10n.yaml file with synthetic-package and output-dir config parameters.

```ymal
# Other config...
synthetic-package: false
output-dir: lib/l10n
```

#### Step 6: Update the app
The next step involves updating the MaterialApp widget with the localizationsDelegates and supportedLocales properties. So, let's import the generated app_localizations.dart file and set the needed values.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ...
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // ...
    );
  }
}
```
Finally, paste the snippet shown below somewhere in the code and hot-reload the app to see how everything works.
```dart
        // title: Text(widget.title),
        title: Text(AppLocalizations.of(context)!.helloWorld),
```
