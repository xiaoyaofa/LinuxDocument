## 例程
https://github.com/OP-TEE/optee_client

## 介绍
TEE API分两种
一类是CA与TA通信的API，实现方式就是应用程序调用libteec.so库，libteec.so库是由optee_client编译出的。
一类是TA系统调用TEE OS的API，这是的实现方式其实就是系统调用，参考globalplatform中的GPD_TEE_Internal_Core_API_Specification_v1.1.pdf。
```
https://globalplatform.org/wp-content/uploads/2018/06/GPD_TEE_Internal_Core_API_Specification_v1.1.2_CC.pdf
```
## TA
头文件
```
#include <tee_internal_api.h>
#include <tee_internal_api_extensions.h>
```
### TA接口函数
**TA_CreateEntryPoint**
函数是可信应用程序的构造函数，框架在创建可信应用程序的新实例时调用该构造函数
```
TEE_Result TA_CreateEntryPoint(void)
{
    return TEE_SUCCESS;
}
```
**TA_DestroyEntryPoint**
受信任应用程序的析构函数，框架在销毁实例时调用它
```
void TA_DestroyEntryPoint(void)
{
}
```
**TA_OpenSessionEntryPoint**
当客户端请求与受信任的应用程序打开会话时，框架调用函数TA_OpenSessionEntryPoint，打开会话请求可能
导致创建一个新的可信应用程序实例。
客户端可以在打开操作中指定参数，这些参数通过参数**paramTypes**和**params**传递给可信应用程序实例。
可信应用程序实例还可以使用这些参数将响应数据传输回客户机
```
TEE_Result TA_OpenSessionEntryPoint(uint32_t paramTypes,
					      TEE_Param params[4],
					      void **sessionContext);
{
	return TEE_SUCCESS;
}
```
参数
```
paramTypes: 四个参数的类型
params: 指向包含四个形参的数组的指针
sessionContext: 变量的指针，该变量可以由可信应用程序实例用不透明的void*数据指针填充
```
返回值
```
TEE_SUCCESS: 会话打开成功
其他值：无法打开会话 
(返回码可以是预定义的代码之一，也可以是可信应用程序实现本身定义的新返回码。在任何情况下，实现必须将返回代码报告给客户端，初始值为TEEC_ORIGIN_TRUSTED_APP)
```
**TA_CloseSessionEntryPoint**
框架调用函数TA_CloseSessionEntryPoint来关闭客户端会话
可信应用程序实现负责释放会话使用的任何资源
```
void TA_CloseSessionEntryPoint(void *sessionContext);
{
}
```
参数
```
sessionContext: 受信任应用程序在TA_OpenSessionEntryPoint函数中为该会话设置的void*opaque数据指针的值
```

**TA_InvokeCommandEntryPoint**
TA_InvokeCommandEntryPoint
受信任的应用程序可以通过paramTypes和params参数访问客户端发送的参数。它还可以使用这些参数
将响应数据传输回客户端
```
TEE_Result TA_InvokeCommandEntryPoint(void *sessionContext, uint32_t commandID,
			   uint32_t paramTypes,
			   TEE_Param params[4]);
```
参数
```
sessionContext: 受信任应用程序在TA_OpenSessionEntryPoint函数中为该会话设置的void*opaque数据指针的值
commandID: 调用的命令的特定于受信任应用程序的代码
paramTypes: 四个参数的类型
params: 指向包含四个形参的数组的指针
```
返回值
```
TEE_SUCCESS: 会话打开成功
其他值：无法打开会话 
(返回码可以是预定义的代码之一，也可以是可信应用程序实现本身定义的新返回码。在任何情况下，实现必须将返回代码报告给客户端，初始值为TEEC_ORIGIN_TRUSTED_APP)
```

### 持久对象函数API
TEE_OpenPersistentObject
开现有持久对象的句柄。它返回一个句柄，可用于访问对象的属性和数据流
```

```