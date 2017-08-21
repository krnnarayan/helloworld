cordova.define("com.manh.baseDeviceAdapter.printer", function(require, exports, module) {
var currentPrinterTask;

var PRNERR_JOB_NOT_STARTED = "Print Job is not started";
var PRNERR_JOB_STARTED     = "Print Job is already started";
var PRNERR_OK              = "SUCCESS";

var PRN_TEXT_ALLIGN_LEFT      =  0;
var PRN_TEXT_ALLIGN_RIGHT     =  1;
var PRN_TEXT_ALLIGN_CENTER    =  2;
var PRN_TEXT_ALLIGN_DEFAULT   = -1;


var PRN_TEXT_STYLE_BOLD           = 1;
var PRN_TEXT_STYLE_ITALIC         = 2;
var PRN_TEXT_STYLE_UNDERSCORE     = 4;
var PRN_TEXT_STYLE_NORMAL         = 0;

var printer = {

    getLastError: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activePrinter,
            "getLastError",
            []);
    },

    deviceInfo: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activePrinter,
            "deviceInfo",
            []);
    },

    deviceStatus: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activePrinter,
            "deviceStatus",
            []);
    },

    enableDevice: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activePrinter,
            "enableDevice",
            []);
    },

    disableDevice: function (successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activePrinter,
            "disableDevice",
            []);
    },

    addNotificationListener: function (listener, successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activePrinter,
            "addNotificationListener",
            [listener]);
    },

    removeNotificationListener: function (listener, successHandler, errorHandler) {

        cordova.exec(
            successHandler,
            errorHandler,
            this.activePrinter,
            "removeNotificationListener",
            [listener]);
    },


    /*
     *
     *          Printer API
     *
     */

    
    startPrintJob: function (successHandler, errorHandler) {
        if(currentPrinterTask != null){
            errorHandler(PRNERR_JOB_STARTED);
        }
        else{
            currentPrinterTask = [];
            successHandler(PRNERR_OK);
        }
    },
    
    
    cancelPrintJob: function (successHandler, errorHandler) {
        if(currentPrinterTask != null){
            errorHandler(PRNERR_JOB_NOT_STARTED);
        }
        else{
            currentPrinterTask = null;
            successHandler(PRNERR_OK);
        }
    },

    
    setTextFont : function(fontValue, successHandler, errorHandler) {
        if(currentPrinterTask != null){
            errorHandler(PRNERR_JOB_NOT_STARTED);
        }
        else{
            
            currentPrinterTask.push([
                                     "FONT",
                                     fontValue
                                     ]);
            
            successHandler(PRNERR_OK);
        }
    },

    setTextSize : function(sizeValue, successHandler, errorHandler) {
        if(currentPrinterTask != null){
            errorHandler(PRNERR_JOB_NOT_STARTED);
        }
        else{
            
            currentPrinterTask.push([
                                     "FONTSIZE",
                                     sizeValue
                                     ]);
            
            successHandler(PRNERR_OK);
        }
    },

    setTextAlign : function(alignValue, successHandler, errorHandler) {
        if(currentPrinterTask != null){
            errorHandler(PRNERR_JOB_NOT_STARTED);
        }
        else{
            
            currentPrinterTask.push([
                                     "ALIGN",
                                     alignValue
                                     ]);
            
            successHandler(PRNERR_OK);
        }
    },
    
    setLineSpacing : function(spacingValue, successHandler, errorHandler) {
        if(currentPrinterTask != null){
            errorHandler(PRNERR_JOB_NOT_STARTED);
        }
        else{
            currentPrinterTask.push([
                                     "LINE_SPACING",
                                     spacingValue
                                     ]);
            
            successHandler(PRNERR_OK);
        }
    },
    

    printText : function(text, successHandler, errorHandler) {
        if(currentPrinterTask != null){
            errorHandler(PRNERR_JOB_NOT_STARTED);
        }
        else{
            currentPrinterTask.push([
                                     "PRINT",
                                     text
                                     ]);
            
            successHandler(PRNERR_OK);
        }
    },

    setTextLanguage : function(language, successHandler, errorHandler) {
        if(currentPrinterTask != null){
            errorHandler(PRNERR_JOB_NOT_STARTED);
        }
        else{
            currentPrinterTask.push([
                                     "LANGUAGE",
                                     language
                                     ]);
            
            successHandler(PRNERR_OK);
        }
    },

    setTextStyle : function(textStyle, successHandler, errorHandler) {
        if(currentPrinterTask != null){
            errorHandler(PRNERR_JOB_NOT_STARTED);
        }
        else{
            currentPrinterTask.push([
                                     "STYLE",
                                     textStyle
                                     ]);
            
            successHandler(PRNERR_OK);
        }
    },

    printLineFeed : function(lines, successHandler, errorHandler) {
        if(currentPrinterTask != null){
            errorHandler(PRNERR_JOB_NOT_STARTED);
        }
        else{
            currentPrinterTask.push([
                                     "LINE_FEED",
                                     lines
                                     ]);
            
            successHandler(PRNERR_OK);
        }
    },
    
    printImage : function(imageName, posX, posY, sizeX, sizeY, successHandler, errorHandler) {
        if(currentPrinterTask != null){
            errorHandler(PRNERR_JOB_NOT_STARTED);
        }
        else{
            currentPrinterTask.push([
                                     "PRINT_IMAGE",
                                     imageName,
                                     posX,
                                     posY,
                                     sizeX,
                                     sizeY
                                     ]);
            
            successHandler(PRNERR_OK);
        }
    },

    printBarcode : function(text, barcode, sizeX, sizeY, successHandler, errorHandler) {
        if(currentPrinterTask != null){
            errorHandler(PRNERR_JOB_NOT_STARTED);
        }
        else{
            currentPrinterTask.push([
                                     "PRINT_BARCODE",
                                     text,
                                     barcode,
                                     sizeX,
                                     sizeY
                                     ]);
            
            successHandler(PRNERR_OK);
        }
    },

    
    startPage : function(successHandler, errorHandler) {
        if(currentPrinterTask != null){
            errorHandler(PRNERR_JOB_NOT_STARTED);
        }
        else{
            currentPrinterTask.push([
                                     "START_PAGE"
                                    ]);
            
            successHandler(PRNERR_OK);
        }
    },

    endPage : function(successHandler, errorHandler) {
        if(currentPrinterTask != null){
            errorHandler(PRNERR_JOB_NOT_STARTED);
        }
        else{
            currentPrinterTask.push([
                                     "END_PAGE"
                                     ]);

            successHandler(PRNERR_OK);
        }
    },

    cutPaper : function(successHandler, errorHandler) {
        if(currentPrinterTask != null){
            errorHandler(PRNERR_JOB_NOT_STARTED);
        }
        else{
            currentPrinterTask.push([
                                     "CUT_PAPER"
                                     ]);
            successHandler(PRNERR_OK);
        }
    },

    clearCommandBuffer : function(successHandler, errorHandler) {
        if(currentPrinterTask != null){
            errorHandler(PRNERR_JOB_NOT_STARTED);
        }
        else{
            currentPrinterTask = [];
            successHandler(PRNERR_OK);
        }
    },

    printerClose : function(successHandler, errorHandler) {
        cordova.exec(
                     successHandler,
                     errorHandler,
                     this.activePrinter,
                     "printerClose",
                     []);
        
    },

    supportedFonts : function(successHandler, errorHandler) {
        cordova.exec(
                     successHandler,
                     errorHandler,
                     this.activePrinter,
                     "supportedFonts",
                     []);
    },

    supportedBarcodes : function(successHandler, errorHandler) {
        cordova.exec(
                     successHandler,
                     errorHandler,
                     this.activePrinter,
                     "supportedBarcodes",
                     []);
    },

    lineWidth : function(successHandler, errorHandler) {
        cordova.exec(
                     successHandler,
                     errorHandler,
                     this.activePrinter,
                     "lineWidth",
                     []);
    },

    finishPrintJob: function (successHandler, errorHandler) {
        if(currentPrinterTask != null){
            errorHandler(PRNERR_JOB_NOT_STARTED);
        }
        else{
            cordova.exec(
                         function(result){
                         curentPrinterTask = null;
                         successHandler(result);
                         },
                         errorHandler,
                         this.activePrinter,
                         "printJob",
                         [currentPrinterTask]);
        }
    }
    
};
printer.activePrinter;
module.exports = printer;
});
