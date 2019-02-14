
### 1. 克隆项目

```
root@leco:/tmp/leco# git clone git@github.com:caimengzhi/books.git
正克隆到 'books'...
remote: Enumerating objects: 1879, done.
remote: Counting objects: 100% (1879/1879), done.
remote: Compressing objects: 100% (237/237), done.
remote: Total 6365 (delta 835), reused 1800 (delta 782), pack-reused 4486
接收对象中: 100% (6365/6365), 5.58 MiB | 24.00 KiB/s, 完成.
处理 delta 中: 100% (2938/2938), 完成.
检查连接... 完成。
root@leco:/tmp/leco# cd books/
root@leco:/tmp/leco/books# ls
docs  mkdocs.yml  README.md  site
root@leco:/tmp/leco/books# cd ..
root@leco:/tmp/leco# tree . -L 3
.
└── books
    ├── docs
    │   ├── appendix
    │   ├── contact.md
    │   ├── frontend
    │   ├── img
    │   ├── index.md
    │   ├── install
    │   ├── js
    │   ├── linux
    │   ├── pictures
    │   ├── python
    │   ├── recommend.md
    │   └── syntax
    ├── mkdocs.yml
    ├── README.md
    └── site
        ├── 404.html
        ├── appendix
        ├── assets
        ├── contact
        ├── frontend
        ├── img
        ├── index.html
        ├── install
        ├── js
        ├── linux
        ├── pictures
        ├── python
        ├── recommend
        ├── search
        ├── sitemap.xml
        ├── sitemap.xml.gz
        └── syntax

25 directories, 9 files

```
> 解释

- 1 整体说明
```
root@leco:/tmp/leco/books# tree . -L 1
.
├── docs         # 笔记总入口
├── mkdocs.yml   # 总配置文件
├── README.md    
└── site         # 静态文件，以后部署到类似nginx

2 directories, 2 files

```
- 2 细节说明
```
root@leco:/tmp/leco# tree . -L 3
.
└── books
    ├── docs
    │   ├── appendix     # 忽视先别改
    │   ├── contact.md   # 忽视先别改
    │   ├── frontend     # 忽视先别改
    │   ├── img          # 忽视先别改
    │   ├── index.md     # 忽视先别改
    │   ├── install      # 忽视先别改
    │   ├── js           # 忽视先别改
    │   ├── linux        # 新创建的写Linux相关笔记总入口
    │   ├── pictures     # 记录所有笔记的文档入口
    │   ├── python       # 类型上面linux，
    │   ├── recommend.md # 忽视先别改
    │   └── syntax       # 忽视先别改
    ├── mkdocs.yml       # 总配置文件，写目录结构文件
    ├── README.md   
    └── site             # 执行静态文件
        ├── 404.html
        ├── appendix
        ├── assets
        ├── contact
        ├── frontend
        ├── img
        ├── index.html
        ├── install
        ├── js
        ├── linux
        ├── pictures
        ├── python
        ├── recommend
        ├── search
        ├── sitemap.xml
        ├── sitemap.xml.gz
        └── syntax

25 directories, 9 files
```
??? note "生成静态文件"
	```text
	mkdocs build
	```
