<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.util.regex.*, java.text.SimpleDateFormat, java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>检测结果读取</title>
</head>
<body>
    <%! 
        String name_str, isUpload_str, idType_str;
        String dispaly_str;//显示在html页面，由jsp生成的表格
    %>
    <%
        String sql_str = "";//sql插入语句
        try{
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection connection = DriverManager.getConnection("jdbc:sqlserver://198.8.8.7:1433;DatabaseName=nhis", "sa", "sa123!@#");
            sql_str = "SELECT dbo._COVID19test.name, dbo._COVID19test.isUpload, dbo._COVID19test.idType, dbo._COVID19test.testResult, dbo._COVID19test.testTime FROM dbo._COVID19test";
        
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(sql_str);
            int i = 1;
            while(rs.next()){
                name_str = rs.getString("name");//姓名
                isUpload_str = rs.getString("isUpload");//上报状态
                idType_str = rs.getString("idType");//身份证
                dispaly_str = "<tr><td>" + i + "</td>" + 
                    "<td><input type=\"checkbox\" checked=\"ture\"/></td>" + 
                    "<td>" + name_str + "</td>" + 
                    "<td>" + isUpload_str + "</td>" + 
                    "<td>" + idType_str + "</td>" + 
                    "<td>阴性</td>" + 
                    "<td><input type=\"text\" value=\"" + new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()) + "\"/></td></tr>";
                i++;
            }
            rs.close();
            stmt.close();
            connection.close();    
        }catch(Exception e){
            e.printStackTrace();
            out.println(e.toString());
        }
    %>
    <%= dispaly_str %>
</body>
</html>