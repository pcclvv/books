<center><h1> xshell 去除声音 </h1></center>

## 1. 配置文件
&#160; &#160; &#160; &#160;flask中的配置文件是一个flask.config.Config对象（继承字典）,默认配置为：

??? note "默认配置"
```python
{
  'DEBUG':                                get_debug_flag(default=False),  是否开启Debug模式
  'TESTING':                              False,                          是否开启测试模式
  'PROPAGATE_EXCEPTIONS':                 None,                          
  'PRESERVE_CONTEXT_ON_EXCEPTION':        None,
  'SECRET_KEY':                           None,
  'PERMANENT_SESSION_LIFETIME':           timedelta(days=31),
  'USE_X_SENDFILE':                       False,
  'LOGGER_NAME':                          None,
  'LOGGER_HANDLER_POLICY':               'always',
  'SERVER_NAME':                          None,
  'APPLICATION_ROOT':                     None,
  'SESSION_COOKIE_NAME':                  'session',
  'SESSION_COOKIE_DOMAIN':                None,
  'SESSION_COOKIE_PATH':                  None,
  'SESSION_COOKIE_HTTPONLY':              True,
  'SESSION_COOKIE_SECURE':                False,
  'SESSION_REFRESH_EACH_REQUEST':         True,
  'MAX_CONTENT_LENGTH':                   None,
  'SEND_FILE_MAX_AGE_DEFAULT':            timedelta(hours=12),
  'TRAP_BAD_REQUEST_ERRORS':              False,
  'TRAP_HTTP_EXCEPTIONS':                 False,
  'EXPLAIN_TEMPLATE_LOADING':             False,
  'PREFERRED_URL_SCHEME':                 'http',
  'JSON_AS_ASCII':                        True,
  'JSON_SORT_KEYS':                       True,
  'JSONIFY_PRETTYPRINT_REGULAR':          True,
  'JSONIFY_MIMETYPE':                     'application/json',
  'TEMPLATES_AUTO_RELOAD':                None,
}
```

## 2. 配置引进方式
### 2.1 方式1 .

```
app.debug = True
```

### 2.2 方式2 []

```
app.config[debug] = True
```

### 2.3 方式3 文件

```
root@leco:~/code/flask/code# cat settings.py
DEBUG = True
```

app.py
```
app.config.from_pyfile('settings.py', silent=True)
```


### 2.4 方式4 OBJECT 推荐
settings.py
```
class Config(object):
    DEBUG = False
    TESTING = False
    DATABASE_URI = 'sqlite://:memory:'


class ProductionConfig(Config):
    DATABASE_URI = 'mysql://user@localhost/foo'


class DevelopmentConfig(Config):
    DEBUG = True


class TestingConfig(Config):
    TESTING = True
```
app.py

```
app.config.from_object('settings.DevelopmentConfig')
```

[flask配置文件-参考](http://www.pythondoc.com/flask/config.html)
