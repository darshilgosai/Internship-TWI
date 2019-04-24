<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import="sql_queries.DBUtils"%>
<%@ page import="sql_queries.AeroQueries"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.sql.*"%>
<html>
<head>
<meta charset="UTF-8" http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width = device-width, initial-scale=1">
<meta name="author" content="Darshil Gosai - TWI GmbH">
<title>TWI Cockpit - AERO</title>
<link rel="stylesheet" type="text/css" href="toolkit-inverse.min.css"
	title="dark">
<link rel="alternate stylesheet" type="text/css"
	href="toolkit-light.min.css" title="light">
<link rel="stylesheet" type="text/css" href="jquery.dataTables.min.css">
<jsp:include page="/WEB-INF/jsp/include/includeMenu.jsp" />
</head>
<body>

	<!-- This page displays all deliveries from the AERO-Machines at specific warehouse -->

	<nav aria-label="breadcrumb">
		<ol class="breadcrumb">
			<li class="breadcrumb-item"><a
				href="${pageContext.request.contextPath}/index">Home</a></li>
			<li class="breadcrumb-item"><a
				href="${pageContext.request.contextPath}/aero">AERO</a></li>
			<li class="breadcrumb-item active" aria-current="page">COMPAERO</li>
		</ol>
	</nav>

	<%
		// ======================= Get Information from the Page-URL ======================= 
		Integer WarehouseIndex;
		if (request.getParameter("warehouse") == null) {
			WarehouseIndex = 23;
		} else {
			WarehouseIndex = (int) Integer.parseInt(request.getParameter("warehouse"));
		}

		// ======================= Get Database Connection =======================
		String real = session.getServletContext().getRealPath("");
		Connection conn = DBUtils.GetAeroConnection(real);

		// ======================= Database-Queries ======================= 
		AeroQueries.clCompanyIndex Index = new AeroQueries.clCompanyIndex(conn, WarehouseIndex);
		// =====================================================================
	%>
	<div class="container-fluid">
		<div class="row">
			
			<div class="col-md-9 content mx-auto">
				<div class="table-responsive mx-auto">
<!-- 					<div class="col-md-9 content"> -->
						<div class="dashhead">
							<div class="dashhead-titles">
								<h2 class="dashhead-title">
									AERO -
									<%=Index.Company%>
									<%=Index.Location%></h2>
								<h1 class="dashhead-subtitle">Bitte w&auml;hlen Sie einen
									Versand</h1>
							</div>
						</div>
						<br>
						<div>
							<table id="table" class="table table-hover dataTable no-footer"
								role="grid" aria-describedby="example_info" style="width: 100%;">
								<thead>
									<tr role="row">
										<th class="sorting_desc" tabindex="0" aria-controls="example"
											rowspan="1" colspan="1" aria-sort="descending"
											aria-label="ID: activate to sort colum ascending">ID</th>
										<th class="sorting" tabindex="0" aria-controls="example"
											rowspan="1" colspan="1"
											aria-label="Datum: activate to sort column ascending">Datum</th>
										<th class="sorting" tabindex="0" aria-controls="example"
											rowspan="1" colspan="1"
											aria-label="Startzeit: activate to sort column ascending">Startzeit</th>
										<th class="sorting" tabindex="0" aria-controls="example"
											rowspan="1" colspan="1"
											aria-label="Endzeit: activate to sort column ascending">Endzeit</th>
									</tr>
								</thead>
								<tbody>
									<%
										for (int i = 0; i < Index.vDelivID.size(); i++) {
									%>
									<tr>
										<td><a
											href="${pageContext.request.contextPath}/delivaero?delivid=<%=Index.vDelivID.get(i)%>&warehouse=<%=WarehouseIndex%>"><%=Index.vDelivID.get(i)%></a></td>
										<td><%=Index.vStartdate.get(i)%></td>
										<td><%=Index.vStarttime.get(i)%></td>
										<td><%=Index.vEndtime.get(i)%></td>
									</tr>
									<%
										}
									%>
								</tbody>
							</table>
						</div>
						<!-- <div class="text-center">
							<nav>
								<div class="col-md-12 text-center">
									<ul class="pagination pagination-lg pager" id="myPager"></ul>
								</div>
							</nav>
						</div>
						<br> -->


<!-- 					</div> -->
				</div>
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
	<!-- required to run bootstrap -->
	<script src="jquery-3.3.1.min.js"></script>
	<script src="popper.min.js"></script>
	<script src="bootstrap.min.js"></script>
	<!-- styleswitcher -->
	<script src="styleswitcher.js"></script>
	<!-- sorting tables -->
	<script src="datatables.min.js"></script>

	<script>
		//========================= DataTables ===============================

		$(document)
				.ready(
						function() {
							$('#table')
									.DataTable(
											{
												"dom" : '<"top"f>rt<"bottom"ilp><"clear">',
												"info" : true,
												"ordering" : true,
												"order" : [ [ 0, 'desc' ] ],
												"pageLength" : 10,
												"paging" : true,
												"pagingType" : "full_numbers",
												language : {
													paginate : {
														previous : '<i class="icon icon-triangle-left">',
														next : '<i class="icon icon-triangle-right">',
														first : '<i class="icon icon-controller-fast-backward">',
														last : '<i class="icon icon-controller-fast-forward">',
													}
												}

											})
						});
	</script>
</body>
</html>
