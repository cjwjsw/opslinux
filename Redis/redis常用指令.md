## 一、查询redis key的数量
```
info可以看到所有库的key数量

dbsize则是当前库key的数量

keys *这种数据量小还可以，大的时候可以直接搞死生产环境。

dbsize和keys *统计的key数可能是不一样的，如果没记错的话，keys *统计的是当前db有效的key，而dbsize统计的是所有未被销毁的key（有效和未被销毁是不一样的，具体可以了解redis的过期策略）
```
