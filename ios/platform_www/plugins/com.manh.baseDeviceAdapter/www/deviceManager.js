cordova.define("com.manh.baseDeviceAdapter.deviceManager", function(require, exports, module) {
var deviceManager = {

    
supportedDeviceList: function(successHandler, errorHandler) {
    /*
    var md = cordova.require("cordova/plugin_list");
    successHandler(JSON.stringify(md));
    */
    
    cordova.exec(
                 function(result) {
                 successHandler(result.devices);
                 },
                 errorHandler,
                 "DeviceAdapterCollection",
                 "deviceInfo",
                 []);
    
},


    
initializeDevice: function(name, arguments, successHandler, errorHandler) {
    
    cordova.exec(
                 function(result) {
                 cordova.exec(
                              function(result) {
                              
                                switch(result){
                                    case "barcode-scanner"  :
                                        barcodeScanner.activeBarcodeScanner    = name;
                                        break;
                                    case "card-reader"      :
                                        cardReader.activeCardReader        = name;
                                        break;
                                    case "printer"          :
                                        printer.activePrinter           = name;
                                        break;
                                    case "cash-drawer"      :
                                        activeCashDrawer        = name;
                                        break;
                                }
                              
                                successHandler("SUCCESS");
                              },
                              errorHandler,
                              name,
                              "deviceType",
                              []);
                 },

                 
                 errorHandler,
                 name,
                 "initializeWithParameters",
                 arguments);
}


};

module.exports = deviceManager;
});
