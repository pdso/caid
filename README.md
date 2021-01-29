# caid

## 说明

苹果实施新的`idfa`政策之后，广告商们用到的归因方法。  
收集用户设备的一些信息用特定的算法来生成唯一标识。  
不同厂商计算`caid`方式可能不一样，这里提供可能会用到的设备信息，服务端收到用户的这些信息后自行计算。


| 参数 | 值 | 说明 |
| :-----| ----: | ----: |
| boot | 1611888252 | 系统启动时间 |
| carrier | SIMULATOR | 运营商Code |
| country | US | 国家 |
| disk | 499963170816 | 手机可用空间 | 
| hwmodel | D10AP | hwmodel |
| language | zh-Hans-US | 语言 |
| model | iPhone10,3 | model |
| ram | 34359738368 | 内存大小 | 
| timezone | 28800 | 时区 | 
| uname | xx的iPhone13 | 手机名称 |
| update | 1611888252 | 系统更新时间 |
| version | 10.3 | 系统版本 |


 ## 使用方法 

```
#import <caid/FkCaid.h>
NSLog(@"%@", [FkCaid totoal]);
```

## Installation

caid is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'caid', '~> 1.0.0'
```

## Author

pdso, pd@99d.in

## License

caid is available under the MIT license. See the LICENSE file for more info.
