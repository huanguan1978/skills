#### Wget手记

## wget中文手册地址
https://xy2401.com/local-docs/gnu/manual.zh/wget.html

## https://www.sudops.com/wget-recursive-download-blocked-by-robots-txt.html
## https://repo.maven.apache.org/maven2/

#### wget常用参数
' -m ' ' --mirror '
	打开适合镜像的选项。此选项打开递归和时间戳记，设置无限递归深度，并保留FTP目录列表。目前相当于“ -r -N -l inf --no-remove-listing '。
' -K ' ' --backup-converted '
	转换文件时，请使用“ .orig后缀。影响“ -N '

' -k ' ' --convert-links '
	下载完成后，请转换文档中的链接以使其适合本地查看。这不仅会影响可见的超链接，还会影响文档中链接到外部内容的任何部分，例如嵌入式图像，样式表的链接，非HTML内容的超链接等。
	因此，本地浏览可靠地工作：如果下载了链接文件，则链接将引用其本地名称；如果未下载，则该链接将引用其完整的Internet地址，而不是显示断开的链接。将以前的链接转换为相对链接的事实可确保您可以将下载的层次结构移至另一个目录。
	请注意，只有在下载结束时Wget才能知道已下载了哪些链接。因此，“ -k '将在所有下载结束时执行。

' -E ' ' --adjust-extension '
如果文件类型为“ application/xhtml+xml ' 要么 ' text/html '已下载，且URL不以regexp结尾' \.[Hh][Tt][Mm][Ll]? '，此选项将导致后缀' .html '附加到本地文件名。例如，当您镜像使用“ .asp '页面，但您希望在库存的Apache服务器上可以查看镜像的页面。另一个很好的用法是下载CGI生成的资料时。像“ http://site.com/article.cgi?25 '将另存为article.cgi?25.html 。
请注意，以这种方式更改的文件名将在您每次重新镜像站点时重新下载，因为Wget不能告诉您本地X.html文件对应于远程URL' X '（因为尚不知道URL产生的输出类型为' text/html ' 要么 ' application/xhtml+xml '。
从1.12版开始，Wget还将确保所有下载的文件类型为“ text/css '以后缀结尾' .css '，并且该选项已从' --html-extension ”，以更好地体现其新行为。旧的选项名称仍然可以接受，但现在应视为已弃用。
从1.19.2版开始，Wget还将确保所有下载的文件都带有Content-Encoding的br '，' compress '，' deflate ' 要么 ' gzip '以后缀结尾' .br '，' .Z '，' .zlib '和' .gz ' 分别。
在将来的某个时候，此选项可能会扩展为包括其他类型的内容的后缀，包括Wget未解析的内容类型。

' -p ' ' --page-requisites '
此选项使Wget下载正确显示给定HTML页面所需的所有文件。这包括内联图像，声音和引用的样式表。
通常，当下载单个HTML页面时，可能不会正确显示它可能需要的任何必需文档。使用“ -r ' 和...一起 ' -l可以提供帮助，但是由于Wget通常不区分外部文档和内联文档，因此通常会留下缺少其必要条件的“叶子文档”。

' -np ' ' --no-parent '
	递归检索时，切勿升至父目录。这是一个有用的选项，因为它保证只有在一定的层次结构下面的文件将被下载。有关更多详细信息，请参见基于目录的限制 。

#### wget整站镜像
```shell
# https://repo.huaweicloud.com/repository/maven/
wget -c -r -k -p -np -l8 -e robots=off --connect-timeout=180 -t 0 -A jar -P D:\JarDownloads https://repo.huaweicloud.com/repository/maven/

# 要过滤特定的文件扩展名
wget -A pdf,jpg -m -p -E -k -K -np http://site/path/

# 镜像整个站,包含所有href连接资源
wget -m -p -E -k -K -np -i maven2link.txt

# 镜像整个站, 仅限此站域名
# -m some  -r -N -l inf --no-remove-listing
wget -m -nc
```
#### wget指定启动文件,通过选择--config=~/download/abc/abc.wgetrc指定,通过选择-no-config禁用启动文件

#### wget使用代理,在~/.wgetrc文件中加如下设置
```ini
http_proxy = http://127.0.0.1:7890
https_proxy = http://127.0.0.1:7891
# ftp_proxy = http://127.0.0.1:7890
use_proxy = on
```
#### wget使用自定义HttpHeader信息了,在~/.wgetrc文件中加入如下设置
```ini
# https://www.gnu.org/software/wget/manual/html_node/Wgetrc-Commands.html
robots = off

header = Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
header = Accept-Encoding: gzip, deflate, br
header = Accept-Language: en-US,en;q=0.5
header = Connection: keep-alive
header = Host: f-droid.org
header = Referer: https://f-droid.org/
header = User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.79 Safari/537.36 Edge/14.14393
```
