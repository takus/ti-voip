// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.

var voip_module = require('me.takus.ti.voip');

var window = Ti.UI.createWindow({
	backgroundColor:'white'
});

var voip = voip_module.create();

var button1 = Titanium.UI.createButton({
    title: 'start',
    top: 100,
    height: 20,
    width: 120
});
button1.addEventListener('click', function(e) { 
    Titanium.API.info("You clicked the start button");
    voip.start("192.168.0.4", 12345, 54321);
});
window.add(button1);

var button2 = Titanium.UI.createButton({
    title: 'stop',
    top: 150,
    height: 20,
    width: 120
});
button2.addEventListener('click', function(e) { 
    Titanium.API.info("You clicked the stop button");
    voip.stop();
});
window.add(button2);

window.open();
