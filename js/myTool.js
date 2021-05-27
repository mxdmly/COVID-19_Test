//自定义的工具类js，方便自己调用各种常见的数据，且jq没有提供更好的方法。

//解决IE8兼容问题
window.console = window.console || (function () {
    var c = {}; c.log = c.warn = c.debug = c.info = c.error = c.time = c.dir = c.profile
        = c.clear = c.exception = c.trace = c.assert = function () { };
    return c;
})();
//获取当前时间 格式yyyy-MM-dd hh:mm:ss
function myTool_getThisTime() {
    var myDateTime = new Date();
    var myMonth = myDateTime.getMonth() + 1;
    var tempHou = myDateTime.getHours();
    var tempMinu = myDateTime.getMinutes();
    var tempSec = myDateTime.getSeconds();
    if(tempHou < 10){
        tempHou = "0" + tempHou;
    }
    if(tempMinu < 10){
        tempMinu = "0" + tempMinu;
    }
    if(tempSec < 10){
        tempSec = "0" + tempSec;
    }
    var thisTime_str = myDateTime.getFullYear() + "/" + 
    myMonth + "/" + 
    myDateTime.getDate() + " " + 
    tempHou + ":" + 
    tempMinu + ":" + 
    tempSec;
    return thisTime_str;
}
//格式化时间

function myTool_forTime(d) {
    var myDateTime = new Date(d);
    alert(myDateTime);
    var myMonth = myDateTime.getMonth() + 1;
    var tempMinu = myDateTime.getMinutes().toString();//如果时分秒少于2位数需要在前面补零
    var tempSec = myDateTime.getSeconds().toString();
    if(tempSec.length < 2){
        tempSec = "0" + tempSec;
    }
    if(tempMinu.length < 2){
        tempMinu = "0" + tempMinu;
    }
    var thisTime_str = myDateTime.getFullYear() + "/" + 
    myMonth + "/" + 
    myDateTime.getDate() + " " + 
    myDateTime.getHours() + ":" + 
    tempMinu + ":" + 
    tempSec;
    return thisTime_str;
}

//截取字符串
function L() {	
    var str = String(result);
    var start_i = str.indexOf("<table>");
    var stop_i = str.lastIndexOf("</table>");
    str = str.slice(start_i + 7,stop_i);
}