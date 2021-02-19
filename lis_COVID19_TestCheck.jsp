<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.regex.*" %>

<%! 
	//SQL安全防护的正则表达式
	//String CHECKSQL = "\\*|\\.|;|=|%|or|and|if|end|go|exec|insert|select|delete|update|count|chr|mid|master|truncate|char|declare";
	String id_str, name_str, isUpload_str, idType_str, samplingTime;
	String dispaly_str;//显示在html页面，由jsp生成
%>
<%
	/*
	boolean sqlCheck_b = true;
	Pattern r = Pattern.compile(CHECKSQL);
	Matcher m = r.matcher("targerStr");
	sqlCheck_b = m.find();//使用find函数才能对任意字符串匹配
	int result_i = -1;//sql返回值
	*/
	try{
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		Connection connection = DriverManager.getConnection("jdbc:sqlserver://198.8.8.7:1433;DatabaseName=nhis", "sa", "sa123!@#");
		String sql_str = "SELECT ID, name, isUpload, idType, testResult, samplingTime FROM dbo._COVID19test";

		Statement stmt = connection.createStatement();
		ResultSet rs = stmt.executeQuery(sql_str);
		dispaly_str = "";
		while(rs.next()){
			if(rs.getString("samplingTime") != null){
				id_str = rs.getString("ID");
				name_str = rs.getString("name");//姓名
				isUpload_str = rs.getString("isUpload");//上报状态
				idType_str = rs.getString("idType");//身份证
				samplingTime =  rs.getString("samplingTime");//日期
				dispaly_str = dispaly_str + "{" + 
					"\"ID\":\"" + id_str + "\"," + 
					"\"isUpload\":\"" + isUpload_str + "\"," + 
					"\"name\":\"" + name_str + "\"," + 
					"\"idType\":\"" + idType_str + "\"," + 
					"\"samplingTime\":\"" + new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(samplingTime)) + "\"" + 
					"},";
			}
		}
		dispaly_str = "[" + dispaly_str.substring(0,dispaly_str.length() - 1) + "]";
		rs.close();
		stmt.close();
		connection.close();
	}catch(Exception e){
		e.printStackTrace();
		out.println(e.toString());
	}
	/*
	String temp_str = "";
	for(int i=0; i < 5; i++){
		temp_str = temp_str + "{\"ID\":" + i + ",\"isUpload\":\"1\",\"name\":\"张三\",\"idType\":\"44120219970214521" + i + "\",\"samplingTime\":\"2021/2/15 19:14:50\"},";
	}
	temp_str = "[" + temp_str.substring(0,temp_str.length() - 1) + "]";
	//dispaly_str = temp_str;
	*/
%>
<%= dispaly_str %>