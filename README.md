## Touch ID Plugin for Apache Cordova

Cordova Plugin to leverage the iOS local authentication framework to allow in-app user authentication using Touch ID.

## 1 step install

```
cordova plugin add https://github.com/leecrossley/cordova-plugin-touchid.git
```

## Usage

You **do not** need to reference any JavaScript, the Cordova plugin architecture will add a touchid object to your root automatically when you build.

Ensure you use the plugin after your deviceready event has been fired.

### Authenticate

Pass the following arguments to the `authenticate()` function, to prompt the user to authenticate via TouchID:

1. Success callback (called on successful authentication)
2. Failure callback (called on error or if authentication fails)
3. Localised text explaining why the app needs authentication*

```
window.touchid.authenticate(successCallback, failureCallback, text);
```

*NOTE: The localised text you present to the user should provide a clear reason for why you are requesting they authenticate themselves, and what action you will be taking based on that authentication.

## Platforms

iOS >= 8

## License

[MIT License](http://ilee.mit-license.org)
