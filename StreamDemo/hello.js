var express = require('express');
var app = express();

app.get('/', function (req, res) {
   res.send('Hello World');

console.log(req.path);
})

var server = app.listen(8081, function () {

  var host = server.address().address
  var port = server.address().port

  console.log("应用实例，访问地址为 http://%s:%s", host, port)

})


// var http = require('http');
// var url = require('url');
// var util = require('util');

// http.createServer(function(req, res){
//     res.writeHead(200, {'Content-Type': 'text/plain'});
//     res.end(util.inspect(url.parse(req.url, true)));
// }).listen(3000);


// process.on('exit', function(code) {

//   // 以下代码永远不会执行
//   setTimeout(function() {
//     console.log("该代码不会执行");
//   }, 100);
  
//   console.log('退出码为:', code);
// });
// console.log("程序执行结束");

// function route(pathname) {
//   console.log("About to route a request for " + pathname);
// }

// exports.route = route;





// var http = require("http");
// var url = require("url");

// function start(route) {
//   function onRequest(request, response) {
//     var pathname = url.parse(request.url).pathname;
//     console.log("Request for " + pathname + " received.");

//     route(pathname);

//     response.writeHead(200, {"Content-Type": "text/plain"});
//     response.write("Hello World");
//     response.end();
//   }

//   http.createServer(onRequest).listen(8888);
//   console.log("Server has started.");
// }

// exports.start = start;

// console.warn( __filename );


// start(route);
// // 引入 events 模块
// var events = require('events');
// // 创建 eventEmitter 对象
// var eventEmitter = new events.EventEmitter();

// // 创建事件处理程序
// var connectHandler = function connected() {
//    console.log('连接成功。');
  
//    // 触发 data_received 事件 
//    eventEmitter.emit('data_received');
// }

// // 绑定 connection 事件处理程序
// eventEmitter.on('connection', connectHandler);
 
// // 使用匿名函数绑定 data_received 事件
// eventEmitter.on('data_received', function(){
//    console.log('数据接收成功。');
// });

// // 触发 connection 事件 
// eventEmitter.emit('connection');

// console.log("程序执行完毕。");