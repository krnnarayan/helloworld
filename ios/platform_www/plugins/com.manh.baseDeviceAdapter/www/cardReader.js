cordova.define("com.manh.baseDeviceAdapter.cardReader", function(require, exports, module) {
var cardReader = {

    getLastError: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeCardReader,
            "getLastError",
            []);
    },

    deviceInfo: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeCardReader,
            "deviceInfo",
            []);
    },

    deviceStatus: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeCardReader,
            "deviceStatus",
            []);
    },

    enableDevice: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeCardReader,
            "enableDevice",
            []);
    },

    disableDevice: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeCardReader,
            "disableDevice",
            []);
    },

    addNotificationListener: function (listener, successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeCardReader,
            "addNotificationListener",
            [listener]);
    },

    removeNotificationListener: function (listener, successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeCardReader,
            "removeNotificationListener",
            [listener]);
    },

    hasPinpad: function (listener, successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeCardReader,
            "hasPinpad",
            [listener]);
    },

    enablePinpad: function (listener, successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeCardReader,
            "enablePinpad",
            [listener]);
    },

    disablePinpad: function (listener, successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeCardReader,
            "disablePinpad",
            [listener]);
    },

    requestPinEntry: function (listener, successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeCardReader,
            "requestPinEntry",
            [listener]);
    },

    requestCardEntry: function (listener, successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeCardReader,
            "requestCardEntry",
            [listener]);
    },

    requestTextEntry: function (listener, successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeCardReader,
            "requestTextEntry",
            [listener]);
    },

    cancelOperation: function (listener, successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeCardReader,
            "cancelOperation",
            [listener]);
    }

};
 cardReader.activeCardReader;
module.exports = cardReader;
});
