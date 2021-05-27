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
        String returnedData_str = "";//数据库返回的数据
    %>
    <%
        //ID Card，按这个查询个人信息
        String myHospitalIdCard_str = request.getParameter("myHospitalIdCard");
        String targerStr = myHospitalIdCard_str;

        boolean sqlCheck_b = true;
        Pattern r = Pattern.compile(CHECKSQL);
		Matcher m = r.matcher(targerStr);
        sqlCheck_b = m.find();//使用find函数才能对任意字符串匹配

        if(sqlCheck_b){
            out.print("发现SQL注入");
        }else{
            //out.print("通过");
            try{
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                Connection connection = DriverManager.getConnection("jdbc:sqlserver://198.8.8.7:1433;DatabaseName=nhis", "sa", "sa123!@#");
                Statement stmt = connection.createStatement();
                //查询姓名、手机号、身份证
                String checkDataRepeatSql_str = "SELECT TOP 1 Name,CurMobile,IdentityNo " +
                "FROM dbo.HoldedCard " +
                "INNER JOIN dbo.Patient ON HoldedCard.PatientEntityId = Patient.PatientId " +
                "INNER JOIN dbo.PatientOther ON HoldedCard.PatientEntityId = PatientOther.PatientEntityId " +
                "WHERE HoldedCard.CardNo = '"+ myHospitalIdCard_str +"'";
                ResultSet rs = stmt.executeQuery(checkDataRepeatSql_str);
                if(rs.next()){
                    //返回JSON格式的数据
                    returnedData_str = "{" + 
                    "\"myName\":\"" + rs.getString("Name") + "\"," + 
                    "\"myPhoneNum\":\"" + rs.getString("CurMobile") + "\"," + 
                    "\"idNum\":\"" + rs.getString("IdentityNo") + "\"" + 
					"}";
                    returnedData_str = "[" + returnedData_str + "]";
                }else{
                    returnedData_str = null;
                }
                rs.close();
                stmt.close();
                connection.close();
            }catch(Exception e){
                e.printStackTrace();
                //out.println(e.toString());
            }
        }
    %>
    <%= returnedData_str %>