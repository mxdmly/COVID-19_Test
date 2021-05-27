<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.util.regex.*,java.util.regex.Matcher,java.util.regex.Pattern" %>

    <%!
        //SQL安全防护的正则表达式
        String CHECKSQL = "\\*|\\.|;|=|%|or|and|if|end|go|exec|insert|select|delete|update|count|chr|mid|master|truncate|char|declare";
        String sqlNonNullFormat(String str){ //sql非空判断以及格式化
            if(str == "" | str == null){
                str = "null,";
            }else{
                str = "'" + str + "',";
            }
            return str;
        }
    %>
    <%
        //必填
        String myHospitalIdCard_str = request.getParameter("myHospitalIdCard");
        String myName_str = request.getParameter("myName");
        String idType_str = request.getParameter("idType");
        String myPhoneNum_str = request.getParameter("myPhoneNum");
        String idNum_str = request.getParameter("idNum");
        String sex_str = request.getParameter("sex");
        String countryAndRegion_str = request.getParameter("countryAndRegion");//居住地
        String insuranceSheng_str = request.getParameter("insuranceSheng");//参保地区
        String settlementType_str = request.getParameter("settlementType");//结算类型
        String peopleSource_str = request.getParameter("peopleSource");//人员来源
        String peopleIdentity_str = request.getParameter("peopleIdentity");//人员身份
        String immigrationWithinFTDays_str = request.getParameter("immigrationWithinFTDays");//14天内境外入境人员
        String samplingTime_str = request.getParameter("samplingTime");//采样时间
        String specimenType_str = request.getParameter("specimenType");//标本类型
        String testItems_str = request.getParameter("testItems");//检测项目

        //选填信息，不重要的所以跟了个前缀_
        String _age_str = request.getParameter("_age");//年龄
        String _sheng_str = request.getParameter("_sheng");//省区
        String _city_str = request.getParameter("_city");//城市
        String _insuranceType_str = request.getParameter("_insuranceType");//险种
        String _insuranceCity_str = request.getParameter("_insuranceCity");//参保市
        String _unit_str = request.getParameter("_unit");//单位名称
        String _SamplingAgency_str = request.getParameter("_SamplingAgency");//采样机构
        String _samplingLocation_str = request.getParameter("_samplingLocation");//采样地点

        String targerStr = myHospitalIdCard_str + myName_str + idType_str + myPhoneNum_str + 
                    idNum_str + sex_str + countryAndRegion_str + insuranceSheng_str + 
                    settlementType_str + peopleSource_str + peopleIdentity_str + 
                    immigrationWithinFTDays_str + samplingTime_str + specimenType_str + 
                    testItems_str + _age_str + _sheng_str + _city_str + 
                    _insuranceType_str + _insuranceCity_str + _unit_str + 
                    _SamplingAgency_str + _samplingLocation_str;

        boolean sqlCheck_b = true;
        Pattern r = Pattern.compile(CHECKSQL);
		Matcher m = r.matcher(targerStr);
        sqlCheck_b = m.find();//使用find函数才能对任意字符串匹配
        int result_i = -10;//sql返回值
        String sql_str = "";//sql插入语句

        if(sqlCheck_b){
            out.print("发现SQL注入");
        }else{
            //out.print("通过");
            sql_str = "INSERT INTO _COVID19test(myHospitalIdCard,name,idType,phoneNum," + 
                "idNum,sex,countryAndRegion,insuranceSheng,settlementType,peopleSource," + 
                "peopleIdentity,immigrationWithinFTDays,samplingTime,specimenType,testItems," + 
                "age,sheng,city,insuranceType,insuranceCity,unit,SamplingAgency," + 
                "samplingLocation) VALUES(" + 
                sqlNonNullFormat(myHospitalIdCard_str) + sqlNonNullFormat(myName_str) + 
                sqlNonNullFormat(idType_str) + sqlNonNullFormat(myPhoneNum_str) + 
                sqlNonNullFormat(idNum_str) + sqlNonNullFormat(sex_str) + 
                sqlNonNullFormat(countryAndRegion_str) + sqlNonNullFormat(insuranceSheng_str) + 
                sqlNonNullFormat(settlementType_str) + sqlNonNullFormat(peopleSource_str) + 
                sqlNonNullFormat(peopleIdentity_str) + sqlNonNullFormat(immigrationWithinFTDays_str) + 
                sqlNonNullFormat(samplingTime_str) + sqlNonNullFormat(specimenType_str) + 
                sqlNonNullFormat(testItems_str) + sqlNonNullFormat(_age_str) + 
                sqlNonNullFormat(_sheng_str) + sqlNonNullFormat(_city_str) + 
                sqlNonNullFormat(_insuranceType_str) + sqlNonNullFormat(_insuranceCity_str) + 
                sqlNonNullFormat(_unit_str) + sqlNonNullFormat(_SamplingAgency_str) + 
                sqlNonNullFormat(_samplingLocation_str);
            sql_str = sql_str.substring(0, sql_str.length() -1) + ")";//减去最后的逗号
            //做重复性检查
            String returnedData_str = "";//数据库返回的数据
            String checkDataRepeat_str = ""; //需要插入的数据
            samplingTime_str = samplingTime_str.replaceAll("0","");//粗暴的解决月份和日期有0的问题，下同
                checkDataRepeat_str = 
                myHospitalIdCard_str + myName_str + 
                idType_str + myPhoneNum_str + 
                idNum_str + sex_str + 
                countryAndRegion_str + insuranceSheng_str + 
                settlementType_str + peopleSource_str + 
                peopleIdentity_str + immigrationWithinFTDays_str + 
                samplingTime_str + specimenType_str + 
                testItems_str + _age_str;
            try{
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                Connection connection = DriverManager.getConnection("jdbc:sqlserver://198.8.8.7:1433;DatabaseName=nhis", "sa", "sa123!@#");
                Statement stmt = connection.createStatement();

                String checkDataRepeatSql_str = "SELECT * FROM _COVID19test WHERE idNum = '"+ idNum_str +"'"; 
                ResultSet rs = stmt.executeQuery(checkDataRepeatSql_str);
                while(rs.next()){
                    //把时间格式更改为yyyy-MM-dd
                    String tempTime = rs.getString("samplingTime");
                    tempTime = tempTime.replaceAll("0","");//粗暴的解决月份和日期有0的问题，上同
                    tempTime = tempTime.replaceAll("-","/");//粗暴的解决月份和日期有-的问题
                    tempTime = tempTime.substring(0, tempTime.length()-1);//粗暴的解决月份和日期有.的问题
                    returnedData_str = 
                    rs.getString("myHospitalIdCard") + 
                    rs.getString("name") + 
                    rs.getString("idType") + 
                    rs.getString("phoneNum") + 
                    rs.getString("idNum") + 
                    rs.getString("sex") + 
                    rs.getString("countryAndRegion") + 
                    rs.getString("insuranceSheng") + 
                    rs.getString("settlementType") + 
                    rs.getString("peopleSource") + 
                    rs.getString("peopleIdentity") + 
                    rs.getString("immigrationWithinFTDays") + 
                    tempTime + 
                    rs.getString("specimenType") + 
                    rs.getString("testItems") + 
                    rs.getString("age");
                }
                if(returnedData_str.equals(checkDataRepeat_str)){
                    result_i = -2;
                }else{
                    result_i = stmt.executeUpdate(sql_str);
                }
                rs.close();
                stmt.close();
                connection.close();
            }catch(Exception e){
                e.printStackTrace();
                //out.println(e.toString());
            }
        }
        //out.println(result_i + "    " + sql_str);
    %>
    <%= result_i %>