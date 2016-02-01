var Camera = require('FuseJS/Camera');
var Observable = require('FuseJS/Observable');

var image = Observable();
function takePicture() {
    Camera.takePicture({targetWidth: 1080, targetHeight: 1920}).then(function(file){
	image.value = file;
    });
}

module.exports = {
    takePicture: takePicture,
    image: image
};
