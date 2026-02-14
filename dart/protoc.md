### Dart-Protoc-Plugin


#### 下载编译器, 以`29.6`版为例
官方二进制包下载地址为 https://github.com/protocolbuffers/protobuf/releases/tag/v29.6
```shell
# donwload protoc
cd ~/Downloads
wget https://github.com/protocolbuffers/protobuf/releases/download/v29.6/protoc-29.6-osx-x86_64.zip
unzip protoc-29.6-osx-x86_64.zip

# install protoc
cd protoc-29
sudo cp bin/protoc /usr/local/bin/
sudo cp -r include/google /usr/local/include/
sudo chmod +x /usr/local/bin/protoc
```

#### 安装插件包
```shell
dart pub global activate protoc_plugin
```

#### 项目示例及目录结构
```shell
dart create myapp
dart pub add protobuf

cd myapp
mkdir -p lib/generated
mkdir proto
```

#### 使用vscode插件Buf,生成如下两个文件

- Buf插件工作目录: myapp/buf.work.yaml
```yaml
version: v1
directories:
  - proto
```
- Buf插件校验规则: myapp/proto/buf.yaml
```yaml
version: v1
lint:
  use:
    - DEFAULT
```

#### 编写`.proto`，数据及类型声明
```proto
syntax = "proto3";

package contacts.v1;

// proto/contacts/v1/person.proto
message Person {
    string name = 1;
    int32 age = 2;
}

```

#### 生成dart代码
```shell
protoc --proto_path=proto --dart_out=lib/generated proto/contacts/v1/person.proto 
```

#### 使用dart代码
```dart
import 'package:myapp/generated/contacts/v1/person.pb.dart';

void main() {
// Create a new Person object
var person = Person()
..name = 'Alice'
..age = 30;

// Serialize to bytes
var bytes = person.writeToBuffer();

// Deserialize from bytes
var person2 = Person.fromBuffer(bytes);

print('Name: ${person2.name}, Age: ${person2.age}');
}
```

#### 排除生成代码的格式化
在项目根目录的 `analysis_options.yaml` 中添加如下内容：
```yaml
analyzer:
  exclude:
    - "lib/generated/**/*.dart"
    - "**/*.pb.dart"
    - "**/*.pbjson.dart"
    - "**/*.pbenum.dart"
    - "**/*.pbserver.dart"
```