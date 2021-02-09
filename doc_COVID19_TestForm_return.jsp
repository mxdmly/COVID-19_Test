<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.util.regex.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>检测登记表提交</title>
</head>
<body>
    <%!
        //SQL安全防护的正则表达式
        static String CHECKSQL = "\\*|\\.|=|%|or|and|exec|insert|select|delete|update|count|chr|mid|master|truncate|char|declare";
        //SQL保留字
        static String RESERVEDWORD = "'|and|exec|insert|select|delete|update|count|*|%|chr|mid|master|truncate|char|declare|;|or|-|+|,";
    %>
    <%
        //必填
        String nyHosId_str = request.getParameter("myHosId");
        String myName_str = request.getParameter("myName");
        String idType_str = request.getParameter("idType");
        String myPhoneNum_str = request.getParameter("myPhoneNum");
        String idNum_str = request.getParameter("idNum");
        String sex_str = request.getParameter("sex");
        String country_str = request.getParameter("country");//居住地
        String insType_str = request.getParameter("insType");//参保地区
        String insType_3_str = request.getParameter("insType_3");//结算类型
        String peopleSource_str = request.getParameter("peopleSource");//人员来源
        String peopleIdentity_str = request.getParameter("peopleIdentity");//人员身份
        String myEntry_str = request.getParameter("myEntry");//14天内境外入境人员
        String thisDaytime_str = request.getParameter("thisDaytime");//采样时间
        String specimenType_str = request.getParameter("specimenType");//标本类型
        String specimenItem_str = request.getParameter("specimenItem");//检测项目

        //选填信息，不重要的所以跟了个前缀_
        String _age_str = request.getParameter("_age");//年龄
        String _sheng_str = request.getParameter("_sheng");//省区
        String _city_str = request.getParameter("_city");//城市
        String _insType_2_str = request.getParameter("_insType_2");//险种
        String _insLocation_str = request.getParameter("_insLocation");//参保市
        String _samplingOrg_str = request.getParameter("_samplingOrg");//单位名称
        String _samplingIns_str = request.getParameter("_samplingIns");//采样机构
        String _samplingLocation_str = request.getParameter("_samplingLocation");//采样地点

        String targerStr = nyHosId_str + myName_str + idType_str + myPhoneNum_str + 
                    idNum_str + sex_str + country_str + insType_str + 
                    insType_3_str + peopleSource_str + peopleIdentity_str + 
                    myEntry_str + thisDaytime_str + specimenType_str + 
                    specimenItem_str + _age_str + _sheng_str + _city_str + 
                    _insType_2_str + _samplingOrg_str + _samplingIns_str + 
                    _samplingLocation_str;
        boolean sqlCheck_b = false;
        Pattern r = Pattern.compile(CHECKSQL);
		Matcher m = r.matcher(targerStr);
        out.println(m.matches());
        if(sqlCheck_b){
            out.print("发现SQL注入");
        }else{
            out.print("通过");
            try{
                //Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                //Connection connection = DriverManager.getConnection("jdbc:sqlserver://198.8.8.7:1433;DatabaseName=nhis", "sa", "sa123!@#");
            }catch(Exception e){
                e.printStackTrace();
                out.print(e.toString());
            }
        }

    %>
    <%= sqlCheck_b %>
    <%= targerStr %>
</body>
</html>