# IX-RXVF

# 项目已死（2020-11.10~2022.8.30）以后不再更新

# Heroku将于2022.11.28停止免费计划。想要继续白嫖的请发挥自己的想象力，加油！！！

# 最后，不要对曾经提过了free计划的heroku突然终止free计划心存怨恨！任何一个提供免费计划的平台背后承担着很大压力的。（cpu/网络带宽/租用服务器/电/场地/......的成本）。</br>因为白嫖的压根不会去想也不想关心这类破事！！！</br>人是会变的。更何况公司呢？</br>如果有不爽的，直接点击右上角关闭完事。</br>本项目拒接任何issue！

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
