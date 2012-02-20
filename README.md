# Voice over IP Module for Titanium Mobile


## Documents

Sorry, no module documentation is available right now.
Please see 'examples/app.js'.


## Example

### app.js

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
        voip.start("192.168.1.26", 12345);
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


## License

2012 Takumi SAKAMOTO <takumi.saka@gmail.com> All rights reserved.

License: Apache License 2.0
