<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<%@ page import="sql_queries.DBUtils"%>
<%@ page import="sql_queries.AeroQueries"%>
<%@page import="session.WebSessionInterval"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="sql_queries.ConnectionPath"%>
<%@ page import="com.spring.security.config.UserAuthorities"%>
<html>
<head>
<meta charset="UTF-8" http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width = device-width, initial-scale=1">
<meta name="author" content="Darshil Gosai- TWI GmbH">
<title>TWI Cockpit - AERO</title>
<link rel="stylesheet" type="text/css" href="toolkit-inverse.min.css"
	title="dark">
<link rel="alternate stylesheet" type="text/css" title="light"
	href="toolkit-light.min.css">
<jsp:include page="/WEB-INF/jsp/include/includeMenu.jsp" />
</head>


<!-- This page displays all warehouses a user can access in form of buttons-->
<body>
	<nav aria-label="breadcrumb">
		<ol class="breadcrumb">
			<li class="breadcrumb-item"><a
				href="${pageContext.request.contextPath}/index">Home</a></li>
			<li class="breadcrumb-item active" aria-current="page">AERO</li>
		</ol>
	</nav>

	<%
		// ======================= Get Database Connection =======================
		String real = session.getServletContext().getRealPath("");
		// not needed, because of DBUtils. but maybe this is a better way?  		
		//ConnectionPath cp = new ConnectionPath();
		//Connection conn = ConnectionPath.getConnAero(); 
		Connection conn = DBUtils.GetAeroConnection(real);
		WebSessionInterval interval = new WebSessionInterval(session);
		
		// ======================= Database-Queries ======================= 
		AeroQueries.clAeroIndex Index = new AeroQueries.clAeroIndex(conn);
		
		List<String> authorities = UserAuthorities.getAuthorities();
		// =====================================================================
	%>
	<div class="container-fluid">
		<div class="row">

			<div class="col-md-8 content m-auto">
				<%-- 	<!-- WarehouseButtons -->
				<%
					for (int i = 0; i < Index.vWarehouse.size(); i++) {
				%>
				<a
					href="${pageContext.request.contextPath}/compaero?warehouse=<%=Index.vWarehouse.get(i)%>"
					class="btn btn-lg btn-block btn-primary" role="button"><%=Index.vCompany.get(i)%>
					<%=Index.vLocation.get(i)%></a>
				<%
					}
				%> --%>

				<!-- WarehouseButtons -->
				<%
					for (int i = 0; i < authorities.size(); i++) {
						// List of authorities = warehouse indices in current representation.
						if (!authorities.get(i).startsWith("ROLE_")) {
							AeroQueries.clCompanyIndex windex = new AeroQueries.clCompanyIndex(conn,
									Integer.parseInt(authorities.get(i)));
				%>
				<a
					href="${pageContext.request.contextPath}/compaero?warehouse=<%=authorities.get(i)%>"
					class="btn btn-lg btn-block btn-primary" role="button"><%=windex.Company%>
					<%=windex.Location%></a>
				<%
					}
					}
				%>
			</div>
		</div>
	</div>


	<!-- ======================== Logout logic ======================== -->
	<c:url value="/logout" var="logoutUrl" />
	<form id="logout" action="${logoutUrl}" method="post">
		<input type="hidden" name="${_csrf.parameterName}"
			value="${_csrf.token}" />
	</form>

	<!-- ======================== Java Script ======================== -->
	<!-- Placed at the end of the document so the pages load faster -->
	<!-- required to run bootstrap -->
	<script src="jquery-3.3.1.min.js"></script>
	<script src="popper.min.js"></script>
	<script src="bootstrap.min.js"></script>
	<!-- 	styleswitcher -->
	<script src="styleswitcher.js"></script>
</body>
</html>