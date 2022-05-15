Laravel6手记

## 安装laravel
```shell
composer create-project --prefer-dist laravel/laravel lv6tst "6.*" --no-dev
```
---
## 开启日志
	日志记录参数		你可以使用 Log::info()，或使用更短的 info() 额外参数信息，来了解更多发生的事情
		Log::info('User failed to login.', ['id' => $user->id]);
	更方便的 DD
		你可以在你的 Eloquent 句子或者任何集合结尾添加 ->dd()，而不是使用 dd($result)
		// Instead of
		$users = User::where('name', 'Taylor')->get();
		dd($users);
		// Do this
		$users = User::where('name', 'Taylor')->get()->dd();
	快速输出Query的sql
		$invoices = Invoice::where('client', 'James pay')->toSql();
		dd($invoices)
		// select * from `invoices` where `client` = ? 
	开发模式打印所有数据库查询
		如果要在开发期间记录所有数据库查询，请将此代码段添加到AppServiceProvider
		public function boot()
		{
			if (App::environment('local')) {
				DB::listen(function ($query) {
					logger(Str::replaceArray('?', $query->bindings, $query->sql));
				});
			}
		}		
---	 
## 脚手架常用
- 启动内置服务器 `php artisan serve`
- 查看LV框架版本 `php artisan --version`
- 查看可能的命令 `php artisan list`

### 快速处理缓存
- 清除缓存文件 `php artisan cache:clear`

### 快速处理路由
- 查看路由列表 `php artisan route:list`
- 生成路由缓存 `php artisan route:cache`
- 清除路由缓存 `php artisan route:clear`
	
### 快速生成控制器
- 指定目录	`php artisan make:controller hello/WorldController`
- 默认目录	`php artisan make:controller WorldController`		
- REST风格	`php artisan make:controller WorldController --resource`
- 单一动作  `php artisan make:controller ShowProfile --invokable`
- 资源模型  `php artisan make:controller PostController --resource --model=Post`

### 快速生成模型
- 指定目录   	`php artisan make:model helloModel/WorldModel`
- 默认目录   	`php artisan make:model WorldModel`

###	快速创建中间件	`php artisan make:middleware PlogBefore`
- 全局启用中间件，在app/Http/Kernel.php的$middleware中添加如下
	```php
        \App\Http\Middleware\PlogBefore::class,
        \App\Http\Middleware\PlogAfter::class,      	
	```
- 路由启用中间件，
	1. 在app/Http/Kernel.php的$routeMiddleware中添加如下
	```php
        'plog.before'=> \Dbh\Laravel\Middleware\PlogBefore::class,
        'plog.after'=> \Dbh\Laravel\Middleware\PlogAfter::class,	
	```
	2. 在route.php中用middleware方法(在group方法之前)为路由为配中间件
	```php
	Route::namespace('hello')->prefix('hello/world')->middleware('plog.before','plog.after')->group(function () {
		// 在 「App\Http\Controllers\hello」 命名空间下的控制器
		Route::get('say',  'WorldController@say');
		Route::get('spk',  'WorldController@spk');
	});	
	```



### 快速创建服务提供者 `php artisan  make:provider HelloServiceProvider`
1. 为服务者功能编码
	```php
    public function boot()    {
        // 添加模板自定义扩展名和解析引擎
        View::addExtension('phtml', 'php'); 
    }	
	```
2. 为服务者注册启动，添加你的服务者在config/app.php中providers 数组中
	```php
	'providers' => [
		// 其它服务提供者
		App\Providers\HelloServiceProvider::class, // 你的服务者
	];
	```
- [ ] TODO 服务提供者延迟加载	

###	快速生成模块(eg:TP6,Module), 
1. 指定目录控制器 `php artisan make:controller hello/WorldController`
2. 路由定义
- 简洁式
```php
	Route::get('hello/world/say/{name}', 'hello\WorldController@say');
```
- 命名空间式
```php
Route::namespace('hello')->prefix('hello/world')->group(function () {
	// 在「App\Http\Controllers\hello」命名空间下的控制器
	Route::get('say',  'WorldController@say');
	Route::get('ohce', 'WorldController@ohce');    
});
```
3. 访问路径 `http://localhost:8000/hello/world/say?name=abc`

## 路由
**POST请求受CSRF保护时返回419状态码时**
*在app/Http/Middleware/VerifyCsrfToken.php的$except数组中添加无需CSRF的路由*

### 路由重定向
- *302临时重定向*	`Route::redirect('/here', '/there');`
- *301永久重定向*	`Route::redirect('/here', '/there', 301);`
- *首页重定向*		`Route::redirect('/', '/wellcome');`

### 路由视图 [^1]
- 使用静态方法 [^2] `Route::view('/wellcome', 'wellcome', ['site_name' =>'Laravel6教学'] );`
- 使用助手函数
	```php
	Route::get('/wellcome', function(){
		return view('wellcome', ['site_name' =>'Laravel6教学']);
	});	
	```
[^1]:==视图文件==位置为，resources/views/welcome.blade.php
[^2]:==静态方法==使用时，参1为URI，参2为视图名，参3为变量



### 路由参数
- **可选参数** `{name?}`, `http://abc.com/hello`, `http://abc.com/hello/world`
	```php
	Route::get('/hello/{name?}', function($name=null){
		return 'hello '. $name?:'noname';
	});
	```
- **必选参数** `{name}`, `http://abc.com/hello/world`
	```php
	Route::get('/hello/{name}', function($name){
		return 'hello ' . $name;
	});
	```		
- **单参数正则约束**，路由实例的where方法传参标量
	```php
	Route::get('/hello/{name}', function($name){
		return 'hello ' . $name;
	})->where('name', '[A-Za-z]+');
	```	
- **多参数正则约束**，路由实例的where方法传参数组
	```php
	Route::get('/user/{id}/{name}', function($id, $name){
		return 'hello ' . $id . $name;
	})->where(['id'=>'[0-9]+', 'name'=>'[A-Za-z]+']);
	```			
- **全局参数约束**, 在app/Providers/RouteServiceProvider.php中boot方法内定义Route::pattern
	```php
	public function boot() {
		Route::pattern('id', '[0-9]+'); // 全局路由参数约束，所有URL传id参数时受约束
		parent::boot();
	}
	```
### 路由命名
- **命名**
	```php
	Route::get('user/profile', function () {			
		return 'my url: ' . route('profile'); // // 通过路由名称生成 URL
	})->name('profile');
	Route::get('user/profile', 'UserController@showProfile')->name('profile');
	```
- **调用**
	```php
	$url = route('profile'); // 生成URL
	return redirect()->route('profile'); // 生成重定向
	```
### 路由分组[多个路由共享路由属性(如:共享命名空间、中间件等)]
- **共享命名空间**
	```php			
	Route::namespace('hello')->prefix('hello/world')->group(function () {
		// 在「App\Http\Controllers\hello」命名空间下的控制器
		Route::get('say',  'WorldController@say');
		Route::get('ohce', 'WorldController@ohce');    
	});
	```
- **共享中间件**，按顺序执行middleware中的数组中列出的中间件
	```php			
	Route::middleware(['firstMiddleware', 'secondMiddleware'])->prefix('hello/world')->group(function () {
		// 在「App\Http\Controllers\hello」命名空间下的控制器
		Route::get('say',  'WorldController@say');
		Route::get('ohce', 'WorldController@ohce');    
	});
	```
- **子域名路由**，需定义在主域名路由之前
	```php
		Route::domain('{account}.blog.dev')->group(function (){
			Route::get('user/{id}', function ($account, $id) {
				return 'This is ' . $account . ' page of User ' .$id;
			});
		});
	```
- **名称前缀**，name和prefix都可以处理前缀
	```php
	Route::name('admin.')->group(function () {
		Route::get('users', function () {
		// 新的路由名称为 "admin.users"...
		})->name('users');
	})
	```				
### 路由数据模型绑定
-	**隐性注入**，{user}对应App\User模型实例$user，
	```php
		Route::get('users/{user}', function (App\User $user) {
			return $user->email;
		});	
	```
-	**显性绑定**，
	1. 使用Route::model在RouteServiceProvider 类的 boot 方法指定，
	```php
		public function boot(){
			parent::boot();
			Route::model('user_model', App\User::class);
		}
	```
	2. routes/web|api中路由参数处理
	```php
	Route::get('users/{user_model}', function(App\User $user) {
		return $user->email;
	})	
	```
-	**注意事项**
	1. 若主键名不是id，则需重写Eloquent模型类App\User的getRouteKeyName()，返回主键名
	2. 如果匹配模型实例在数据库中不存在，会自动生成 404 响应

### 兜底路由
-	**所有路由都无法匹配时则执行**Route::fallback
	```php
	Route::fallback(function () {
			//
	})		
	```
	注：异常处理器会自动渲染一个「404」页面,兜底路由应该放所有路由之后)
### 频率限制
	参见中间件throttle用法

### 表单方法伪造
	即为提交表单指定用PUT、PATCH、DELETE中某一方法
- *HTML示例*
	```html
	<form action="/foo/bar" method="POST">
		<input type="hidden" name="_method" value="PUT">
		<input type="hidden" name="_token" value="{{ csrf_token() }}">
	</form>
	```
- *Blade示例*
	```html
	<form action="/foo/bar" method="POST">
		@method('PUT')
		@csrf
	</form>
	```
### 访问当前路径
- 获取当前路由实例 `$route = Route::current();`
- 获取当前路由名称 `$name = Route::currentRouteName();`
- 获取当前路由动作 `$action = Route::currentRouteAction();` 

---
## 中间件

### 请求前处理
```php
	<?php
	namespace App\Http\Middleware;
	use Closure;
	class BeforeMiddleware {
		public function handle($request, Closure $next){
			// 执行动作
			return $next($request);
		}
	}
```	
### 请求后处理
```php
	<?php
	namespace App\Http\Middleware;
	use Closure;
	class AfterMiddleware	{
		public function handle($request, Closure $next)	{
			$response = $next($request);
			// 执行动作
			return $response;
		}
	}
```	

### 终端中间件
	terminate中间件是在浏览器发送response之后去作一些善后处理，此方法同时接收 request和response
```php
	<?php
	namespace Illuminate\Session\Middleware;
	use Closure;
	class StartSession 	{
		public function handle($request, Closure $next)	{
			return $next($request);
		}
		public function terminate($request, $response)	{
		// 存储 session 数据...
		}
	}
```

### 注册中间件
#### 全局中间件
	在每一个 HTTP 请求时都被执行，只需要将相应的中间件类添加到 app/Http/Kernel.php 的数组属性 $middleware 中即可
#### 指定路由中间件
1. 为中间件定义一个Key
	首先应该在 app/Http/Kernel.php 文件中分配给该中间件一个 key，
	默认情况下，该类的 $routeMiddleware 属性包含了 Laravel 自带的中间件，
	要添加你自己的中间件，只需要将其追加到后面并为其分配一个 key。
2. 在Route中用middleware方法引入
	```php
		Route::get('/', function () {
		//
		})->middleware('token');
	```
#### 中间件组
	**中间件组的目的只是让一次分配给路由多个中间件的实现更加方便**
	通过指定一个键名的方式将相关中间件分到同一个组里面，这样可以更方便地将其分配到路由中，
	这可以通过使用HTTP Kernel 提供的 $middlewareGroups 属性实现。
	如：Laravel 自带了开箱即用的 web 和 api 两个中间件组，分别包含可以应用到 Web 和 API 路由的通用中间。
```php
	Route::get('/', function () {
	//
	})->middleware('web');

	Route::group(['middleware' => ['web']], function () {
	//
	})
```

#### 中间件组顺序
	需要中间件按照特定顺序执行，你可以在 app/Http/Kernel.php 文件中通过 $middlewarePriority 属性来指定中间件的优先级
#### 中间件传参
1.	额外的中间件参数会在 $next 参数之后传入中间件
	```php
		<?php
		namespace App\Http\Middleware;
		use Closure;
		class CheckRole	{
			* @param \Illuminate\Http\Request $request
			* @param \Closure $next
			* @param string $role
			* @return mixed
			*/
			public function handle($request, Closure $next, $role)		{
				if (! $request->user()->hasRole($role)) {
				// Redirect...
				}
				return $next($request);
			}
		}
	```	
2.	中间件参数可以在定义路由时通过:分隔中间件名和参数名来指定，多个中间件参数可以通过逗号分隔
	```php
		Route::put('post/{id}', function ($id) {
			//
		})->middleware('role:editor')
	```	
---
## 事件监听订阅

- 生成事件类 `php artisan make:event SessionChange`
- 生成监听类 `php artisan make:listener SessionChanged`
- 生成事件类和监听类，通过在EventServiceProvider.php 的 $listen 数组清单
```shell
	php artisan event:generat
```
- 注册事件监听 
	- 手动注册，通过在EventServiceProvider.php 的 $listen 数组注册事件
	```php
        // MyEvent
        \App\Events\SessionChange::class => [
            \App\Listeners\SessionChanged::class,
        ],
        \Dbh\Laravel\Events\SessionChange::class => [
            \Dbh\Laravel\Listeners\SessionChanged::class,
        ],	
	```
	- 自动发现，监听类的handle方法，参数需以事件类签名
	```php
	use \App\Events\SessionChange;
	public function handle(SessionChange $event)	{
	//
	}	
	```
	事件发现默认是禁止的，你可以通过重写 EventServiceProvider.php 的 shouldDiscoverEvents 方法来开启
	```php
	public function shouldDiscoverEvents() {
		return true;
	}
	```
	事件发现默认是遍历app/Listener/目录下的监听类，	若需搜索额外的目录可以重写 EventServiceProvider.php 的 discoverEventsWithin 方法		
	```php
	public function discoverEventsWithin() {
		return [
		$this->app->path('Listeners'),
		// $this->app->path('Listeners'), // Vendor下的路径
		]
	}
	```
- 事件缓存
	缓存应用事件及监听器 `php artisan event:cache`
	查看应用事件及监听器 `php artisan event:list`
	清除缓存事件及监听器 `php artisan event:clear`

- 分发事件，用event辅助函数
```php
	// use \App\Events\SessionChange;
	// event(new SessionChange());
	use Dbh\Laravel\Events\SessionChange;
	event(new SessionChange());	
```	


- 事件订阅者
	监听多个事件的类谓之订阅者，通过用subscribe方法入参事件分发器来后用listen来监听事件
```php
<?php
namespace App\Listeners;
class UserEventSubscriber {
    
	// 处理用户登录事件.
    public function handleUserLogin($event) {}
    // 处理用户退出事件.
    public function handleUserLogout($event) {}
    /**
     * 为订阅者注册监听器.     *
     * @param  Illuminate\Events\Dispatcher  $events
     */
    public function subscribe($events){
        $events->listen('Illuminate\Auth\Events\Login','\Listeners\UserEventSubscriber@handleUserLogin'
        );
        $events->listen('Illuminate\Auth\Events\Logout',
            'App\Listeners\UserEventSubscriber@handleUserLogout'
        );
    }
}
```
	编程好订阅者后需在EventServiceProvider.php中的$subcribe属性中注册订阅者
```php
    protected $subscribe = [
         'App\Listeners\UserEventSubscriber',
    ];
```

---
## 控制器
### REST风格资源模型控制器
- 快速创建 `php artisan make:controller hello/ArchiveController --resource --model=helloModel/ArchiveModel`
- 单个资源路由 `Route::resource('hello/archives', 'hello/ArchiveController')`
- 多个资源路由 `Route::resources(['users'=>'UserController', 'hello/archives'=>'hello/ArchiveController'])`
- 资源路由部份，only和except参数
	```php
		Route::resource('post', 'PostController', ['only' =>['index', 'show'] ]);
		Route::resource('post', 'PostController', ['except'=>['create', 'store', 'update', 'destroy'] ]);
	```
- 添加资源路由
	```php
		Route::get('posts/popular', 'PostController@method'); // 在Route::resource之前添加
		Route::resource('posts', 'PostController');
	```
- 命名资源路由(URI不变更换方法名)，通过传入 names 数组来覆盖默认的名
	`Route::resource('posts', 'PostController', ['names'=>['create' => 'posts.build']])`
- 命名资源路由参数，
	1. 通过在选项数组中传递 parameters 来覆盖默认设置
	`Route::resource('users', 'AdminUserController', ['parameters' => ['users' => 'admin_user']])`
	2. 上面的示例代码会为资源的 show 路由生成如下 URL
	`/user/{admin_user}`
- 本地化资源URI(URI改命不更换方法名)，在AppServiceProvider的boot方法中指定Route::resourceVerbs
	```php
		use Illuminate\Support\Facades\Route;
		public function boot()	{
			Route::resourceVerbs([
			'create' => 'xinzeng',
			'edit' => 'bianji',
			]);
		}
	```
	定制化请求方式完成后，注册资源路由将从1变成2
	1. Route::resource('wenzhang', 'PostController')
	2. /wenzhang/xinzeng, /wenzhang/{wenzhang}/bianji

## HTTP响应
### 响应类型
	字符串即文本响应，数组即JSON响应，控制器返回的 Array 或 Eloquent 集合，自动转换为JSON响应。
- 	文本响应 `Route::get('/', function () { return 'Hello World';})`
- 	数组呼应 `Route::get('/', function () { return [1,2,3];})`
	
### 响应对象
	返回一个完整的 Response 实例允许你自定义响应的 HTTP 状态码和头信息，
	Illuminate\Http\Response 实例继承自Symfony\Component\HttpFoundation\Response 基类。

-	添加状态码和响应头
	```php
		Route::get('hello/world', function () {
			return response('Hello World', 200)
			->header('Content-Type', 'text/plain');
		});
	```	
	注：添加多个响应头可以用方法：header多次链调或withHeaders

-	添加cookie到响应

	默认Cookie都是签名加密过的，若无需加签可通过App\Http\Middleware\EncryptCookies提供的$except属性来排除这些 Cookie。

	1. 响应实例的cookie方法，接收参数cookie($name, $value, $minutes, $path, $domain, $secure, $httpOnly)
	```php
	return response($content)
	->header('Content-Type', $type)
	->cookie('name', 'value', $minutes)		
	```
	2. 使用 Cookie 门面的输出响应队列
	```php
	Route::get('cookie/response', function() {
		Cookie::queue(Cookie::make('site', 'MySite',1));
		Cookie::queue('author', 'MyName', 1);

		return response('Hello Laravel', 200)
		->header('Content-Type', 'text/plain');
	});
	```	

-	重定向响应

	如果调用不带参数的 redirect 方法，会返回一个 Illuminate\Routing\Redirector 实例，
	然后就可以使用 Redirector 实例上的所有方法。

	- 重向定到命名路由 `return redirect()->route('login');`
	- 重向定到命名路由带标量参数 	`return redirect()->route('profile', ['id'=>1]); `
	- 重向定到命名路由带模型参数
	```php
	return redirect()->route('profile', [$user]); 
	```
	带模型参数时，路由创建时需要参数有Eloquent模型绑定，模型带参时的默认id若需自定义需要重写模型实例上的 getRouteKey方法
	```php
	public function getRouteKey(){
		return $this->slug;	
	}	
	```

	- 重定向到控制器动作 `return redirect()->action('HomeController@index')`
	- 重定向到控制器动作带标量参数 `return redirect()->action('UserController@profile',['id'=>1])`
	- 重定向到外部域名 `return redirect()->away('https://www.abc.com');`
	- 重定向带会话数据，这里Session数据为一次性数据，即为取出后数据就被销毁就不复存在
		1. 用with存储一次性Session
		```php
		Route::post('user/profile', function () {
			// 更新用户属性, 将数据存储到一次性Session中
			return redirect('dashboard')->with('status', 'Profile updated!');
		})	
		```
		2. 读出一次性Session数据
		```htmlx
		@if (session('status'))
			<div class="alert alert-success">
				{{ session('status') }}
			</div>
		@endif		
		```
### 其他响应类型

	除了 Response 和 RedirectResponse 两种响应类型，我们还可以通过辅助函数response()很方便生成其他类型响应实例；
	当无参数调用 response() 时会返回 Illuminate\Contracts\Routing\ResponseFactory 契约的一个实现，
	该契约提供了一些有用的方法来生成各种响应，如视图相应、JSON 响应，文件下载、流响应等。

-	可自定状态码和头信息的视图响应
	```php
	return response()->view('hello', $data, 200)->header('Content-Type', $type);	
	```
-	无需自定状态码和头信息的视图响应，可用全局助手函数view()
	```php
	Route::get('hello/{name?}', function() {
		return view('hello'); // 视图文件位置为resources/views/hello.blade.php
	})
	```
- 	JSON响应，自动添加响应头信息Content-Type为application/json且调用json_encode转换数据
	```php
		return response()->json(['name' => 'Abigail','state' => 'CA'])
	```	
- 	JSONP响应
	```php
	return response()->jsonp(
		$request->input('callback'), ['name'=>'Abigail', 'state' =>'CA'] 
		);
	// 或者用withCallback
	return response()
		->json(['name' => 'Abigail', 'state' => 'CA'])
		->withCallback($request->input('callback'));	
	```
-	文件下载响应

	download方法强制浏览器下载文件，三个参数，1要下载的带路径文件名，2可选的文件显示名，3可选的头信息
	管理文件下载的 Symfony HttpFoundation 类要求被下载文件有一个 ASCII 文件名，这意味着被下载文件名不能是中文。

	```php
	return response()->download($pathToFile);
	return response()->download($pathToFile, $name, $headers);
	return response()->download($pathToFile)->deleteFileAfterSend(true);

	// 下载有中文名的文件
	Route::get('download/response', function() {
		return response()->download(storage_path('app/photo/test.jpg'), '测试图片.jpg');
	});	
	```	
-	流式下载响应
	使用 streamDownload 方法，该方法接收一个回调、文件名以及可选的响应头数组作为参数
	```php
	return response()->streamDownload(function () {
		echo GitHub::api('repo')->contents()->readme('laravel', 'laravel')['contents'];
		}, 'laravel-readme.md');
	```

-	文件显示响应，无需下载直接显于在浏览器上，如显示PDF，显示IMAGE
	```php
	return response()->file($pathToFile);
	return response()->file($pathToFile, $headers);
	```

### 响应宏

	如果你想要定义一个自定义的可以在多个路由和控制器中复用的响应，可以使用 Response 门面上的 macro 方法。
	例如，在某个服务提供者的 boot 方法中编写代码如下

	```php
	<?php
	namespace App\Providers;
	use Illuminate\Support\Facades\Response;
	use Illuminate\Support\ServiceProvider;
	class ResponseMacroServiceProvider extends ServiceProvider {
	/**
	* Perform post-registration booting of services.
	* @return void
	*/
		public function boot(){			Response::macro('caps', function ($value) {
			return Response::make(strtoupper($value));
		});
		}	}	
	```	

	macro 方法接收响应名称作为第一个参数，闭包函数作为第二个参数，
	响应宏的闭包在 ResponseFactory 实现类或辅助函数 response 中调用宏名称的时候被执行

	```php
	Route::get('macro/response', function() {
		return response()->caps('HelloWorld'); // 返回 HELLOWORLD
	})	
	```

## 视图

	视图文件存放在 resources/views 目录，子目录下的视图可以用"."逗号引用。
	Illuminate\View\Factory 的 $extensions属性定义了视图的扩展名和其解析引擎，如下
	protected $extensions = ['blade.php' => 'blade', 'php' => 'php'];
	若需自定义模板扩展名，需要在 AppServiceProvider （或者其他适当的服务提供者）里通过调用 View Facade添加，如下
	View::addExtension('phtml', 'php'); 

	```php
	Route::get('/', function () {
		return view('greeting', ['name' => 'YourName']); // resources/views/greeting.php
	});
	return view('admin.profile', $data); // resources/views/admin/profile.blade.php，
	```	