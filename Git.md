#### GIT常用命令
- 下载一份远程创库副本
	`git clone *URL*`
- 将当前目录转换成一个新的GIT仓库
	`git init`
- 获取仓库状态报告
	`git status`
- 将所有的新文件或修改过的文件添加至仓库的暂存区
	`git add --all`
- 将所有暂存区文件提交至仓库
	`git commit -m "message"`
- 查看项目历史
	`git log`
- 查压缩过的项目历史
	`git log --oneline`
- 列出所有的本地分支
	`git branch --list`
- 列出所有的远程分支
	`git branch --remotes`
- 列出所有的本地和远程分支
	`git branch --all`
- 创健远程分支的副本，在本地使用
	`git checkout --track remote_name/branch`
- 切换到另一个本地分支
	`git checkout branch`
- 从指定分支创建一个新分支
	`git checkout -b branch branch_parent`
- 仅暂存并准备提交指定文件
	`git add filename(s)`
- 仅暂存并准备提交部份文件
	`git add --patch filename`
- 从暂存区移除提出的文件修改
	`git reset HEAD filename`
- 使用当前暂存的修改更新之前的提交，并提供一个新的提交消息
	`git commit --amend`
- 输入出某个是提交的祥细信息
	`git show commit`
- 为某个提交对像打上标签
	`git tag tag commit`
- 列出所有的标签
	`git tag`
- 输出所有带标签提交的祥细信息
	`git show tag`
- 创健一个指向远程仓库的引用
	`git remote add remote_name URL`
- 将当前分支的修改上传远程仓库
	`git push`
- 列出所 可用远程连接中fetch和push命今使用的URL
	`git remote --verbose`
- 将本地分支的副本推送至远程服务器
	`git push --set-upstream remote_name braanch_local_branch_remote`
- 将当前存储在另一分支的提交并入当前分支
	`git merge branch`

#### 终端全局代理配置
```shell
$ git config --global http.proxy http://127.0.0.1:7890
$ git config --global https.proxy socks5://127.0.0.1:7890
# 若需取消全局配置
# git config --global --unset http.proxy
# git config --global --unset https.proxy
```

#### 终端全局用户名和邮箱配置
```shell
$ git config --global user.name crown.hg
$ git config --global user.email crown.hg@gmail.com
# 若需取消全局配置
# git config --global --unset user.name
# git config --global --unset user.email
```


#### 终端项目代理配置
```INI
# .git/config
[http]
	proxy = socks5://127.0.0.1:7890
[https]
	proxy = socks5://127.0.0.1:7890
```

#### 个人项目GITFLOW实践步骤
1. 在你的issue跟踪系统创建一个新的工单，并注明这个issue的编号
	例：issue-1000015-中国时区差8小时
2. 在你的本地仓库中，issue-number-description格式创健一个新的分支
	例：从远程origin/video-sessons分支上创分建一个名为video-lession的新分支
	`git checkout --track -b *video-lessons* *origin/video-sessons*`
	例：创健一个新的开发分支
	签出你希望作为起点使用的分支
	`git checkout master`
	创健一个新的分支
	`git branch my-branch-name`
	最后签出新分支
	`git checkout my-branch-name`

3. 完成工单描述中的工作（且只完成工单描述中的工作）
4. 测试你的工作，确保已完成且是正确的。且确保它能够通过开发环境下的QA测试
5. 将你的修改添加到本地仓库的暂存库
	例：添加扩展名为.php的所有文件
	`git add *.php`
	例：递归地添加指定路径中的所有文件
	`git add <directory_name>/*`

6. 将你的缓存的修改提交到仓库
	例：提交暂存且加注解
	`git commit -m mycomment`
7. 将你的更改推送到备用服务器上，且在工单系统标记为已解决
	例：使用push命令上传分支
	`git push`
	`git push --set-upstream origin my-branch-name`

8. 当你对你的工作完全满意时，将你的工单分支并入主分支，并将修改后的分支推送到代码托管系统中
	列：将工单分支并入你的主分支
	`git checkout master`
	`git merge my-branch-name`

9. 再一次测试你的工作，确保没有后续问题
10. 将你的工单标记为已关闭且清处无用的分支副本
	例：删除一个无用的本地分支
	`git branch --delete my-branch-name`
	例：删除一个无用的远程分支
	`git push --delete my_gitlab my-branch-name`
