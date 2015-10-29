# node.care Agent
The node.care Agent which should be required by every node process you want to monitor.

## Install
```sh
> npm install node-care-agent --save
```

## Usage
```js
var nca = require('node-care-agent');

var server = http.createServer();

nca({
  appKey: '<YOUR_APP_KEY>',
  appSecret: '<YOUR_APP_SECRET>',
  listenTo: server,
  options: {
    interval: 1000
  }
});

server.listen(3000);
```