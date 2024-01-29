### Dart-Intl-多语言系统

#### 安装包
```sh
dart pub add intl_translation
```

#### 在源码中启用多语言方法Intl.message，例下
注：Intl.message中的name参数需和函数名完全一致

The name and args parameters must match the name (or ClassName_methodName) and arguments list of the function respectively. For messages without parameters, both of these can be omitted.
```sh
// file: ~/Project/dtst/lib/localization.dart
import 'package:intl/intl.dart';

class AppLocalizations {
  String greetingMessage(String name) => Intl.message("Hello $name!",
      name: 'greetingMessage',
      args: [name],
      desc: "Greet the user as they first open the application",
      examples: const {'name': "Emily"});
}
```

#### 提取需要多语言文字为ARB文件
注：ARB文件非程式代码，无需放在lib下，如下便是放在和lib同级arbs目录下，若提取成功即可得到文件arbs/intl_messages.arb
```sh
mkdir arbs
dart run intl_translation:extract_to_arb  --output-dir=arbs lib/localization.dart
# 多个需要提取的文件
# dart run intl_translation:extract_to_arb  --output-dir=arbs lib/f1.dart lib/f2.dart lib/f3.dart
# dart run intl_translation:extract_to_arb  --output-dir=i18narb lib/localization.dart lib/localization2.dart
```

#### 基于intl_messages.arb生成多语言文档
如：复制intl_messages.arb为intl_zh_CN.arb和intl_zh_TW.arb，zh_CN即简体中文语言，zh_TW为繁体中文语言
注：仅需翻译无@前缀的方法名之后的文本即可，如下文的greetingMessage値文本
```json
// file: intl_messages.arb
{
  "@@last_modified": "2024-01-28T10:29:58.509391",
  "greetingMessage": "Hello {name}!",
  "@greetingMessage": {
    "description": "Greet the user as they first open the application",
    "type": "text",
    "placeholders": {
      "name": {
        "example": "Emily"
      }
    }
  }
}
```
```json
// file: intl_zh_CN.arb
{
  "@@last_modified": "2024-01-28T10:29:58.509391",
  "greetingMessage": "你好 {name}!",
  "@greetingMessage": {
    "description": "Greet the user as they first open the application",
    "type": "text",
    "placeholders": {
      "name": {
        "example": "Emily"
      }
    }
  }
}
```

#### 用arb文件生成对应的dart代码
例：generate_from_arb生成dart代码，建议放在lib/i10n目录下

注：若dart代码文件生成功，可得到lib/i10n/messages_all.dart文件
```sh
mkdir lib/l10n
dart run intl_translation:generate_from_arb --output-dir=lib/i10n --no-use-deferred-loading lib/localization.dart i18narb/intl_*.arb
# 多个需要提取的文件
# dart run intl_translation:generate_from_arb --output-dir=lib/i10n --no-use-deferred-loading lib/f1.dart lib/f2.dart lib/f3.dart i18narb/intl_*.arb
# dart run intl_translation:generate_from_arb --output-dir=lib/i10n --no-use-deferred-loading lib/localization.dart lib/localization2.dart i18narb/intl_*.arb
```

#### 在项目中引入多语言系统
```dart
// file :main.dart

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:dtst/localization.dart';
import 'package:dtst/i10n/messages_all.dart';

void main() {
  // 设定默认语言为简体中文
  Intl.defaultLocale = 'zh_CN';
  // 加载上述默认的语言包
  initializeMessages(Intl.defaultLocale).then((intl) {
	final alocale = AppLocalizations();
	print(alocale.greetingMessage('世界')); // 多语言输出
  });
  print(alocale.greetingMessage('world'));
}
```
```sh
dart run main.dart
# 输出结果
# Hello world!
# 你好 世界!
```

#### 在defaultLocale下临时挂载其他语言
注：Intl.withLocale可临时挂载其他语言，但是需在initializeMessages之后才生效，若无initializeMessages时仅用message托底
```dart
	 appectLocale = 'zh_TW';
     Intl.withLocale(
      appectLocale,
      () {
        initializeMessages(appectLocale).then((intl) {
          print(alocale1.greetingMessage('世界'));
        });
      },
    );
```
