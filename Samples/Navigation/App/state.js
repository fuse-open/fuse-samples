var Observable = require("FuseJS/Observable")

exports.loading = Observable(false)

exports.setLoading = function(on) {
	exports.loading.value = on
}

//start in logged in state to allow route restoration to work in Preview. A typical
//app would then check during startup if not logged in and goto the login page
exports.login = Observable(true)
exports.loginUser = Observable( { name: "fawlty" } )

exports.setLogin = function(user) {
	exports.login.value = true
	exports.loginUser = user
}
exports.logout = function() {
	exports.login.value = false
	exports.loginUser = null
}