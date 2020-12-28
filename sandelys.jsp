<!DOCTYPE html>
<%@page pageEncoding="UTF-8" language="java"%>
<%@page contentType="text/html;charset=UTF-8"%>
<html>
	<head>
		<meta charset="utf-8">
		<style>
			th {
				background-color: #A52A2A
			}
		</style>
	</head>
<body>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>

<%
// String id = request.getParameter("userId");
	String driverName = "com.mysql.jdbc.Driver";
	String connectionUrl = "jdbc:mysql://localhost:3306/";
	String dbName = "prekyba";
	String userId = "root";
	String password = "";
/*
try {
Class.forName(driverName);
} catch (ClassNotFoundException e) {
e.printStackTrace();
}
*/
	Connection connection = null;
	Statement statement = null;
	ResultSet resultSet = null;
/*
	2	pav	varchar(256)	utf8_lithuanian_ci
	3	gyv_sk	bigint(20)
	4	plotas	decimal(12,2)
	5	platuma	decimal(10,7)
	6	ilguma	decimal(10,7)	
	7	valstybe	char(3)	utf8_lithuanian_ci		
*/
%>
<h2 align="center"><strong>Sandėlio ataskaita</strong></h2>
<table align="center" cellpadding="5" cellspacing="5" border="1">
<tr>

</tr>
<tr>
	<th>Prekė</th>
	<th>Barkodas</th>
	<th>Kiekis </th>
	<th>Surasta</th>
</tr>
<%

	String sql="";

	try{
	     
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");		
		
	} catch(Exception e) {}

	try{ 
	
		String jdbcutf8 = ""; //  "&useUnicode=true&characterEncoding=UTF-8";	
		connection = DriverManager.getConnection ( connectionUrl + dbName + jdbcutf8, userId, password );
		
		statement=connection.createStatement();		
		sql =
				"SELECT " 
				+ "`prekes`.`preke` AS `preke`"
				+ ", `prekes_gavimai`.`barkodas`"
				+ ", SUM(`prekes_gavimai`.`kiekis`) AS `kiekis`"
				+ " FROM `prekes_gavimai`"
				+ " LEFT JOIN `prekes_tiekejai` ON ( `prekes_gavimai`.`barkodas`=`prekes_tiekejai`.`barkodas` )"
				+ " LEFT JOIN `prekes` ON ( `prekes_tiekejai`.`id_prekes`=`prekes`.`id` ) "
				+ "  WHERE 1"
				+ " GROUP BY `prekes_gavimai`.`barkodas`"
				+ " ORDER BY `prekes`.`preke`, `prekes_gavimai`.`barkodas`"
			;



		resultSet = statement.executeQuery(sql);
		 
		while( resultSet.next() ){
%>
<tr style="background-color: #DEB887">
	<td><%= resultSet.getString ( "preke" ) %></td>
	<td><%= resultSet.getString ( "barkodas" ) %></td>
	<td><%= resultSet.getString  ("kiekis" ) %></td>
	<td></td>
</tr>

<% 
		}

	} catch (Exception e) {
	
		e.printStackTrace();
	}
%>
</table>
<%=  sql %>
</body>