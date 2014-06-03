
var exec = require("cordova/exec");

var TouchID = function () {
    this.name = "TouchID";
};

TouchID.prototype.authenticate = function (onSuccess, onError, text) {
    if (!text) {
        text = "Please authenticate via TouchID";
    }
    exec(onSuccess, onError, "TouchID", "authenticate", [text]);
};

module.exports = new TouchID();
