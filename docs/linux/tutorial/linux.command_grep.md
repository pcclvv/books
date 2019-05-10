### 4.1 grep

&emsp;Linux grep命令用于查找文件里符合条件的字符串。`grep`指令用于查找内容包含指定的范本样式的文件，如果发现某文件的内容符合所指定的范本样式，预设grep指令会把含有范本样式的那一列显示出来。若不指定任何文件名称，或是所给予的文件名为"-"，则grep指令会从标准输入设备读取数据。

**语法**

```
grep [-abcEFGhHilLnqrsvVwxy][-A<显示列数>][-B<显示列数>][-C<显示列数>][-d<进行动作>][-e<范本样式>][-f<范本文件>][--help][范本样式][文件或目录...]
```

**参数**：

- **-a 或 --text** : 不要忽略二进制的数据。

- **-A<显示行数> 或 --after-context=<显示行数>** : 除了显示符合范本样式的那一列之外，并显示该行之后的内容。

- **-b 或 --byte-offset** : 在显示符合样式的那一行之前，标示出该行第一个字符的编号。

- **-B<显示行数> 或 --before-context=<显示行数>** : 除了显示符合样式的那一行之外，并显示该行之前的内容。

- **-c 或 --count** : 计算符合样式的列数。

- **-C<显示行数> 或 --context=<显示行数>或-<显示行数>** : 除了显示符合样式的那一行之外，并显示该行之前后的内容。

- **-d <动作> 或 --directories=<动作>** : 当指定要查找的是目录而非文件时，必须使用这项参数，否则grep指令将回报信息并停止动作。

- **-e<范本样式> 或 --regexp=<范本样式>** : 指定字符串做为查找文件内容的样式。

- **-E 或 --extended-regexp** : 将样式为延伸的普通表示法来使用。

- **-f<规则文件> 或 --file=<规则文件>** : 指定规则文件，其内容含有一个或多个规则样式，让grep查找符合规则条件的文件内容，格式为每行一个规则样式。

- **-F 或 --fixed-regexp** : 将样式视为固定字符串的列表。

- **-G 或 --basic-regexp** : 将样式视为普通的表示法来使用。

- **-h 或 --no-filename** : 在显示符合样式的那一行之前，不标示该行所属的文件名称。

- **-H 或 --with-filename** : 在显示符合样式的那一行之前，表示该行所属的文件名称。

- **-i 或 --ignore-case** : 忽略字符大小写的差别。

- **-l 或 --file-with-matches** : 列出文件内容符合指定的样式的文件名称。

- **-L 或 --files-without-match** : 列出文件内容不符合指定的样式的文件名称。

- **-n 或 --line-number** : 在显示符合样式的那一行之前，标示出该行的列数编号。

- **-o 或 --only-matching** : 只显示匹配PATTERN 部分。

- **-q 或 --quiet或--silent** : 不显示任何信息。

- **-r 或 --recursive** : 此参数的效果和指定"-d recurse"参数相同。

- **-s 或 --no-messages** : 不显示错误信息。

- **-v 或 --revert-match** : 显示不包含匹配文本的所有行。

- **-V 或 --version** : 显示版本信息。

- **-w 或 --word-regexp** : 只显示全字符合的列。

- **-x --line-regexp** : 只显示全列符合的列。

- **-y** : 此参数的效果和指定"-i"参数相同。

- 正则

  - ‘^‘： 锚定行首

  - ‘$’： 锚定行尾 

  - ‘.‘： 匹配任一一个字符

  - ‘*’： 匹配零个或多个先前字符 

  - ‘\?‘：匹配其前面的字符0次或者1次；

  - ‘\+’：匹配其前面的字符1次或者多次；

  - ‘\{m\}‘：匹配其前面的字符m次（\为转义字符）

  - ‘\{m,n\}’：匹配其前面的字符至少m次，至多n次

  - ‘[]‘： 匹配一个指定范围内的字符 | ‘[^]’匹配指定范围外的任意单个字符

  - ‘\<‘或‘\b’：锚定词首，‘\>’或‘\b’：锚定词尾（可用\<PATTERN\>：匹配完整单词）

  - ‘\(\)’：将多个字符当做一个整体进行处理

  - 后向引用：引用前面的分组括号中的模式所匹配到的字符分组括号中的模式匹配到的内容或被正则表达式引擎自动记录于内部的变量中：**

    　　**\1：模式从左侧起，第一个左括号及与之匹配的右括号之间模式匹配到的内容**

    　　**\2：模式从左侧起，第二个左括号及与之匹配的右括号之间模式匹配到的内容...**

    　　扩展正则表达式与正则表达式略有不同：

    　　'[]'：依旧匹配指定范围内的任意单个字符；但是有很多特殊匹配方式。

    　　　　[:digit:] 匹配任意单个数字

    　　　　[:lower:] 匹配任意单个小写字母               

    　　　　[:upper:] 匹配任意单个大写字母

    　　　　[:alpha:] 匹配任意单个字母

    　　　　[:alnum:] 匹配任意单个字母或数字

    　　　　[:punct:] 匹配任意单个符号

    　　　　[:space:] 匹配单个空格

    　　一些地方取消了转义字符的使用：

    　　‘?‘：匹配其前面的字符0次或者1次；

    　　‘+’：匹配其前面的字符1次或者多次；

    　　‘{m}‘：匹配其前面的字符m次（\为转义字符）

    　　‘{m,n}’：匹配其前面的字符至少m次，至多n次

    　　()：将一个或多个字符捆绑在一起，当做一个整体进行处理，反向引用照常使用。

    　　‘|’：或（**注**：‘C|cat’为C与cat，‘（C|c）at才是Cat与cat’）

> **注**：使用grep匹配时需使用双引号引起来（单引号为强引用），防止被系统误认为参数或者特殊命令而报错。



> 基本的正则表达式元字符 ?、+、 {、 |、 ( 和 ) 已经失去了它们原来的意义，要使用的话用反斜线的版本 /?、/+、/{、/|、/( 和 /) 来代替。 传统的 egrep 并不支持 { 元字符，一些 egrep 的实现是以 /{ 替代的，所以一个可移植的脚本应该避免在 grep -E 使用 { 符号，要匹配字面的 { 应该使用 [}]。

```
过滤
root@leco:/tmp/cmz# cat cmz.txt 
my name is caimengzhi
MY NAME IS CAIMENGZHI
my age is 32
MY AGE IS 32
my hobby is python
MY HOBBY IS PYTHON
root@leco:/tmp/cmz# grep name cmz.txt 
my name is caimengzhi

-i 不区分大小写
root@leco:/tmp/cmz# grep -i name cmz.txt 
my name is caimengzhi
MY NAME IS CAIMENGZHI
```

```
-你显示行号[过滤出信息]
root@leco:/tmp/cmz# grep -n 'name' cmz.txt 
1:my name is caimengzhi
root@leco:/tmp/cmz# grep -ni 'name' cmz.txt 
1:my name is caimengzhi
2:MY NAME IS CAIMENGZHI
root@leco:/tmp/cmz# grep -nE 'name|NAME' cmz.txt 
1:my name is caimengzhi
2:MY NAME IS CAIMENGZHI
```

```
-v 排除不需要的行
root@leco:/tmp/cmz# cat cmz.txt 
my name is caimengzhi
my age is 32
my hobby is Python
root@leco:/tmp/cmz# grep -v 'age' cmz.txt 
my name is caimengzhi
my hobby is Python

root@leco:/tmp/cmz# grep -Ev 'age|name' cmz.txt 
my hobby is Python
```

> 需要多个的话，需要使用-E，多个条件使用|链接

```
-c 显示匹配到的数据的行数
root@leco:/tmp/cmz# grep caimengzhi cmz.txt 
my name is caimengzhi
root@leco:/tmp/cmz# grep -i caimengzhi cmz.txt 
my name is caimengzhi
MY NAME IS CAIMENGZHI
root@leco:/tmp/cmz# grep -c caimengzhi cmz.txt 
1
root@leco:/tmp/cmz# grep -ci caimengzhi cmz.txt 
2
```

```
root@leco:/tmp/cmz# grep caimengzhi cmz.txt 
my name is caimengzhi
root@leco:/tmp/cmz# grep -o caimengzhi cmz.txt 
caimengzhi
root@leco:/tmp/cmz# grep -no caimengzhi cmz.txt 
1:caimengzhi
```

> 只输出匹配的内容

```
-w 精确匹配
root@leco:/tmp/cmz# cat cmz.txt 
my name is caimengzhi
my na is caimengzhi
MY NAME IS CAIMENGZHI
my age is 32
MY AGE IS 32
my hobby is python
MY HOBBY IS PYTHON
root@leco:/tmp/cmz# grep na cmz.txt 
my name is caimengzhi
my na is caimengzhi
root@leco:/tmp/cmz# grep -w na cmz.txt 
my na is caimengzhi
```

> -w 是精确匹配，没有-w是模糊匹配。

```
root@leco:/tmp/cmz# cat cmz.conf 

# 这个是注释
my name is caimegzhi

root@leco:/tmp/cmz# cat -n cmz.conf 
     1	
     2	# 这个是注释
     3	my name is caimegzhi
     4	
root@leco:/tmp/cmz# grep -v '#' cmz.conf  # 去掉带有#的行

my name is caimegzhi

root@leco:/tmp/cmz# grep -v '^$' cmz.conf # 去掉空行
# 这个是注释
my name is caimegzhi
root@leco:/tmp/cmz# grep -vE '^$|#' cmz.conf  # 去掉带有#号和空行
my name is caimegzhi
```

```
-r 递归查询
root@leco:/tmp/cmz# ls
cmz
root@leco:/tmp/cmz# tree .
.
└── cmz
    ├── cmz.conf
    └── cmz.txt

1 directory, 2 files
root@leco:/tmp/cmz# grep -r name *
cmz/cmz.conf:my name is caimegzhi
cmz/cmz.txt:my name is caimengzhi

root@leco:/tmp/cmz# grep -rn name *  # -n 显示所在文件的行号
cmz/cmz.conf:3:my name is caimegzhi
cmz/cmz.txt:1:my name is caimengzhi
```

> 在目录下查询所有的文件中包括name的字段的文件，因为目录下又有很多目录和文件，使用-r 递归查询

```
root@leco:/tmp/cmz/cmz# cat cmz.txt
my name is caimengzhi
my age is 32
my hobby is python
root@leco:/tmp/cmz/cmz# grep -A1 age cmz.txt 
my age is 32
my hobby is python
root@leco:/tmp/cmz/cmz# grep -B1 age cmz.txt 
my name is caimengzhi
my age is 32
root@leco:/tmp/cmz/cmz# grep -C1 age cmz.txt 
my name is caimengzhi
my age is 32
my hobby is python
```

> -A 就是after,匹配到数据，后面几行
>
> -B就是before,匹配到数据，前面几行
>
> -C就是匹配到数据，前后几行

---

正则表达式

1. 正则表达式就是为了处理大量的文本|字符串而定义的一套规则和方法
2. 通过定义的这些特殊符号的辅助，系统管理员就可以快速过滤，替换或输出需要的字符串。Linux正则表达式一般以行为单位处理

|             |             |
| ----------- | ----------- |
| 基础正则BRE | 扩展正则ERE |
| \?          | ?           |
| \+          | +           |
| \{\}        | {}          |
| \( \ )      | ()          |
| \           |             |

> 所谓基础正则实际上就是得需要转义字符配合表达的正则，而扩展正则就是让命令扩展它的权限让他直接就认识正则表达符号（egrep，sed -r，awk直接支持）

| 正则表达式 | 描述                                          | 示例            |
| ---------- | --------------------------------------------- | --------------- |
| [:alnum:]  | [a-zA-Z0-9]匹配任意一个字母或数字字符         | [[:alnum:]]+    |
| [:alpha:]  | 匹配任意一个字母字符（包括大小写字母）        | [[:alpha:]]{4}  |
| [:blank:]  | 空格与制表符（横向纵向）                      | [[:blank:]]*    |
| [:digit:]  | 匹配任意一个数字字符                          | [[:digit:]]?    |
| [:lower:]  | 匹配小写字母                                  | [[:lower:]]{5,} |
| [:upper:]  | 匹配大写字母                                  | ([[:upper:]]+)? |
| [:punct:]  | 匹配标点符号                                  | [[:punct:]]     |
| [:space:]  | 匹配一个包括换行符，回车等在内的所有空白符    | [[:space:]]+    |
| [:graph:]  | 匹配任何一个可以看得见的且可以打印的字符      | [[:graph:]]     |
| [:xdigit:] | 任何一个十六进制数                            | [[:xdigit:]]+   |
| [:cntrl:]  | 任何一个控制字符（ASCII字符集中的前32个字符） | [[:cntrl:]]     |
| [:print:]  | 任何一个可以打印的字符                        | [[:print:]]     |

> 元字符是一种Perl风格的正则表达式，只有一部分文本处理工具支持它，并不是所有的文本处理工具都支持

| 正则表达式 | 描述                         | 示例                            |
| ---------- | ---------------------------- | ------------------------------- |
| \b         | 单词边界                     | \bcool\b匹配cool，不匹配coolant |
| \B         | 非单词边界                   | cool\B匹配coolant不匹配cool     |
| \d         | 单个数字字符                 | b\db匹配b2b，不匹配bcb          |
| \D         | 单个非数字字符               | b\Db匹配bcb不匹配b2b            |
| \w         | 单个单词字符（字母，数字与_) | \w匹配1或a，不匹配&             |
| \W         | 单个非单词字符               | \W匹配&，不匹配1或a             |
| \n         | 换行符                       | \n匹配一个新行                  |
| \s         | 单个空白字符                 | x\sx匹配xx，不匹配xx            |
| \S         | 单个非空白字符               | x\S\x匹配xkx，不匹配xx          |
| \r         | 回车                         | \r匹配回车                      |
| \t         | 横向制表符                   | \t匹配一个横向制表符            |
| \v         | 垂直制表符                   | \v匹配一个垂直制表符            |
| \f         | 换页符                       | \f匹配一个换页符                |

```
-[] 匹配括号内任何一个字符
root@leco:/tmp/cmz/cmz# cat cmz.txt 
1 my name is caimengzhi
my age is 32
ac my hobby is python
root@leco:/tmp/cmz/cmz# grep "[ag]" cmz.txt 
1 my name is caimengzhi
my age is 32
ac my hobby is python

root@leco:/tmp/cmz/cmz# grep "[0-9]" cmz.txt 
1 my name is caimengzhi
my age is 32
```

> [ag]匹配的是包含a或者g的行,[0-9]匹配0到9

```
^ 以什么开头的行
root@leco:/tmp/cmz/cmz# grep "^my" cmz.txt 
my age is 32

root@leco:/tmp/cmz/cmz# grep "^[^m]" cmz.txt 
1 my name is caimengzhi.
ac my hobby is python
```

> ^匹配以my开头的行,两次就表示取反

```
root@leco:/tmp/cmz/cmz# cat cmz.txt 
1 my name is caimengzhi.
my age is 32.
ac my hobby is python
root@leco:/tmp/cmz/cmz# grep 'n$' cmz.txt 
ac my hobby is python
root@leco:/tmp/cmz/cmz# grep '.$' cmz.txt 
1 my name is caimengzhi.
my age is 32.
ac my hobby is python
root@leco:/tmp/cmz/cmz# grep '\.$' cmz.txt 
1 my name is caimengzhi.
my age is 32.
```

> $ 配置以什么什么结尾，但是碰见特殊字符需要转意。

```
正则.和*
. (小数点)：代表『一定有一个任意字节』的意思；
* (星号)：代表『重复前一个字符， 0 到无穷多次』的意思，为组合形态
+ (加号): 代表前面重复的字符1次或者多次
? (问号): 代表前面重复的字符0次或者1次

root@leco:/tmp/cmz/cmz# cat cmz.txt 
1 my name is caimengzhi.
my age is 32.
my agge is 32.
my aggge is 32.
ac my hobby is python
root@leco:/tmp/cmz/cmz# grep 'a.e' cmz.txt 
1 my name is caimengzhi.
my age is 32.
root@leco:/tmp/cmz/cmz# grep 'a..e' cmz.txt 
1 my name is caimengzhi.
my agge is 32.
root@leco:/tmp/cmz/cmz# grep 'a...e' cmz.txt 
my aggge is 32.
root@leco:/tmp/cmz/cmz# grep 'a*e' cmz.txt 
1 my name is caimengzhi.
my age is 32.
my agge is 32.
my aggge is 32.
root@leco:/tmp/cmz/cmz# egrep '(gg)+' cmz.txt 
my agge is 32.
my aggge is 32.
root@leco:/tmp/cmz/cmz# grep '\(gg\)\+' cmz.txt 
my agge is 32.
my aggge is 32.

root@leco:/tmp/cmz/cmz# egrep '(g)?' cmz.txt 
1 my name is caimengzhi.
my age is 32.
my agge is 32.
my aggge is 32.
ac my hobby is python
AB C
hellocaimengzhi

```

> a.e 表示a和e之间只有一个任意字符
>
> a..e 表示a和e之间只有两个任意字符
>
> a...e 表示a和e之间只有三个任意字符
>
> a*e表示a和e之间有0到无穷多个任意字符。贪婪匹配

```
{}使用
c{n}  # 匹配c字符n次以上包括n次
c{n,} # 等价c{n}
c{n,m}# 匹配c字符n次到m次，包括n和m
root@leco:/tmp/cmz/cmz# cat leco.txt 
cmz
ccmz
cccmz
ccccmz
leco
icpc
root@leco:/tmp/cmz/cmz# grep 'c\{1\}' leco.txt 
cmz
ccmz
cccmz
ccccmz
leco
icpc
root@leco:/tmp/cmz/cmz# grep 'c\{1,\}' leco.txt 
cmz
ccmz
cccmz
ccccmz
leco
icpc
root@leco:/tmp/cmz/cmz# grep 'c\{2,\}' leco.txt 
ccmz
cccmz
ccccmz
root@leco:/tmp/cmz/cmz# grep 'c\{3,\}' leco.txt 
cccmz
ccccmz
root@leco:/tmp/cmz/cmz# grep 'c\{4,\}' leco.txt 
ccccmz
root@leco:/tmp/cmz/cmz# grep 'c\{5,\}' leco.txt 
root@leco:/tmp/cmz/cmz# grep 'c\{2,3\}' leco.txt 
ccmz
cccmz
ccccmz
```

> 如是不是用\转移使用egrep 替换grep或者grep -E

```
root@leco:/tmp/cmz/cmz# egrep 'c{1}' leco.txt 
cmz
ccmz
cccmz
ccccmz
leco
icpc
root@leco:/tmp/cmz/cmz# egrep 'c{2}' leco.txt 
ccmz
cccmz
ccccmz
root@leco:/tmp/cmz/cmz# egrep 'c{3}' leco.txt 
cccmz
ccccmz
root@leco:/tmp/cmz/cmz# egrep 'c{4}' leco.txt 
ccccmz
root@leco:/tmp/cmz/cmz# egrep 'c{5}' leco.txt 
root@leco:/tmp/cmz/cmz# egrep 'c{2,3}' leco.txt 
ccmz
cccmz
ccccmz
```



```
[]扩展正则
root@leco:/tmp/cmz/cmz# cat cmz.txt 
1 my name is caimengzhi.
my age is 32.
my agge is 32.
my aggge is 32.
ac my hobby is python
AB C
hellocaimengzhi

[:digit:] 匹配任意单个数字
root@leco:/tmp/cmz/cmz# grep '[[:digit:]]' cmz.txt 
1 my name is caimengzhi.
my age is 32.
my agge is 32.
my aggge is 32.
期中数字会高亮

[:lower:] 匹配任意单个小写字母               
root@leco:/tmp/cmz/cmz# grep '[[:lower:]]' cmz.txt 
1 my name is caimengzhi.
my age is 32.
my agge is 32.
my aggge is 32.
ac my hobby is python
hellocaimengzhi
期中小写字母会高亮

[:upper:] 匹配任意单个大写字母
root@leco:/tmp/cmz/cmz# grep '[[:upper:]]' cmz.txt 
AB C
期中大写字母会高亮

[:alpha:] 匹配任意单个字母
root@leco:/tmp/cmz/cmz# grep '[[:alpha:]]' cmz.txt 
1 my name is caimengzhi.
my age is 32.
my agge is 32.
my aggge is 32.
ac my hobby is python
AB C
hellocaimengzhi
期中所有字母会高亮

[:alnum:] 匹配任意单个字母或数字
root@leco:/tmp/cmz/cmz# grep '[[:alnum:]]' cmz.txt 
1 my name is caimengzhi.
my age is 32.
my agge is 32.
my aggge is 32.
ac my hobby is python
AB C
hellocaimengzhi
期中数字或者字母会高亮

[:punct:] 匹配任意单个符号
root@leco:/tmp/cmz/cmz# grep '[[:punct:]]' cmz.txt 
1 my name is caimengzhi.
my age is 32.
my agge is 32.
my aggge is 32.
期中符号会高亮也就是本文中的最后的英文点

[:space:] 匹配单个空格
root@leco:/tmp/cmz/cmz# grep '[[:space:]]' cmz.txt 
1 my name is caimengzhi.
my age is 32.
my agge is 32.
my aggge is 32.
ac my hobby is python
AB C
期中空格会高亮显示
```

单例

```
grep -c "88" cmz.txt 统计所有以“88”字符开头的行有多少
grep -i "May" cmz.txt 不区分大小写查找“May”所有的行）
grep -n "88" cmz.txt 显示行号；显示匹配字符“88”的行及行号，相同于 nl cmz.txt |grep 88）
grep -v "88" cmz.txt 显示输出没有字符“88”所有的行）
grep "471" cmz.txt 显示输出字符“471”所在的行）
grep "88;" cmz.txt 显示输出以字符“88”开头，并在字符“88”后是一个tab键所在的行
grep "88[34]" cmz.txt 显示输出以字符“88”开头，第三个字符是“3”或是“4”的所有的行）
grep "^[^88]" cmz.txt 显示输出行首不是字符“88”的行）
grep "[Mm]ay" cmz.txt 设置大小写查找：显示输出第一个字符以“M”或“m”开头，以字符“ay”结束的行）
grep "K…D" cmz.txt 显示输出第一个字符是“K”，第二、三、四是任意字符，第五个字符是“D”所在的行）
grep "[A-Z][9]D" cmz.txt 显示输出第一个字符的范围是“A-D”，第二个字符是“9”，第三个字符的是“D”的所有的行
grep "[35]..1998" cmz.txt 显示第一个字符是3或5，第二三个字符是任意，以1998结尾的所有行
grep "4\{2,\}" cmz.txt 模式出现几率查找：显示输出字符“4”至少重复出现两次的所有行
grep "9\{3,\}" cmz.txt 模式出现几率查找：显示输出字符“9”至少重复出现三次的所有行
grep "9\{2,3\}" cmz.txt 模式出现几率查找：显示输出字符“9”重复出现的次数在一定范围内，重复出现2次或3次所有行
grep -n "^$" cmz.txt 显示输出空行的行号
ls -l |grep "^d" 如果要查询目录列表中的目录 同：ls -d *
ls -l |grep "^d[d]" 在一个目录中查询不包含目录的所有文件
ls -l |grpe "^d…..x..x" 查询其他用户和用户组成员有可执行权限的目录集合
```

