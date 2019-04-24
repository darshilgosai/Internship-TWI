<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<%@ page import="sql_queries.DBUtils"%>
<%@ page import="sql_queries.AeroQueries"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.sql.*"%>
<html lang="en">
<head>
<meta charset="UTF-8" http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width = device-width, initial-scale=1">
<meta name="author" content="Darshil Gosai - TWI GmbH">
<title>TWI Cockpit - AERO</title>
<link rel="stylesheet" type="text/css" title="dark"
	href="toolkit-inverse.min.css">
<link rel="alternate stylesheet" type="text/css" title="light"
	href="toolkit-light.min.css">
<jsp:include page="/WEB-INF/jsp/include/includeMenu.jsp" />
</head>
<body>

	<!-- This page displays statistics from a specific AERO-Machine at a specific warehouse -->


	<%
		// ======================= Get Information from the Page-URL ======================= 
		Integer WarehouseIndex = 0;
		Integer DelivID = 0;

		if (request.getParameter("warehouse") == null) {
			WarehouseIndex = 23;
		} else {
			WarehouseIndex = (int) Integer.parseInt(request.getParameter("warehouse"));
		}
		if (request.getParameter("delivid") == null) {
			DelivID = 23;
		} else {
			DelivID = (int) Integer.parseInt(request.getParameter("delivid"));
		}

		// ======================= Get Database Connection =======================
		String real = session.getServletContext().getRealPath("");
		Connection conn = DBUtils.GetAeroConnection(real);

		// ======================= Get Necessary Data-Objects ======================= 
		AeroQueries.clCntQuery CntQuery = new AeroQueries.clCntQuery(conn, DelivID, WarehouseIndex);
		AeroQueries.clTimeQuery TimeQuery = new AeroQueries.clTimeQuery(conn, DelivID, WarehouseIndex);
		AeroQueries.clCompanyIndex Index = new AeroQueries.clCompanyIndex(conn, WarehouseIndex);
		AeroQueries.clContQuery ContQuery = new AeroQueries.clContQuery(conn, DelivID, WarehouseIndex,
				TimeQuery.LineMinutes);
		AeroQueries.clCharts Charts = new AeroQueries.clCharts(conn, TimeQuery.Startdate, WarehouseIndex);

		// ======================= Fetching Data for Charts =======================
		String kont = "";
		String exem = "";
		String id = "";
		String pack = "";
		String kund = "";
		String obj = "";

		for (int i = 0; i < Charts.vDatum.size(); i++) {
			if (i == Charts.vDatum.size() - 1) {
				kont += (Charts.vKontakte.get(i));
				exem += (Charts.vExemplare.get(i));
				id += ("" + Charts.vDeliveryId.get(i));
				pack += (Charts.vPakete.get(i));
				kund += (Charts.vKunden.get(i));
				obj += (Charts.vObjekte.get(i));
			} else {
				kont += (Charts.vKontakte.get(i) + ",");
				exem += (Charts.vExemplare.get(i) + ",");
				id += ("" + Charts.vDeliveryId.get(i) + ",");
				pack += (Charts.vPakete.get(i) + ",");
				kund += (Charts.vKunden.get(i) + ",");
				obj += (Charts.vObjekte.get(i) + ",");
			}
		}
		// =====================================================================
	%>
	<nav aria-label="breadcrumb">
		<ol class="breadcrumb">
			<li class="breadcrumb-item"><a
				href="${pageContext.request.contextPath}/index">Home</a></li>
			<li class="breadcrumb-item"><a
				href="${pageContext.request.contextPath}/aero">AERO</a></li>
			<li class="breadcrumb-item"><a
				href="${pageContext.request.contextPath}/compaero?warehouse=<%=WarehouseIndex%>">COMPAERO</a></li>
			<li class="breadcrumb-item active" aria-current="page">DELIVAERO</li>
		</ol>
	</nav>
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-5 sidebar">
				<%-- <a
					href="${pageContext.request.contextPath}/compaero?<%=WarehouseIndex%>">Zur&uuml;ck
				</a> <br> <br> --%>
			</div>
			<div class="col-md-4 content">
				<div class="table-responsive">
					<div class="content">
						<div class="dashhead">
							<div class="dashhead-titles">
								<h2 class="dashhead-title"><%=CntQuery.MachineType%>
									<%=DelivID%></h2>
								<h1 class="dashhead-subtitle"><%=Index.Company%>
									<%=Index.Location%></h1>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="row justify-content-center">

			<div class="d-inline">
				<table class="table table-hover table-bordered table-responsive">
					<tbody>
						<tr>
							<td><span class="icon icon-calendar"></span> Datum</td>
							<td><%=TimeQuery.Startdate%></td>
						</tr>
						<tr>
							<td>Kontakte</td>
							<td><%=CntQuery.Kontakte%></td>
						</tr>
						<tr>
							<td><span class="icon icon-layers"> Exemplare</span></td>
							<td><%=CntQuery.Exemplare%></td>
						</tr>
						<tr>
							<td>Versand-ID</td>
							<td><%=DelivID%></td>
						</tr>
						<tr>
							<td><span class="icon icon-time-slot"></span> Startzeit</td>
							<td><%=TimeQuery.StartLbl%></td>
						</tr>
						<tr>
							<td><span class="icon icon-time-slot"></span> Endzeit</td>
							<td><%=TimeQuery.EndLbl%></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="d-inline">&nbsp;</div>
			<div class="d-inline">
				<table class="table table-hover table-bordered table-responsive">
					<tbody>
						<tr>
							<td><span class="icon icon-man"> Z&auml;hler/innen</span></td>
							<td><%=ContQuery.picker%></td>
						</tr>
						<tr>
							<td><span class="icon icon-clock"></span> Arbeitszeit</td>
							<td><%=TimeQuery.ArbeitszeitLbl%></td>
						</tr>
						<tr>
							<td><span class="icon icon-controller-paus"></span>
								Pausenzeit</td>
							<td><%=TimeQuery.PausezeitLbl%></td>
						</tr>
						<tr>
							<td><span class="icon icon-block"></span> Unterbrechungen</td>
							<td><%=TimeQuery.UnterbrechungLbl%></td>
						</tr>
						<tr>
							<td>Pakete/min</td>
							<td><%=ContQuery.LinePakProMinLbl%></td>
						</tr>
						<tr>
							<td>Expl./h/Z&auml;hler</td>
							<td><%=ContQuery.LineExProStundeProZaehlerLbl%></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="d-inline">&nbsp;</div>
			<div class="d-inline">
				<table class="table table-hover table-bordered table-responsive">
					<tbody>
						<tr>
							<td>Expl./h</td>
							<td><%=ContQuery.LineExProStundeLbl%></td>
						</tr>
						<tr>
							<td>Kunden</td>
							<td><%=CntQuery.Kunden%></td>
						</tr>
						<tr>
							<td><span class="icon icon-dropbox"> Pakete</span></td>
							<td><%=ContQuery.LinePakCntLbl%></td>
						</tr>
						<tr>
							<td>Expl./Kontakt</td>
							<td><%=CntQuery.ExProKont%></td>
						</tr>
						<tr>
							<td><span class="icon icon-open-book"> Titel</span></td>
							<td><%=CntQuery.Objekte%></td>
						</tr>
						<tr>
							<td>Produktivit&auml;t</td>
							<td><%=ContQuery.LineProdLbl%></td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 	// ======================= Charts  ======================= -->
			<div class="modal fade" id="modKont" tabindex="-1" role="dialog"
				aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close ml-0" data-dismiss="modal">
								<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title" id="exampleModalLabel">Kontakte/Exemplare</h4>
						</div>
						<div class="modal-body">
							<canvas id="canvas" width="568" height="300"></canvas>
						</div>
					</div>
				</div>
			</div>
			<div class="modal fade" id="modKun" tabindex="-1" role="dialog"
				aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close ml-0" data-dismiss="modal">
								<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title" id="exampleModalLabel">Kunden/Pakete</h4>
						</div>
						<div class="modal-body">
							<canvas id="canvas" width="568" height="300"></canvas>
						</div>
					</div>
				</div>
			</div>
			<div class="modal fade" id="modTit" tabindex="-1" role="dialog"
				aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close ml-0" data-dismiss="modal">
								<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title" id="exampleModalLabel">Titel</h4>
						</div>
						<div class="modal-body">
							<canvas id="canvas" width="568" height="300"></canvas>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="row justify-content-center hr mt-2">
			<a href="#" data-toggle="modal" data-target="#modKont"
				data-source=<%=kont%> data-source1=<%=exem%> data-source2=<%=id%>
				class="btn btn-primary" role="button"> <span
				class="icon icon-layers"></span> Kontakte / Exemplare
			</a>
		</div>
		<div class="row justify-content-center hr mt-2">
			<a href="#" data-toggle="modal" data-target="#modKun"
				data-source=<%=pack%> data-source1=<%=kund%> data-source2=<%=id%>
				class="btn btn-primary" role="button"> <span
				class="icon icon-dropbox"></span> Kunden/Pakete
			</a>
		</div>
		<div class="row justify-content-center hr mt-2">
			<a href="#" data-toggle="modal" data-target="#modTit"
				data-source=<%=obj%> data-source2=<%=id%> class="btn btn-primary"
				role="button"> <span class="icon icon-open-book"></span> Titel
			</a>
		</div>


		<div class="row">
			<canvas id="Exemplare"></canvas>
			<canvas id="KundPak"></canvas>
			<canvas id="Titel"></canvas>
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
	<!-- sorting tables -->
	<script src="datatables.min.js"></script>
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
	<%for (int i = 0; i < Charts.vDatum.size(); i++) {
				out.print(Charts.vDeliveryId.get(i) + ",");
			}%>
		],
											datasets : [
													{
														backgroundcolor : "rgba(153, 102, 255, 0.5)",
														borderColor : "rgb(153, 102, 255)",
														borderWidth : 2,
														label : "Kontakte",
														data : source
													},
													{
														backgroundColor : "rgba(240, 240, 0, 8)",
														borderColor : "rgb(255, 205, 86)",
														borderWidth : 2,
														label : "Exemplare",
														data : source1
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

		//===================================== H-BAR CHART ===========================================

		$('#modKun')
				.on(
						'shown.bs.modal',
						function(event) {
							var link = $(event.relatedTarget);
							// get data source
							var source = link.attr('data-source').split(',');
							var source1 = link.attr('data-source1').split(',');
							// get title
							var title = link.html();
							var modal = $(this);
							var canvas = modal.find('.modal-body canvas');
							modal.find('.modal-title').html(title);
							var ctx = canvas[0].getContext("2d");
							var chart = new Chart(
									ctx,
									{
										type : 'horizontalBar',
										data : {
											labels : [
	<%for (int i = 0; i < Charts.vDatum.size(); i++) {
				out.print(Charts.vDeliveryId.get(i) + ",");
			}%>
		],
											datasets : [
													{
														backgroundcolor : "rgba(75, 192, 192, 0.2)",
														borderColor : "rgb(75, 192, 192)",
														borderWidth : 2,
														label : "Kunden",
														data : source
													},
													{
														backgroundColor : "rgba(255, 99, 132, 0.2)",
														borderColor : "rgb(255, 99, 132)",
														borderWidth : 2,
														label : "Pakete",
														data : source1
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

		//===================================== LINE CHART ===========================================

		$('#modTit')
				.on(
						'shown.bs.modal',
						function(event) {
							var link = $(event.relatedTarget);
							// get data source
							var source = link.attr('data-source').split(',');
							// get title
							var title = link.html();
							var modal = $(this);
							var canvas = modal.find('.modal-body canvas');
							modal.find('.modal-title').html(title);
							var ctx = canvas[0].getContext("2d");
							var chart = new Chart(
									ctx,
									{
										type : 'line',
										data : {
											labels : [
	<%for (int i = 0; i < Charts.vDatum.size(); i++) {
				out.print(Charts.vDeliveryId.get(i) + ",");
			}%>
		],
											datasets : [ {
												backgroundcolor : "rgba(153, 102, 255, 0.5)",
												borderColor : "rgb(153, 102, 255)",
												borderWidth : 2,
												label : "Titel",
												data : source
											} ]
										},
										options : {
											responsive : true,
											title : {
												display : true,
												text : 'Titel'
											},
											tooltips : {
												mode : 'index',
												intersect : false,
											},
											hover : {
												mode : 'nearest',
												intersect : true
											},
											scales : {
												xAxes : [ {
													display : true,
													scaleLabel : {
														display : true,
														labelString : 'DelivID'
													}
												} ],
												yAxes : [ {
													display : true,
													scaleLabel : {
														display : true,
														labelString : 'Titel'
													}
												} ]
											}
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