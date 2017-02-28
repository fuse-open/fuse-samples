var Observable = require('FuseJS/Observable');
var Lifecycle = require('FuseJS/Lifecycle');

var focused = Observable(true);

Lifecycle.on("enteringInteractive", function() {
    focused.value = true;
});

Lifecycle.on("exitedInteractive", function() {
    focused.value = false;
});

Lifecycle.on("enteringForeground", function() {
    console.log("Hello!");
});

Lifecycle.on("enteringBackground", function() {
    console.log("See you later!");
});

module.exports = {
    focused: focused
};
