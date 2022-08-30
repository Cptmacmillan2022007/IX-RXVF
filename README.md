# IX-RXVF

# 项目已死（2020-11.10~2022.8.30）以后不再更新

# Heroku将于2022.11.28停止免费计划。想要继续白嫖的请发挥自己的想象力，加油！！！

# 最后，愿上帝保佑用爱发电的个人/组织，同时也保佑白嫖的用户。</br>愿我们能在没有墙的春天再次相遇，愿在墙外的人能够得到属于自己的幸福与快乐。

# 愿你被这个世界温柔以待，即使生命总以刻薄荒芜相欺

# 面朝大海，春暖花开
```
从明天起
喂马，劈柴，周游世界

从明天起
关心粮食和蔬菜
我有一所房子
面朝大海，春暖花开

从明天起，和每一个亲人通信
告诉他们我的幸福
那幸福闪电的告诉我的
我将告诉每一个人

给每一条河，每一座山谷
取一个温暖的名字

陌生人
我也为你祝福
愿你有一个灿烂的前程
愿你有情人终成眷属
愿你在尘世获得幸福

我只愿
面朝大海，春暖花开
```

# 反代代码（从以下3个示例中选择其中1个部署<n/a>）

示例1：(适用单一应用的反代代码)
```
addEventListener(
  "fetch", event => {
    let url = new URL(event.request.url);
    url.host = "appname.herokuapp.com";
    let request = new Request(url, event.request);
    event.respondWith(
      fetch(request)
    )
  }
)
```

示例2：(适用单双日循环执行的反代代码)
```
const SingleDay = 'appname.herokuapp.com'
const DoubleDay = 'appname.herokuapp.com'
addEventListener(
    "fetch",event => {
    
        let nd = new Date();
        if (nd.getDate()%2) {
            host = SingleDay
        } else {
            host = DoubleDay
        }
        
        let url=new URL(event.request.url);
        url.hostname="appname.herokuapp.com";
        let request=new Request(url,event.request);
        event. respondWith(
            fetch(request)
        )
    }
)
```

示例3：(适用多实例循环执行的反代代码)
```
const Day0 = 'app0.herokuapp.com'
const Day1 = 'app1.herokuapp.com'
const Day2 = 'app2.herokuapp.com'
const Day3 = 'app3.herokuapp.com'
const Day4 = 'app4.herokuapp.com'
addEventListener(
    "fetch",event => {
    
        let nd = new Date();
        let day = nd.getDate() % 5;
        if (day === 0) {
            host = Day0
        } else if (day === 1) {
            host = Day1
        } else if (day === 2) {
            host = Day2
        } else if (day === 3){
            host = Day3
        } else if (day === 4){
            host = Day4
        } else {
            host = Day0
        }
        
        let url=new URL(event.request.url);
        url.hostname=host;
        let request=new Request(url,event.request);
        event. respondWith(
            fetch(request)
        )
    }
)
```
