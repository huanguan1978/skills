# 用Composer为Framework引入Loaclhost第三方代码库

## 克隆第三方代码库
这里以orz/dhb为例，下载到本地路径下
```shell
cd e:\xscript\htdocs\
git clone https://github.com/huanguan1978/dbh.git
```
克隆完成后会在e:\xscript\htdocs\orz\dbh\得到完整代码

---

## 用Framework创建项目，若已有项目可略过
例1：Thinkphp6创建tp6tst项目
```shell
composer create-project thinkphp/think tp6tst --no-dev
``` 
例2：Thinkphp5.1创建tp5tst项目
```shell
composer create-project topthink/think=5.1.* tp5tst --no-dev
``` 
例3：Laravel6创建lv6tst项目
```shell
composer create-project --prefer-dist laravel/laravel lv6tst "6.*" --no-dev
``` 
例4：CodeIgniter4创建lv6tst项目
```shell
composer create-project codeigniter4/appstarter project-root --no-dev
``` 
---

## 在Framework项目中引入Localhost第三方代码库

- 添加本地第三方代码库到composer.json
```json
    // other config 
    "repositories": {
        "orz/dbh": {
            "type": "path",
            "url": "E:\\xscripter\\htdocs\\orz\\dbh"
        }
    }
```
- 用composer加载第三方代库
```shell
    composer require orz/dbh:dev-main
```

---

## 在Framework项目中引入Localhost第三方代码库中的ServiceProvider
    以下示列均以orz/dhb为例

### Thinkphp添加Service
- 自动添加
如果你需要在你的扩展中注册系统服务，首先在扩展中增加一个服务类，然后在扩展的 composer.json 文件中增加如下定义：
```json
    "extra": {
        "think": {
            "services": [
                "Dbh\\thinkphp\\service\\DbhService"
            ]
        }
    }
```
在安装扩展后会系统会自动执行 service:discover 指令用于生成服务列表，并在系统初始化过程中自动注册。

- 手动添加
以在项目的全局公共文件 service.php 中定义需要注册的系统服务，系统会自动完成注册以及启动。例如：
 - Thinkphp6，app/service.php
    ```php
        <?php
        use app\AppService;
        return [
            AppService::class,
            // myService
            \Dbh\thinkphp\service\DbhService::class,
        ]; 
    ```
 - Thinkphp5.1，application/provider.php
    ```php
        <?php
        return [
            'dbh'=>Dbh\thinkphp\provider\DbhProvider::class
        ];
    ```
 - Thinkphp5.0，TP5.0框架自已没有实现APP容器类，可以通过Request类的单例模式进行注入
    这里以TP5.0控制器中的注入为例
    ```php
        <?php
        namespace app\index\controller;

        use think\Request;
        use Dbh\thinkphp\provider\DbhProvider;

        class Index extends Controller {

            protected $dbh = null;

            function _initialize(){
                
                $this->dbh = DbhProvider::invoke($this->request);
                parent::_initialize();
            }
            /**
             * 测试1，属性注入后用助手函数request()调用
             * http://test12.localhost.localdomain/index/index/test1
             */
            function test1(){
                $result = 'HelloThinkphp50';

                $dbh = request()->dbh;
                $wlog = $this->dbh->wlog('db');
                $wlog->info($result);

                return $result;
            }
        }
        ```

### Laravel添加Service
- 自动添加
如果你需要在你的扩展中注册系统服务，首先在扩展中增加一个服务类，然后在扩展的 composer.json 文件中增加如下定义：
```json
    "extra": {
        "laravel": {
            "providers": [
                "Dbh\\Laravel\\Providers\\DbhServiceProvider"
            ],
            "aliases": {
                "Dbf": "Dbh\\Laravel\\Facades\\DbhFacade"
            }            
        }
    }
```
在安装扩展后会系统会自动执行 service:discover 指令用于生成服务列表，并在系统初始化过程中自动注册。
由于laravel的 package:discover 是读取 vendor/composer/installed.json 这个文件中安装的包，
而我们的包是手动添加，所以无法自动添加ServiceProvider，只能手动添加在app.php。

- 手动添加
以在项目的全局公共文件 config/app.php 中定义需要注册的系统服务，系统会自动完成注册以及启动。例如：
```php
    'providers' => [
        //My Dbh Service Providers...
        Dbh\Laravel\Providers\DbhServiceProvider::class,
    ],
    'aliases' => [
        // My Dbh Facade...
        'Dbf' => Dbh\Facades\DbhFacade::class,
    ]            
```

### CodeIgniter添加Service
- 半自动添加
CodeIgniter可以自动发现所有你在其他命名空间里可能定义的 Config\Services.php 文件，只要你的命名空间在Config\Autoload.php中定义了能找到即可。
```php
    public $psr4 = [
        APP_NAMESPACE => APPPATH, // For custom app namespace
        'Config'      => APPPATH . 'Config',
        'Dbh\\CodeIgniter' => ROOTPATH.'vendor\\orz\\dbh\\src\\CodeIgniter\\',
    ];
```

---

## 在Framework项目中引入Localhost第三方代码库中的Middleware
    以下示列均以orz/dhb为例

### Thinkphp引入Middleware
TP5.1和TP6全局加载中间件
- TP6，app/middleware.php：
    ```php
        <?php
        return [
            Dbh\thinkphp\middleware\PlogBefore::class,
            Dbh\thinkphp\middleware\PlogAfter::class,
        ];
    ```
- TP5.1，config/middleware.php：
    ```php
    <?php
    return [
        // MyMiddleware
        'plog_before'=>\Dbh\thinkphp\middleware\PlogBefore::class,
        'plog_after'=>\Dbh\thinkphp\middleware\PlogAfter::class,
    ];
    ```
    然后在你的模块或路由或制控器中启用中间件，以控制器为例：
    ```php
        <?php
        namespace app\hello\controller;
        use think\Controller;
        class World extends Controller {
            protected $middleware = ['plog_before', 'plog_after'];
            // you method here
        }
    ```

### Laravel引入Middleware
LV6加载中间件，为了整体性能建议多用路由或控制器方法按需启用中间件
- LV6，app/Http/Kernel.php：
    ```php
    // 全局中间件
    protected $middleware = [
        // MyMiddleware PlogBefoer,PlogAfter
        \Dbh\Laravel\Middleware\PlogBefore::class,
        \Dbh\Laravel\Middleware\PlogAfter::class,      
    ];
    // 分组中间件，按需启用这里略过
    // 路由中间件
    protected $routeMiddleware = [
        // MyrouteMiddleware
        'plog.before'=> \Dbh\Laravel\Middleware\PlogBefore::class,
        'plog.after'=> \Dbh\Laravel\Middleware\PlogAfter::class,          
    ];    
    ```
    然后就可以全局或路由或控制器中起用中间件，以控制器为例：
    ```php
        <?php
        namespace App\Http\Controllers\hello;
        use App\Http\Controllers\Controller;
        use Illuminate\Http\Request;
        class ArchiveController extends Controller  {
            function __construct() {
                $this->middleware('plog.before');
                $this->middleware('plog.after');
            }

            public function index() {
                $result = 'nihao';
                return $result;
            }
        }
    ```    

---

## 在Framework项目中引入Localhost第三方代码库中的Event,Listener,Subscribes
    以下示列均以orz/dhb为例

### Thinkphp引入事件监听订阅
TP5.1和TP6可无事件类直接注册监听类

- TP6，app/config/event.php
    ```php
    <?php
    return [
        'listen'    => [
            // 自定义监听类,若用订阅者，则无需此处配置
            // 'SessionChange' =>['app\listener\SessionChanged', ],
        ],

        'subscribe' => [
            // 自定义订阅类
            'Dbh\thinkphp\subscribe\EnvChanged'
        ],
    ];
    ```
- TP6，触发事件，可用助手函数event(), 如：`event('SessionChange');`

- TP5，称之为钩子行为，TP5.1兼容TP5.0，application/tags.php：
    ```php
    <?php
    return [
        //MyBehavior，自定义行为标签
        'SessionChange' => ['Dbh\\thinkphp\\behavior\\SessionChanged', ],
        'ConfigChange' =>  ['Dbh\\thinkphp\\behavior\\SessionChanged', ],    
        'CookieChange' =>  ['Dbh\\thinkphp\\behavior\\CookieChanged', ],    
        'EnvChange' =>     ['Dbh\\thinkphp\\behavior\\EnvironChanged', ],
        'GlobalsChange' =>     ['Dbh\\thinkphp\\behavior\\GlobalsChanged', ], 
    ];
    ```
- TP5.1，触发事件即钩子触发行为
 1. `use think\facade\Hook`
 2. `Hook::listen('SessionChange');`

- TP5.0，触发事件即钩子触发行为
 1. `use think\Hook;`
 2. `Hook::listen('SessionChange')`
 注意orz/dbh系例事件因TP5.0无Service层，采用了Request的单例模式，需在listen钩子触发前注入DbhServer，可参阅
Thinkphp添加Service部份TP5.0示例。

### Laravel引入事件监听订阅
LV6必需有事件类存在

- LV6，app/Providers/EventServiceProvider.php
    ```php
    protected $listen = [
        Registered::class => [ SendEmailVerificationNotification::class,        ],
        /*
        // 自定义事件及监听者，若启用订阅者则无需此处配置        
        \Dbh\Laravel\Events\SessionChange::class => [
            \Dbh\Laravel\Listeners\SessionChanged::class,
        ],
        */
    ];
    // 要注册的订阅者 
    protected $subscribe = [
        'Dbh\Laravel\Subscribes\EnvChanged',
    ];
    ```
- LV6，触发事件，可用助手函数event()
 1. `use Dbh\Laravel\Events\SessionChange;`
 2. `event(new SessionChange());`

### CodeIgniter4引入事件监听订阅
CI4无需事件类，直接处理监听者逻辑即可
- 自动发现机制
    CodeIgniter可以自动发现所有你在其他命名空间里可能定义的 Config\Events.php 文件，只要你的命名空间在Config\Autoload.php中定义了能找到即可，可参见Service部份的CodeIgniter4内容。
- CI4，触发事件
 1. `use \CodeIgniter\Events\Events;`
 2. `Events::trigger('SessionChange');`
