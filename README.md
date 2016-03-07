# IKNetworking

IKNeworking是一套基于AFNetworking3.0.4封装的网络请求库，其设计思想参考了YTKNetworking,将每一个请求抽象为一个对象，由该对象来管理请求。

该请求库实现基本网络请求需求的同时，增加了缓存机制。可以自定义缓存机制针对请求进行缓存。

# 类说明
**IKRequest**
每一个网络请求需继承该类，通过实例对象进行网络请求。

**IKNetworkManager**
该类主要对IKRequest对象进行管理，每一个网络请求对象都会经过该类，也是该请求库的核心。管理请求的开始，取消以及对调处理。

**IKNetworkConfig**
该类会相对鸡肋一些，主要进行一些全局配置，如服务器地址，缓存数据库名，超时时间等。（IKRequest也可以配置这些参数，会优先取IKRequest返回的参数）

**IKRequestTool** 
工具类，主要封装一些工具方法。







