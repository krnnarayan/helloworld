cordova.define("com.manh.baseDeviceAdapter.cashDrawer", function(require, exports, module) {
var cashDrawer = {

    getLastError: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            "CashDrawerAdapter",
            "getLastError",
            []);
    },

    deviceInfo: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            "CashDrawerAdapter",
            "deviceInfo",
            []);
    },

    deviceStatus: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            "CashDrawerAdapter",
            "deviceStatus",
            []);
    },

    enableDevice: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            "CashDrawerAdapter",
            "enableDevice",
            []);
    },

    disableDevice: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            "CashDrawerAdapter",
            "disableDevice",
            []);
    },

    addNotificationListener: function (listener, successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            "CashDrawerAdapter",
            "addNotificationListener",
            [listener]);
    },

    removeNotificationListener: function (listener, successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            "CashDrawerAdapter",
            "removeNotificationListener",
            [listener]);
    },


    getDrawerStatus: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            "CashDrawerAdapter",
            "getDrawerStatus",
            []);
    },

    getDrawerInfo: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            "CashDrawerAdapter",
            "getDrawerInfo",
            []);
    },


    openDrawer: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            "CashDrawerAdapter",
            "openDrawer",
            []);
    },

    closeDrawer: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            "CashDrawerAdapter",
            "closeDrawer",
            []);
    },

    setDrawerSound: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            "CashDrawerAdapter",
            "setDrawerSound",
            []);
    }
};

module.exports = cashDrawer;
});
