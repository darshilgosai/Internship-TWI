<!DOCTYPE html>
<%@ page import="sql_queries.TopQueries"%>
<%@ page import="sql_queries.TopStatistics"%>
<%@ page import="sql_queries.SimpleTopStatistics"%>
<%@ page import="sql_queries.DBUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@page import="session.WebSessionInterval"%>
<%@page import="session.WebSessionListener"%>
<%@ page import="java.sql.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html lang="en">
<head>
<meta charset="UTF-8" http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width = device-width, initial-scale=1">
<!-- shrink-to-fit=no -->
<meta name="author" content="Darshil Gosai - TWI GmbH">
<title>TWI Cockpit - TOP</title>
<link rel="stylesheet" type="text/css" href="toolkit-inverse.min.css"
	title="dark">
<link rel="stylesheet" type="text/css" href="toolkit-light.min.css"
	title="light">
<link rel="stylesheet" type="text/css" href="jquery.dataTables.min.css">
<jsp:include page="/WEB-INF/jsp/include/includeMenu.jsp" />
</head>
<body>

	<nav aria-label="breadcrumb">
		<ol class="breadcrumb">
			<li class="breadcrumb-item"><a
				href="${pageContext.request.contextPath}/index">Home</a></li>
			<li class="breadcrumb-item active" aria-current="page">TOP</li>
		</ol>
	</nav>
	<%
		try {
			// ======================= Get Database Connection =======================
			WebSessionInterval interval = new WebSessionInterval(session);
			WebSessionListener listener = new WebSessionListener();
			String real = session.getServletContext().getRealPath("");
			Connection conn = DBUtils.GetTopConnection(real);
			// ======================= Database-Queries ======================= 
			TopStatistics top = new TopStatistics();
			ArrayList<SimpleTopStatistics> list = top.SelectTopStatistics(conn);
	%>
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-3 sidebar">
				<%-- <a href="${pageContext.request.contextPath}/index">Zur&uuml;ck </a>
				<br> <br> --%>

			</div>
			<div class="col-md-9 content">
				<div class="table-responsive">
					<div class="col-md-9 content">
						<div class="dashhead">
							<div class="dashhead-titles">
								<h2 class="dashhead-title">TOP</h2>
								<h1 class="dashhead-subtitle">Bitte w&auml;hlen sie einen
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
											aria-label="Startzeit: activate to sort column ascending">Start-Ende</th>
									</tr>
								</thead>
								<tbody>
									<%
										for (SimpleTopStatistics deliv : list) {
									%>
									<tr>
										<td><a
											href="${pageContext.request.contextPath}/delivery?delivid=<%=deliv.getDelivId()%>"><%=deliv.getDelivId()%></a></td>
										<td><%=deliv.getStartDate()%></td>
										<td><%=deliv.getStartTime()%>-<%=deliv.getEndTime()%></td>
									</tr>
									<%
										}
										} catch (Exception ex) {
											ex.printStackTrace();
										}
									%>
								</tbody>
							</table>
						</div>
					</div>
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
	<!-- Placed at the end of the document so the pages load faster -->

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