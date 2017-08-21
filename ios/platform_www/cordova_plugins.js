cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "id": "com.manh.baseDeviceAdapter.deviceManager",
        "file": "plugins/com.manh.baseDeviceAdapter/www/deviceManager.js",
        "pluginId": "com.manh.baseDeviceAdapter",
        "clobbers": [
            "deviceManager"
        ]
    },
    {
        "id": "com.manh.baseDeviceAdapter.printer",
        "file": "plugins/com.manh.baseDeviceAdapter/www/printer.js",
        "pluginId": "com.manh.baseDeviceAdapter",
        "clobbers": [
            "printer"
        ]
    },
    {
        "id": "com.manh.baseDeviceAdapter.cashDrawer",
        "file": "plugins/com.manh.baseDeviceAdapter/www/cashDrawer.js",
        "pluginId": "com.manh.baseDeviceAdapter",
        "clobbers": [
            "cashDrawer"
        ]
    },
    {
        "id": "com.manh.baseDeviceAdapter.cardReader",
        "file": "plugins/com.manh.baseDeviceAdapter/www/cardReader.js",
        "pluginId": "com.manh.baseDeviceAdapter",
        "clobbers": [
            "cardReader"
        ]
    },
    {
        "id": "com.manh.baseDeviceAdapter.barcodeScanner",
        "file": "plugins/com.manh.baseDeviceAdapter/www/barcodeScanner.js",
        "pluginId": "com.manh.baseDeviceAdapter",
        "clobbers": [
            "barcodeScanner"
        ]
    },
    {
        "id": "com.manh.baseDeviceAdapter.printer",
        "file": "plugins/com.manh.baseDeviceAdapter/www/printer.js",
        "pluginId": "com.manh.baseDeviceAdapter",
        "clobbers": [
            "printer"
        ]
    },
    {
        "id": "cordova-plugin-printer.Printer",
        "file": "plugins/cordova-plugin-printer/www/printer.js",
        "pluginId": "cordova-plugin-printer",
        "clobbers": [
            "plugin.printer",
            "cordova.plugins.printer"
        ]
    },
    {
        "id": "cordova-plugin-device.device",
        "file": "plugins/cordova-plugin-device/www/device.js",
        "pluginId": "cordova-plugin-device",
        "clobbers": [
            "device"
        ]
    },
    {
        "id": "cordova-plugin-file.DirectoryEntry",
        "file": "plugins/cordova-plugin-file/www/DirectoryEntry.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.DirectoryEntry"
        ]
    },
    {
        "id": "cordova-plugin-file.DirectoryReader",
        "file": "plugins/cordova-plugin-file/www/DirectoryReader.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.DirectoryReader"
        ]
    },
    {
        "id": "cordova-plugin-file.Entry",
        "file": "plugins/cordova-plugin-file/www/Entry.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.Entry"
        ]
    },
    {
        "id": "cordova-plugin-file.File",
        "file": "plugins/cordova-plugin-file/www/File.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.File"
        ]
    },
    {
        "id": "cordova-plugin-file.FileEntry",
        "file": "plugins/cordova-plugin-file/www/FileEntry.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.FileEntry"
        ]
    },
    {
        "id": "cordova-plugin-file.FileError",
        "file": "plugins/cordova-plugin-file/www/FileError.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.FileError"
        ]
    },
    {
        "id": "cordova-plugin-file.FileReader",
        "file": "plugins/cordova-plugin-file/www/FileReader.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.FileReader"
        ]
    },
    {
        "id": "cordova-plugin-file.FileSystem",
        "file": "plugins/cordova-plugin-file/www/FileSystem.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.FileSystem"
        ]
    },
    {
        "id": "cordova-plugin-file.FileUploadOptions",
        "file": "plugins/cordova-plugin-file/www/FileUploadOptions.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.FileUploadOptions"
        ]
    },
    {
        "id": "cordova-plugin-file.FileUploadResult",
        "file": "plugins/cordova-plugin-file/www/FileUploadResult.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.FileUploadResult"
        ]
    },
    {
        "id": "cordova-plugin-file.FileWriter",
        "file": "plugins/cordova-plugin-file/www/FileWriter.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.FileWriter"
        ]
    },
    {
        "id": "cordova-plugin-file.Flags",
        "file": "plugins/cordova-plugin-file/www/Flags.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.Flags"
        ]
    },
    {
        "id": "cordova-plugin-file.LocalFileSystem",
        "file": "plugins/cordova-plugin-file/www/LocalFileSystem.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.LocalFileSystem"
        ],
        "merges": [
            "window"
        ]
    },
    {
        "id": "cordova-plugin-file.Metadata",
        "file": "plugins/cordova-plugin-file/www/Metadata.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.Metadata"
        ]
    },
    {
        "id": "cordova-plugin-file.ProgressEvent",
        "file": "plugins/cordova-plugin-file/www/ProgressEvent.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.ProgressEvent"
        ]
    },
    {
        "id": "cordova-plugin-file.fileSystems",
        "file": "plugins/cordova-plugin-file/www/fileSystems.js",
        "pluginId": "cordova-plugin-file"
    },
    {
        "id": "cordova-plugin-file.requestFileSystem",
        "file": "plugins/cordova-plugin-file/www/requestFileSystem.js",
        "pluginId": "cordova-plugin-file",
        "clobbers": [
            "window.requestFileSystem"
        ]
    },
    {
        "id": "cordova-plugin-file.resolveLocalFileSystemURI",
        "file": "plugins/cordova-plugin-file/www/resolveLocalFileSystemURI.js",
        "pluginId": "cordova-plugin-file",
        "merges": [
            "window"
        ]
    },
    {
        "id": "cordova-plugin-file.isChrome",
        "file": "plugins/cordova-plugin-file/www/browser/isChrome.js",
        "pluginId": "cordova-plugin-file",
        "runs": true
    },
    {
        "id": "cordova-plugin-file.iosFileSystem",
        "file": "plugins/cordova-plugin-file/www/ios/FileSystem.js",
        "pluginId": "cordova-plugin-file",
        "merges": [
            "FileSystem"
        ]
    },
    {
        "id": "cordova-plugin-file.fileSystems-roots",
        "file": "plugins/cordova-plugin-file/www/fileSystems-roots.js",
        "pluginId": "cordova-plugin-file",
        "runs": true
    },
    {
        "id": "cordova-plugin-file.fileSystemPaths",
        "file": "plugins/cordova-plugin-file/www/fileSystemPaths.js",
        "pluginId": "cordova-plugin-file",
        "merges": [
            "cordova"
        ],
        "runs": true
    },
    {
        "id": "cordova-plugin-print-pdf.PrintPDF",
        "file": "plugins/cordova-plugin-print-pdf/www/PrintPDF.js",
        "pluginId": "cordova-plugin-print-pdf",
        "clobbers": [
            "window.PrintPDF"
        ]
    },
    {
        "id": "cl.kunder.webview.webview",
        "file": "plugins/cl.kunder.webview/www/webViewPlugin.js",
        "pluginId": "cl.kunder.webview",
        "merges": [
            "webview"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "com.manh.baseDeviceAdapter": "0.0.2",
    "com.manh.epsonPrinter": "0.0.1",
    "com.manh.verifoneBarcode": "0.0.1",
    "com.manh.verifoneCardReader": "0.0.1",
    "cordova-plugin-whitelist": "1.3.0",
    "cordova-plugin-printer": "0.7.2",
    "cordova-plugin-device": "1.1.4-dev",
    "cordova-plugin-ios-base64": "1.0.0",
    "cordova-plugin-compat": "1.1.0",
    "cordova-plugin-file": "4.3.1-dev",
    "cordova-plugin-print-pdf": "4.0.2",
    "cl.kunder.webview": "2.3.0"
};
// BOTTOM OF METADATA
});