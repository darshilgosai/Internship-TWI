<!DOCTYPE html PUBLIC>
<%@ page import="sql_queries.AssQueries"%>
<%-- <%@ page import="charts.Charts"%> --%>
<%@ page import="charts.CsvASS"%>
<%@page import="session.WebSessionInterval"%>
<%@page import="session.WebSessionListener"%>
<%@ page import="sql_queries.DBUtils"%>
<%@ page import="java.sql.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html lang="en">
<head>
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<meta name="viewport" content="width = device-width">
<meta name="author" content="Darshil Gosai- TWI GmbH">
<title>TWI Cockpit - ASS</title>
<link rel="stylesheet" type="text/css" href="toolkit-inverse.min.css"
	title="dark">
<link rel="stylesheet" type="text/css" href="toolkit-light.min.css"
	title="light">
<link rel="stylesheet" type="text/css" href="jquery.dataTables.min.css">
<jsp:include page="/WEB-INF/jsp/include/includeMenu.jsp" />

</head>
<body>

	<!-- This page displays statistics from a specific Top-Delivery -->

	<nav aria-label="breadcrumb">
		<ol class="breadcrumb">
			<li class="breadcrumb-item"><a
				href="${pageContext.request.contextPath}/index">Home</a></li>
			<li class="breadcrumb-item"><a
				href="${pageContext.request.contextPath}/ass">ASS</a></li>
			<li class="breadcrumb-item active" aria-current="page">RETURNS</li>
		</ol>
	</nav>


	<%
		// ======================= Get Information from the Page-URL ======================= 
		String week = request.getParameter("week");
		String year = request.getParameter("year");
		String real = session.getServletContext().getRealPath("");
		String savename = "/" + week + "_" + year + ".png";
		String sID = session.getId();
		String pathfile = real + "Csv/ass.csv";
		String pathfile2 = real + "Csv/sevenAss.csv";

		// ======================= Get Database Connection =======================
		WebSessionInterval interval = new WebSessionInterval(session);
		Connection conn = DBUtils.GetAssConnection(real);

		// ======================= Database-Queries =======================
		AssQueries.clAssStatQuery AssStatQuery = new AssQueries.clAssStatQuery(conn, year, week);
		CsvASS CsvASS = new CsvASS(conn, real, week, year, sID);

		// ======================= Fetching Data for Charts =======================
		AssQueries.clAssFourChartQuery AssChart = new AssQueries.clAssFourChartQuery(conn, year, week);
		String del = "";
		String manu = "";
		String scan = "";
		String gesamt = "";
		for (int i = 0; i < AssChart.Datum.size(); i++) {
			if (i == AssChart.Datum.size() - 1) {
				del += (AssChart.DeletedCopies.get(i));
				manu += (AssChart.ManuCount.get(i));
				scan += (AssChart.ScanCount.get(i));
				gesamt += (AssChart.UnknownCount.get(i) + AssChart.CreditSumme.get(i)
						- AssChart.DeletedCopies.get(i));
			} else {
				del += (AssChart.DeletedCopies.get(i) + ",");
				manu += (AssChart.ManuCount.get(i) + ",");
				scan += (AssChart.ScanCount.get(i) + ",");
				gesamt += (AssChart.UnknownCount.get(i) + AssChart.CreditSumme.get(i)
						- AssChart.DeletedCopies.get(i) + ",");
			}
		}
		// =====================================================================
	%>

	<div class="container-fluid">
		<div class="row">
			<div class="col-md-3 sidebar">

				<!-- ======================== Download .csv-Files for delivery statistics ======================== -->
				<a class="btn btn-info btn-block"
					href="<c:url value='/download/csv/ass/${pageContext.session.id}'/>"
					class="btn btn-primary" role="button">Export 1 Day</a> <a
					class="btn btn-info btn-block"
					href="<c:url value='/download/csv/sevenass/${pageContext.session.id}'/>"
					class="btn btn-primary" role="button">Export 7 Days</a>
				<!-- ============================================================================================= -->
			</div>
			<div class="col-md-9 content">
				<div class="table-responsive">
					<div class="col-md-9 content">
						<div class="dashhead">
							<div class="dashhead-titles">
								<h2 class="dashhead-title">
									ASS
									<%=week%>/<%=year%></h2>
							</div>
						</div>
						<table class="table table-bordered table-hover">
							<thead>
								<tr>
									<th>Station</th>
									<th>Gescannt</th>
									<th>Manuell</th>
									<th>Gel&ouml;scht</th>
									<th>Total</th>
									<!-- <th>Dauer</th>
									<th>Scanrate</th>
									<th>Nettodurchsatz</th> -->
								</tr>
							</thead>
							<tfoot>
								<tr>
									<th>Summe</th>
									<td><%=AssStatQuery.myInt.format(AssStatQuery.scanGes)%></td>
									<td><%=AssStatQuery.myInt.format(AssStatQuery.manuGes)%></td>
									<td><%=AssStatQuery.myInt.format(AssStatQuery.delGes)%></td>
									<td><%=AssStatQuery.myInt.format(AssStatQuery.totalGes)%></td>
								</tr>
							</tfoot>
							<tbody>
								<%
									for (int i = 0; i < AssStatQuery.scan.size(); i++) {
								%>
								<tr>
									<td><%=AssStatQuery.station.get(i)%></td>
									<td><%=AssStatQuery.myInt.format(AssStatQuery.scan.get(i))%></td>
									<td><%=AssStatQuery.myInt.format(AssStatQuery.manu.get(i))%></td>
									<td><%=AssStatQuery.myInt.format(AssStatQuery.del.get(i))%></td>
									<td><%=AssStatQuery.myInt.format(AssStatQuery.total.get(i))%></td>
								</tr>
								<%
									}
								%>
							</tbody>
						</table>
						<br> <br>

						<!-- 						<table class="table table-bordered table-hover table-responsive"> -->
						<!-- 							<thead> -->
						<!-- 								<tr> -->
						<!-- 									<th>Station</th> -->
						<!-- 									<th>Dauer</th> -->
						<!-- 									<th>Scanrate</th> -->
						<!-- 									<th>Nettodurchsatz</th> -->
						<!-- 								</tr> -->
						<!-- 							</thead> -->
						<!-- 							<tfoot> -->
						<!-- 								<tr> -->
						<!-- 									<th>Summe</th> -->
						<%-- 									<td><%=AssStatQuery.myFormatter.format(AssStatQuery.zeitGes)%> --%>
						<!-- 										h</td> -->
						<%-- 									<td><%=AssStatQuery.myFormatter.format(AssStatQuery.scanRateGes / AssStatQuery.anzStat)%> --%>
						<!-- 										%</td> -->
						<%-- 									<td><%=AssStatQuery.myInt.format(AssStatQuery.nettoDurchsatzGes / AssStatQuery.anzStat)%> --%>
						<!-- 										Ex./h</td> -->
						<!-- 								</tr> -->
						<!-- 							</tfoot> -->
						<!-- 							<tbody> -->
						<%-- 								<% --%>
						<!-- // 									for (int i = 0; i < AssStatQuery.scan.size(); i++) { -->
						<%-- 								%> --%>
						<!-- 								<tr> -->
						<%-- 									<td><%=AssStatQuery.station.get(i)%></td> --%>
						<%-- 									<td><%=AssStatQuery.myFormatter.format(AssStatQuery.zeit.get(i))%> --%>
						<!-- 										h</td> -->
						<%-- 									<td><%=AssStatQuery.myFormatter.format(AssStatQuery.scanRate.get(i))%> --%>
						<!-- 										%</td> -->
						<%-- 									<td><%=AssStatQuery.nettoDurchsatz.get(i)%> Ex./h</td> --%>
						<!-- 								</tr> -->
						<%-- 								<% --%>
						<!-- // 									} -->
						<%-- 								%> --%>
						<!-- 							</tbody> -->
						<!-- 						</table> -->
						<!-- 						<br> -->
						<!-- 						<hr /> -->

						<!--  						CHARTS						 -->
						<!-- 						<h2>Aktuelle Woche</h2> -->
						<%-- 						<%
							AssQueries.clAssChartQuery AssCharts = new AssQueries.clAssChartQuery(conn, year, week);
							Charts.clChartAss Chart = new Charts.clChartAss(conn, year, week, AssCharts.aussen, AssCharts.innen, real,
									savename, sID);
						%>
						<c:url var="week" value="<%=week%>" />
						<c:url var="year" value="<%=year%>" />
						<img alt=""
							src="<c:url value='/download/img/${week}/${year}/${pageContext.session.id}'/>">
						<br> <br>
						<hr />
						<h2>R&uuml;ckblick</h2>
						<%
														AssQueries.clAssFourChartQuery AssChart4 = new AssQueries.clAssFourChartQuery(conn, year, week); 
													Charts.clChartAssFour Chart4 = new Charts.clChartAssFour(conn, year, week, AssChart4.aussen, 
							 									AssChart4.innen, real, sID); 
							 							String img2 = real + sID + "\\" + week + "_" + year + "_Weeks.png"; 
						%>
						<img alt=""
							src="<c:url value='/download/imge/${week}/${year}/${pageContext.session.id}'/>"> --%>


						<!-- ======================== Chart ======================== -->

						<div class="modal fade" id="modKont" tabindex="-1" role="dialog"
							aria-labelledby="exampleModalLabel" aria-hidden="true">
							<div class="modal-dialog">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close ml-0" data-dismiss="modal">
											<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
										</button>
										<h4 class="modal-title" id="exampleModalLabel">5-Wochen-R&uuml;ckblick
										</h4>
									</div>
									<div class="modal-body">
										<canvas id="canvas" width="568" height="300"></canvas>
									</div>
								</div>
							</div>
						</div>
						<div class="row justify-content-center hr">
							<a href="#" data-toggle="modal" data-target="#modKont"
								data-source=<%=del%> data-source1=<%=manu%>
								data-source2=<%=scan%> data-source3=<%=gesamt%>
								class="btn btn-primary" role="button"> <span
								class="icon icon-layers"></span> 5-Wochen-R&uuml;ckblick
							</a>
						</div>
						<!-- ======================================================= -->
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
	<!-- required to run bootstrap -->
	<script src="jquery-3.3.1.min.js"></script>
	<script src="popper.min.js"></script>
	<script src="bootstrap.min.js"></script>
	<!-- styleswitcher -->
	<script src="styleswitcher.js"></script>
	<!-- charts -->
	<script src="chart.js"></script>

	<script>
		//===================================== BAR CHART ===========================================

		$('#modKont')
				.on(
						'shown.bs.modal',
						function(event) {
							var link = $(event.relatedTarget);
							// get data source
							var source = link.attr('data-source').split(',');
							var source1 = link.attr('data-source1').split(',');
							var source2 = link.attr('data-source2').split(',');
							var source3 = link.attr('data-source3').split(',');
							// get title
							var title = link.html();
							// get target source
							var target = [];
							/* $.each(labels, function(index, value) {
								target.push(link.attr('data-target-source'));
							}); */
							// initialise Chart
							var modal = $(this);
							var canvas = modal.find('.modal-body canvas');
							modal.find('.modal-title').html(title);
							var ctx = canvas[0].getContext("2d");
							var chart = new Chart(
									ctx,
									{
										type : 'bar',
										data : {
											labels : [
	<%for (int i = 0; i < AssChart.Datum.size(); i++) {
				out.print(AssChart.Week.get(i) + "." + AssChart.Year.get(i) + ",");
			}%>
		],
											datasets : [
													{
														backgroundcolor : "rgba(153, 102, 255, 0.5)",
														borderColor : "rgb(153, 102, 255)",
														borderWidth : 2,
														label : "Gelöscht",
														data : source
													},
													{
														backgroundColor : "rgba(240, 240, 0, 8)",
														borderColor : "rgb(255, 205, 86)",
														borderWidth : 2,
														label : "Manuell",
														data : source1
													},
													{
														backgroundcolor : "rgba(75, 192, 192, 0.2)",
														borderColor : "rgb(75, 192, 192)",
														borderWidth : 2,
														label : "Gescannt",
														data : source2
													},
													{
														backgroundColor : "rgba(255, 99, 132, 0.2)",
														borderColor : "rgb(255, 99, 132)",
														borderWidth : 2,
														label : "Gesamt",
														data : source3
													} ]
										}

									}, {});
						}).on('hidden.bs.modal', function(event) {
					// reset canvas size
					var modal = $(this);
					var canvas = modal.find('.modal-body canvas');
					canvas.attr('width', '568px').attr('height', '300px');
					// destroy modal
					$(this).data('bs.modal', null);
				});
	</script>
</body>
</html>