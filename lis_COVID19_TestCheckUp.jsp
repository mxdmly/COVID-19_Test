<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.regex.*" %>
<%@ page import="com.alibaba.fastjson.*" %>

<%! 
    public class Person{
        int ID;
        String isUpload;
        String testResult;
        String testTime;
        Person(int ID, String isUpload, String testResult, String testTime){
            super();
            this.ID = ID;
            this.isUpload = isUpload;
            this.testResult = testResult;
            this.testTime = testTime;
        }
    }
	//SQL安全防护的正则表达式
	String CHECKSQL = "\\*|\\.|;|=|%|or|and|if|end|go|exec|insert|select|delete|update|count|chr|mid|master|truncate|char|declare";
	String id_str,  isUpload_str,  testTime_str, testResult_str;
	String getJsonData_str;//获取由html回传的json
    Person getJsonData_json;//由json转java对象
%>
<%
    getJsonData_str = request.getParameterValues("data")[0];
	boolean sqlCheck_b = true;
	Pattern r = Pattern.compile(CHECKSQL);
	Matcher m = r.matcher(getJsonData_str);
	sqlCheck_b = m.find();//使用find函数才能对任意字符串匹配
	int result_i = -1;//sql返回值
    
    if(sqlCheck_b){
        out.println("发现SQL注入");
    }else{
        out.println(getJsonData_str);
        //getJsonData_str = "{ID: \"58\", isUpload: \"0\", name: \"null\", idType: \"居民身份证\", samplingTime: \"2021/02/19 12:33:42\"}";
        //getJsonData_json = JSON.parseObject(getJsonData_str, Person.Class);
        //out.println(getJsonData_json);
        /*
        id_str = rs.getString("ID");
        isUpload_str = rs.getString("isUpload");//上报状态
        testTime_str =  rs.getString("testTime");//日期
        testResult_str="阴性";

        String sql_str = "UPDATE _COVID19test SET isUpload" + isUpload_str + 
        ",testResult=" + testResult_str + 
        ",testTime=" +  testTime_str
        "WHERE ID IN(" + id_str + ");";
        try{
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection connection = DriverManager.getConnection("jdbc:sqlserver://198.8.8.7:1433;DatabaseName=nhis", "sa", "sa123!@#");
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(sql_str);//改插入
            rs.close();
            stmt.close();
            connection.close();
        }catch(Exception e){
            e.printStackTrace();
            out.println(e.toString());
        }
        */
    }
%>