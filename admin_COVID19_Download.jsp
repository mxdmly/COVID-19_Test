<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.regex.*" %>

<%! 
	//SQL安全防护的正则表达式
	//String CHECKSQL = "\\*|\\.|;|=|%|or|and|if|end|go|exec|insert|select|delete|update|count|chr|mid|master|truncate|char|declare";
	String id_str, name_str, isUpload_str, idNum_str, samplingTime, testTime;
	String dispaly_str;//显示在html页面，由jsp生成
%>
<%
	/*********
	ArrayList<HashMap<String, String>> myArrayListJson = new ArrayList();
	HashMap<String, String> myHashJson_hm = new HashMap();
	myArrayListJson = new myJson(getJsonData_str).getJson();
	myHashJson_hm = myArrayListJson.get(0);
	dispaly_str = myHashJson_hm.get("ID");
	
	
	boolean sqlCheck_b = true;
	Pattern r = Pattern.compile(CHECKSQL);
	Matcher m = r.matcher("targerStr");
	sqlCheck_b = m.find();//使用find函数才能对任意字符串匹配
	int result_i = -1;//sql返回值
	*/
	try{
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		Connection connection = DriverManager.getConnection("jdbc:sqlserver://198.8.8.7:1433;DatabaseName=nhis", "sa", "sa123!@#");
		String sql_str = "SELECT ID, name, isUpload, idNum, testResult, samplingTime, testTime FROM dbo._COVID19test WHERE isUpload = 1";

		Statement stmt = connection.createStatement();
		ResultSet rs = stmt.executeQuery(sql_str);
		dispaly_str = "";
		while(rs.next()){
			if(rs.getString("samplingTime") != null){
				id_str = rs.getString("ID");
				name_str = rs.getString("name");//姓名
				isUpload_str = rs.getString("isUpload");//上报状态
				idNum_str = rs.getString("idNum");//身份证
				samplingTime =  rs.getString("samplingTime");//采样日期
				testTime =  rs.getString("testTime");//采样日期
				dispaly_str = dispaly_str + "{" + 
					"\"ID\":\"" + id_str + "\"," + 
					"\"isUpload\":\"" + isUpload_str + "\"," + 
					"\"name\":\"" + name_str + "\"," + 
					"\"idNum\":\"" + idNum_str + "\"," + 
					"\"samplingTime\":\"" + samplingTime + "\"," + 
					"\"testTime\":\"" + testTime + "\"" + 
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
		temp_str = temp_str + "{\"ID\":" + i + ",\"isUpload\":\"1\",\"name\":\"张三\",\"idNum\":\"44120219970214521" + i + "\",\"samplingTime\":\"2021/2/15 19:14:50\"},";
	}
	temp_str = "[" + temp_str.substring(0,temp_str.length() - 1) + "]";
	//dispaly_str = temp_str;
	*/
%>
<%= dispaly_str %>