//自定义的工具类js，方便自己调用各种常见的数据，且jq没有提供更好的方法。

//获取当前时间 格式yyyy-MM-dd hh:mm:ss
function myTool_getThisTime() {
    var myDateTime = new Date();
    var myMonth = myDateTime.getMonth() + 1;
    let tempSec = myDateTime.getSeconds()
    if(tempSec < 10){
        tempSec = "0" + tempSec;
    }
    let thisTime_str = myDateTime.getFullYear() + "/" + 
    myMonth + "/" + 
    myDateTime.getDate() + " " + 
    myDateTime.getHours() + ":" + 
    myDateTime.getMinutes() + ":" + 
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