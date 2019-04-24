<!DOCTYPE html PUBLIC>
<%@ page import="sql_queries.AssQueries"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@page import="session.WebSessionInterval"%>

<%@ page import="sql_queries.DBUtils"%>
<%@ page import="java.sql.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<meta charset="UTF-8" http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width = device-width, initial-scale=1">
<meta name="author" content="Darshil Gosai- TWI GmbH">
<title>TWI Cockpit - ASS</title>
<link rel="stylesheet" type="text/css" href="toolkit-inverse.min.css"
	title="dark">
<link rel="stylesheet" type="text/css" href="toolkit-light.min.css"
	title="light">
<link rel="stylesheet" type="text/css" href="jquery.dataTables.min.css">
<jsp:include page="/WEB-INF/jsp/include/includeMenu.jsp" />
</head>

<!-- This page displays all deliveries from the ASS-Machines -->

<body>
	<!-- ======================== Breadcrumb ======================== -->
	<nav aria-label="breadcrumb">
		<ol class="breadcrumb">
			<li class="breadcrumb-item"><a
				href="${pageContext.request.contextPath}/index">Home</a></li>
			<li class="breadcrumb-item active" aria-current="page">ASS</li>
		</ol>
	</nav>
	<%
		// ======================= Get Database Connection =======================
		WebSessionInterval interval = new WebSessionInterval(session);
		String real = session.getServletContext().getRealPath("");
		Connection conn = DBUtils.GetAssConnection(real);

		/* String base = "\"${pageContext.request.contextPath}"; */

		// ======================= Database-Queries ======================= 
		AssQueries.clAssIndex Index = new AssQueries.clAssIndex(conn);
		DecimalFormat myInt = (DecimalFormat) DecimalFormat.getInstance(Locale.GERMAN);
		myInt.applyPattern("#,###,##0");
		myInt.setGroupingUsed(true);
		DecimalFormat myDec = new DecimalFormat("#0.00");
		// =====================================================================
	%>

	<div class="container-fluid">
		<div class="row">
			<div class="col-md-3 sidebar">
				<br> <br>
			</div>
			<div class=" col-md-9 content">
				<div class="table-responsive">
					<div class="col-md-9 content">
						<div class="dashhead">
							<div class="dashhead-titles">
								<h2 class="dashhead-title">ASS</h2>
								<h1 class="dashhead-subtitle">Bitte w&auml;hlen sie eine KW</h1>

							</div>
						</div>
						<table id="table" class="table table-hover dataTable no-footer"
							role="grid" aria-describedby="example_info" style="width: 100%;">
							<thead>
								<tr role="row">
									<th class="sorting_desc" tabindex="0" aria-controls="example"
										rowspan="1" colspan="1" aria-sort="descending"
										aria-label="ID: activate to sort colum ascending">KW</th>
									<th class="sorting" tabindex="0" aria-controls="example"
										rowspan="1" colspan="1"
										aria-label="Datum: activate to sort column ascending">Dauer</th>
									<th class="sorting" tabindex="0" aria-controls="example"
										rowspan="1" colspan="1"
										aria-label="Startzeit: activate to sort column ascending">Exemplare</th>
								</tr>
							</thead>

							<!-- ======================== TableData ======================== -->
							<tbody>
								<%
									for (int i = 0; i < Index.vWeek.size(); i++) {
								%>
								<tr>
									<td><a
										href="${pageContext.request.contextPath}/returns?week=<%=Index.vWeek.get(i) %>&year=<%=Index.vYear.get(i)%>">
											<%=Index.vWeek.get(i)%>/<%=Index.vYear.get(i)%></a></td>
									<td class="col3"><%=myDec.format(Index.vZeitGes.get(i))%>
										h</td>
									<td class="col3"><%=myInt.format(Index.vTotal.get(i))%></td>
								</tr>
								<%
									}
								%>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>

		<!-- place nav in outer div to make nav in middle -->
		<!-- <nav>
			<ul class="pagination justify-content-center">
				 <li class="page-item"><a class="page-link" href="#"
					aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
						<span class="sr-only">Previous</span>
				</a></li> 
				 <li class="page-item active"><a class="page-link" href="#">1</a></li>
				<li class="page-item"><a class="page-link" href="#">2</a></li>
				<li class="page-item"><a class="page-link" href="#">3</a></li>
				<li class="page-item"><a class="page-link" href="#">4</a></li>
				<li class="page-item"><a class="page-link" href="#">5</a></li>
				<li class="page-item"><a class="page-link" href="#"
					aria-label="Next"> <span aria-hidden="true">&raquo;</span> <span
						class="sr-only">Next</span>
				</a></li> 
			</ul>
		</nav> -->
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
	<!-- 	styleswitcher -->
	<script src="styleswitcher.js"></script>
	<!-- 	Sort Tables -->
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
