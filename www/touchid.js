
var exec = require("cordova/exec");

var TouchID = function () {
    this.name = "TouchID";
};

TouchID.prototype.authenticate = function (successCallback, errorCallback, text, passcodeFallback) {
    if (!text) {
        text = "Please authenticate via TouchID to proceed";
    }
    exec(successCallback, errorCallback, "TouchID", "authenticate", [text, passcodeFallback]);
};

TouchID.prototype.checkSupport = function (successCallback, errorCallback, passcodeFallback) {
    exec(successCallback, errorCallback, "TouchID", "checkSupport", [passcodeFallback]);
};

module.exports = new TouchID();
