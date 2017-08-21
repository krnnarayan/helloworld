cordova.define("com.manh.baseDeviceAdapter.barcodeScanner", function(require, exports, module) {
var barcodeScanner = {
    
    getLastError: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeBarcodeScanner,
            "getLastError",
            []);
    },

    deviceInfo: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeBarcodeScanner,
            "deviceInfo",
            []);
    },

    deviceStatus: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeBarcodeScanner,
            "deviceStatus",
            []);
    },

    enableDevice: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeBarcodeScanner,
            "enableDevice",
            []);
    },

    disableDevice: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeBarcodeScanner,
            "disableDevice",
            []);
    },

    addNotificationListener: function (listener, successHandler, errorHandler) {
        cordova.exec(
            successHandler,
            errorHandler,
            this.activeBarcodeScanner,
            "addNotificationListener",
            [listener]);
    },

    removeNotificationListener: function (listener, successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeBarcodeScanner,
            "removeNotificationListener",
            [listener]);
    },


    getSupportedBarcodes: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeBarcodeScanner,
            "getSupportedBarcodes",
            []);
    },


    enableBarcode: function (barcodeId, successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeBarcodeScanner,
            "enableBarcode",
            [barcodeId]);
    },

    disableBarcode: function (barcodeId, successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeBarcodeScanner,
            "disableBarcode",
            [barcodeId]);
    },

    startRead: function (successHandler, errorHandler) {
        cordova.exec(
            successHandler,
            errorHandler,
            this.activeBarcodeScanner,
            "startRead",
            []);
    },


    stopRead: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activeBarcodeScanner,
            "stopRead",
            []);
    }

};
barcodeScanner.activeBarcodeScanner;
module.exports = barcodeScanner;
});
