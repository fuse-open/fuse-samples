var Observable = require('FuseJS/Observable');
var Lifecycle = require('FuseJS/Lifecycle');

var focused = Observable(true);

Lifecycle.onEnteringInteractive = function(){
    focused.value = true;
};

Lifecycle.onExitedInteractive = function(){
    focused.value = false;
};

Lifecycle.onTerminating  = function() {
    console.log("Goodbye!");
};

Lifecycle.onEnteringForeground = function() {
    console.log("Hello!");
};

Lifecycle.onEnteringBackground = function() {
    console.log("See you later!");
};

module.exports = {
    focused: focused
};
