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
%>
<h2 align="center"><strong>Sandėlio ataskaita</strong></h2>
<table align="center" cellpadding="5" cellspacing="5" border="1">
<tr>

</tr>
<tr>
	<th rowspan="2">Barkodas</th>
	<th colspan="4">Kiekis </th>
</tr>
<tr>
	<th>Gauta</th>
	<th>Parduota</th>
	<th>Likutis</th>
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
				+ " `prekes`.`preke` AS `preke`"
				+ " , `prekes_gavimai`.`barkodas`"
				+ " , SUM( `prekes_gavimai`.`kiekis`) AS `kiekis_gauta`"
				+ " , SUM( `prekes_pardavimai`.`kiekis`) AS `kiekis_parduota`"
				+ " , SUM( `prekes_gavimai`.`kiekis`-`prekes_pardavimai`.`kiekis`)  AS `prekiu_likutis`"
				+  ", `selektoriai`.`reiksme` AS `prekiu_grupe`"
				+ " FROM `prekes_gavimai`"
				+ " LEFT JOIN `prekes_tiekejai` ON ( `prekes_gavimai`.`barkodas`=`prekes_tiekejai`.`barkodas` )"
				+ " LEFT JOIN `prekes` ON ( `prekes_tiekejai`.`id_prekes`=`prekes`.`id` ) "
				+ " LEFT JOIN `prekes_pardavimai` ON ( `prekes_pardavimai`.`id_prekes_gavimo`=`prekes_gavimai`.`id` )"
				+ " LEFT JOIN `selektoriai` ON ( `prekes`.`id_grupes`=`selektoriai`.`id` AND `selektoriai`.`grupe`='prekiu_grupes' )"
				+ "  WHERE 1"
				+ " GROUP BY `prekes_gavimai`.`barkodas`"
				+ " HAVING `prekiu_likutis`<10000"				
				+ " ORDER BY `selektoriai`.`id`, `prekes`.`preke`, `prekes_gavimai`.`barkodas`"
			;

		resultSet = statement.executeQuery(sql);
		
		String prekiu_grupe_curr = "";
		String preke_curr = "";
		 
		while( resultSet.next() ){
		
			String preke = resultSet.getString ( "preke" ); 
			String prekiu_grupe =resultSet.getString ( "prekiu_grupe" );
		
			if  ( ! prekiu_grupe_curr.equals ( prekiu_grupe ) ) {
			
				prekiu_grupe_curr = prekiu_grupe;
%>
				<tr><td colspan="6"><%= prekiu_grupe %></td></tr>
<%
			}

			if  ( ! preke_curr.equals ( preke ) ) {
			
				preke_curr = preke;
%>
				<tr><td colspan="6"><%= preke %></td></tr>
<%
			}
%>
<tr style="background-color: #DEB887">
	<td><%= resultSet.getString ( "barkodas" ) %></td>
	<td><%= resultSet.getString  ("kiekis_gauta" ) %></td>
	<td><%= resultSet.getString  ("kiekis_parduota" ) %></td>
	<td><%= resultSet.getString  ("prekiu_likutis" ) %></td>
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