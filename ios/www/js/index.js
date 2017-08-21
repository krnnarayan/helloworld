/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        //deviceManager.initializeDevice("BarcodeScannerAdapter", [], onSuccess,onFailure);
        app.receivedEvent('deviceready');
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    }
};
var onSuccess = function() {
    alert('success')
    console.log('Success');
    
}

var onFailure = function() {
    alert('fail')
    console.log('Failure');
    
}
function initVerifoneDevice(){
    var xhr = new XMLHttpRequest();
    
    xhr.open( "GET", "http://localhost:3000/api/getStaticData", true );
    
    var self = this;
    var params =  ""
    xhr.onload = function( e ) {
        //alert( this.response)
        window.plugins.PrintPDF.print({
                                      data: this.response,
                                      type: 'Data',
                                      title: 'Print Document',
                                      success: function(){
                                      console.log('success');
                                      },
                                      error: function(data){
                                      data = JSON.parse(data);
                                      console.log('failed: ' + data.error);
                                      }
                                      });
        //window.open("data:application/pdf;base64," + this.response);
        };
    
    xhr.send(JSON.stringify(params))
}


function startScan(){
    alert('Start Scan');
    barcodeScanner.addNotificationListener("callbackForData",callbackForData,onFailure);
    barcodeScanner.startRead(onSuccess, onFailure);
    
}


function stopScan(){
    alert('Stop Scan');
    barcodeScanner.stopRead(function(){},function(){});
}


function callbackForData(data){
    alert("callback: " + JSON.stringify(data));
    stopScan();
    
}


function onSuccess(data){
    alert(JSON.stringify(data));
}


function onFailure(){
    alert('failure');
}

function enableScan(){
    alert('Enable');
}


function simulateScan(){
    var  currentTask = [];
    
    currentTask.push(["START_PAGE", [1,2,3,4,5] ]);
    currentTask.push(["END_PAGE"]);
    currentTask.push(["PRINT", "text to print"]);
    currentTask.push(["LINEFEED",  5]);
    
    alert(JSON.stringify(currentTask));
    
    
    cordova.exec(
                 onSuccess,
                 onFailure,
                 activePrinter,
                 "printJob",
                 currentTask);
    
}
document.getElementById('initDevice').addEventListener('click', initVerifoneDevice);
document.getElementById('startScan').addEventListener('click', startScan);
document.getElementById('stopScan').addEventListener('click', stopScan);
document.getElementById('enableScan').addEventListener('click', enableScan);
document.getElementById('simulateScan').addEventListener('click', simulateScan);

app.initialize();