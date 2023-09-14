# BlueOS ROS extension

This extension makes possible to communicate with the vehicle via ROS

To connect, you just need to run the following commands:
```sh
export ROS_MASTER_URI=http://blueos.local:11311
# or export ROS_MASTER_URI=http://<vehicle-ip>:11311
rostopic list # Done, you already have access to it!
```

You can also access the data via [roslibjs]([url](http://wiki.ros.org/roslibjs)http://wiki.ros.org/roslibjs).

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />

<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/roslibjs/1.1.0/roslib.min.js"></script>

<script type="text/javascript" type="text/javascript">
  var ros = new ROSLIB.Ros({
    url : 'ws://192.168.0.79:8889'
  });

  ros.on('connection', function() {
    document.getElementById("status").innerHTML = "Connected";
  });

  ros.on('error', function(error) {
    document.getElementById("status").innerHTML = "Error";
  });

  ros.on('close', function() {
    document.getElementById("status").innerHTML = "Closed";
  });

  var txt_listener = new ROSLIB.Topic({
    ros : ros,
    name : '/mavros/vfr_hud',
    messageType : 'mavros_msgs/VFR_HUD'
  });

  txt_listener.subscribe(function(m) {
    document.getElementById("msg").innerHTML = JSON.stringify(m);
  });
</script>
</head>

<body>
  <h1>Simple ROS User Interface</h1>
  <p>Connection status: <span id="status"></span></p>
  <p>Last /mavros/vfr_hud received: <span id="msg"></span></p>
</body>
</html>
```
