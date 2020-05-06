var Observable = require("FuseJS/Observable");
var ImageTools = require("FuseJS/ImageTools");
var VideoTools = require("FuseJS/VideoTools");
var CameraRoll = require("FuseJS/CameraRoll");

var image = Observable("");
var flashIsOn = Observable(false);
var currentMedia = Observable("Photo");

var imageObject = {};

function capture() {
	if (currentMedia.value == "Video") {
		if (cameraPanel.IsCurrentlyRecording.value == "Recording") {
			stopVideoCapture();
		} else {
			startVideoCapture();
		}
	} else {
		takePicture();
	}
}

function takePicture() {
	cameraPanel.takePicture({callback: function(err, img) {
		if (img !== null) {
			imageObject = img;
			image.value = img.path;
		}
	}});
}

function startVideoCapture() {
	cameraPanel.startVideo();
}

function stopVideoCapture() {
	cameraPanel.endVideo(function(err, path) {
		if (err) {
			return;
		}
		VideoTools.copyVideoToCameraRoll(path);
	});
}

function discardPicture() {
	image.value = "";
	flashIsOn.value = false;
}

function savePicture() {
	CameraRoll.publishImage(imageObject);
	discardPicture();
}

function swapCamera() {
	cameraPanel.swapCamera();
}

function toggleFlash() {
	flashIsOn.value = ! flashIsOn.value;
	if (flashIsOn.value) {
		cameraPanel.enableFlash();
	} else {
		cameraPanel.disableFlash();
	}
}

function toggleMediaPhoto() {
	currentMedia.value = "Photo";
}

function toggleMediaVideo() {
	currentMedia.value = "Video";
}

module.exports = {
	image: image,

	capture: capture,
	discardPicture: discardPicture,
	savePicture: savePicture,

	swapCamera: swapCamera,
	cameraDirection: cameraPanel.CurrentCameraDirection.map(function(x) {
		return x.substr(0,1);
	}),

	toggleFlash: toggleFlash,
	flashIsOn: flashIsOn,

	currentMedia: currentMedia,
	toggleMediaPhoto: toggleMediaPhoto,
	toggleMediaVideo: toggleMediaVideo,

	videoIsRecording: cameraPanel.IsCurrentlyRecording.map(function(x) {
		if (x == "Recording") {
			return true;
		} else {
			return false;
		}
	})
};
