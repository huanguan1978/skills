### playwright 手记

#### 安装
```shell
# 安装chromium浏览器
playwright install chromium

# 安装浏览器系统依赖
playwright install-deps chromium

# fedora下手机安装install-deps, fedora是没有apt-get,只好手工安装
sudo dnf install libappindicator-gtk3
sudo dnf install liberation-fonts
```

#### 录制脚本
```shell
playwright codegen --target python -o open_mywebsite.py -b firefox http://localhost.localdomain

# 保留身份验证数据 --save-storage保存cookie和localStorage,
playwright codegen --save-storage auth_mywebsite.json --target python -o open_mywebsite.py -b firefox http://localhost.localdomain

# 加载已保留的身份验证数据 --load-storage加载已保存的cookie和localStorage
playwright codegen --load-storage auth_mywebsite.json --target python -o open_mywebsite.py -b firefox http://localhost.localdomain
```

#### 浏览器UI可视化
```python
# 默认浏览器UI为无头模式headless=True,可同时用slow_mo来降低运行速度以便人工观察调试
firefox.launch(headless=False, slow_mo=50)

# 打开开发工具
firefox.launch(devtools=True)

# 更多可视化参数,浏览启动参数通过args设置,如窗口最大化--start-maximized
firefox.launch(headless=False, slow_mo=50, args=['--start-maximized',])

# 更多可视化参数,当前上下文参数,可在browser.new_context时入参,如禁用窗口大小no_viewport=True
context = browser.new_context(no_viewport=True)
```

#### 启用代理
```python
PROXY_HTTP = '127.0.0.1:7890'
# 全局代理,launch的proxy参数
firefox.launch(headless=False, proxy={'server':PROXY_HTTP, 'username':'', 'password':''})

# 上下文单独代理
browser = playwright.firefox.launch(headless=False, proxy={'server':'pre-content' })
content = browser.new_context(proxy={'server':PROXY_HTTP, 'username':'', 'password':''})
page = content.new_page()
page.goto("http://www.google.com")

# 终端命令行启行代理
playwright --proxy=http://127.0.0.1:8080 open google.com
# 终端命令行开启调试模式 ​PWDEBUG=1
bash PWDEBUG=1 playwright --proxy=http://127.0.0.1:8080 open google.com
# 终端命令行开启调试模式 ​PWDEBUG=console,配置浏览器以在开发者工具控制台中进行调试(带头运行,禁用超时,控制台助手)
bash PWDEBUG=console playwright --proxy=http://127.0.0.1:8080 open google.com

# 终端最适合调试方式(调试,代理,设备模拟,地理位置,语言,时区)
export PWDEBUG=console
playwright cr google.com --proxy-server=http://127.0.0.1:8080 --device="iPhone 6 Plus" --lang="en-US" --timezone="Asia/Tokyo" --geolocation="139.691706,35.689487"


```

#### 模拟设备打开
```shell
# iPhone 11.
playwright open --device="iPhone 11" www.baidu.com

# 屏幕大小和颜色主题
playwright open --viewport-size=800,600 --color-scheme=dark www.baidu.com

# 模拟地理位置、语言和时区
playwright open --timezone="Europe/Rome" --geolocation="41.890221,12.492348" --lang="it-IT" maps.google.com
```
```python
# 1.模拟设备, Playwright 带有用于选定移动设备的设备参数注册表，可用于模拟移动设备上的浏览器行为。
from playwright.sync_api import sync_playwright
def run(playwright):
	pixel_2 = playwright.devices['Pixel 2']  # Pixel 2 是谷歌的一款安卓手机
	browser = playwright.chromium.launch(headless=False)
	# 使用设备Pixel 2的参数注册表来构建上下文
	context = browser.new_context(
		**pixel_2,
	)
with sync_playwright() as playwright:
	run(playwright)

# 2.模拟UA
context = browser.new_context(
  user_agent='My user agent'
)

# 3.调整窗口大小
context = browser.new_context(
  viewport={ 'width': 1280, 'height': 1024 }
)

# 4.调整地理时间，颜色主题
context = browser.new_context(
  locale='de-DE',
  timezone_id='Europe/Berlin',
  color_scheme='dark'
)
```

#### 截图
```shell
# playwright screenshot --help  # 查看帮助
# 模拟iPhone截图，等待3秒后截图，保存为twitter-iphone.png?imageView2/1/q/50
playwright screenshot  --device="iPhone 11" --color-scheme=dark --wait-for-timeout=3000 twitter.com twitter-iphone.png

# 全屏截图
playwright screenshot --full-page www.baidu.com baidu-full.png

# 生成PDF
playwright pdf https://en.wikipedia.org/wiki/PDF wiki.pdf
```
```python
# 全屏截图
page.screenshot(path="screenshot.png?imageView2/1/q/50", full_page=True)

# 对元素截图
page.locator(".header").screenshot(path="screenshot.png?imageView2/1/q/50")
```

#### 下载文件
```python
# 开始下载
with page.expect_download() as download_info:
	# 点击下载的按钮
	page.locator("button#delayed-download").click()
download = download_info.value
# 等待下载
print(download.path())
# 保存文件
download.save_as("/path/to/save/download/at.txt")

# 如果不知道会存在什么下载事件，那么就可以添加一个事件监听器
page.on("download", lambda download: print(download.path()))  # 同步
# 异步
async def handle_download(download):
	print(await download.path())
page.on("download", handle_download)
```

#### 运行断点
```python
page.pause()
```

#### 元素定位
1、官方是不推荐 xpath 和 css 的,意思是 css 和 xpath 是绑定于 dom 上的，当 dom 结构出现更改他们将失效。
2、建议用文本定位法, 输入框内的 placeholder，labels 等这些我们可以理解成面向业务的属性这些反而不那么容易改变所以定位应该尽量的去面向业务。
3、文本定位法的特点是, 3.1、模糊匹配; 3.2、不缺分英文的大小写; 3.3、如果存在多个会报错; 以引号 "" 或者 ' 开头的，可以判定为文本定为文本定位

```python
# 文本模糊匹配,没有加引号(单引号或者双引号)，模糊匹配，对大小写不敏感
page.locator("text=社区").click()

# 文本模糊匹配,简写的方式,注意其中的单引号
page.locator("'log in'").click()

# 文本精准匹配,有引号，对大小写敏感
page.locator('text="登录"').click()

# 结合 css 使用，仅匹配 article 元素
page.locator('article:has-text("all products")').click()

# 文本定位相关伪类方法, text(包含), text-is(全等), text-matches(正则匹配),
page.locator("button:text('submit')").click()
page.locator("button:text-is('save')").click()
page.locator("button:text-matches('wellcome *')")

```

#### 官方推荐的内置定位方法
```python
# page.get_by_text(), 通过文本内容定位
# exact=True 精准匹配，文本解决复杂的定位元素层级定位，dom树变化也不影响定位元素
page.get_by_text('登录',exact=True).click()

# page.get_by_label()通过关联标签的文本定位表单控件
page.get_by_label("Password").fill("123456")

# page.get_by_placeholder()按占位符定位输入
page.get_by_placeholder('请输入您的帐户').fill('17601250')
page.get_by_placeholder('请输入您的密码').fill('dasdasda')

# page.get_by_title() 通过标题属性定位元素
# 当您的元素具有该title属性时使用此定位器
page.get_by_title("Issues count")

# page.get_by_role() 通过显式和隐式可访问性属性进行定位
# 角色定位器包括按钮、复选框、标题、链接、列表、表格等，并遵循ARIA 角色、ARIA 属性和 可访问名称的 W3C 规范
page.get_by_role('button', name='登录', exact=True,)

# page.get_by_alt_text()通过替代文本定位元素，通常是图像
page.get_by_alt_text("playwright logo").click()

# page.get_by_test_id()根据data-testid属性定位元素(可以配置其他属性)
# 这是让研发增加定位的选项,QA 和开发人员应该定义明确的测试ID并使用page.get_by_test_id()查询它们
```

#### 常用方法
```python
#获取页面源代码, html就是返回的页面源代码
html = page.content()


```
