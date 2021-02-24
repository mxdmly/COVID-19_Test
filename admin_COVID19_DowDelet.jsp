<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.regex.*" %>
<%@ page import="com.alibaba.fastjson.*" %>

<%! 
	//SQL安全防护的正则表达式
	String CHECKSQL = "\\*|\\.|;|=|%|or|and|if|end|go|exec|insert|select|delete|update|count|chr|mid|master|truncate|char|declare";
	String id_str;
	String getJsonData_str;//获取由html回传的json
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
        String sql_str = "";
        //使用阿里巴巴的fastjson.jar解析
        JSONArray array_json = JSONArray.parseArray(getJsonData_str);
        for(int i=0; i<array_json.size(); i++){
            JSONObject obj_json = JSONObject.parseObject(array_json.get(i).toString());
            //获取数据
            id_str = obj_json.get("ID").toString();
            //写sql语句
            sql_str = sql_str + "UPDATE _COVID19test SET isUpload = 2 WHERE ID IN(" + id_str + "); ";
        }
        try{
            out.println(sql_str);
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection connection = DriverManager.getConnection("jdbc:sqlserver://198.8.8.7:1433;DatabaseName=nhis", "sa", "sa123!@#");
            Statement stmt = connection.createStatement();
            result_i = stmt.executeUpdate(sql_str);//执行更改
            out.println(result_i);
            stmt.close();
            connection.close();
        }catch(Exception e){
            e.printStackTrace();
            out.println(e.toString());
        }
    }
%>