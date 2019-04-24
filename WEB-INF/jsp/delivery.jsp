<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC >
<%@page import="session.WebSessionInterval"%>
<%@page import="sql_queries.TopQueries"%>
<%-- <%@ page import="charts.Charts"%> --%>
<%@ page import="charts.CsvTop"%>
<%@ page import="sql_queries.DBUtils"%>
<%@ page import="java.sql.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="author" content="Darshil Gosai- TWI GmbH">
<title>TWI Cockpit - TOP/AERO</title>
<link rel="stylesheet" type="text/css" href="toolkit-inverse.css"
	title="dark">
<link rel="stylesheet" type="text/css" href="toolkit-light.min.css"
	title="light">
<link rel="stylesheet" type="text/css" href="jquery.dataTables.min.css">
<jsp:include page="/WEB-INF/jsp/include/includeMenu.jsp" />

<style type="text/css">
.iphone {
	display: none;
}

.pc {
	display: block;
}

@media ( max-width : 640px) {
	.iphone {
		display: block;
	}
	.pc {
		display: none;
	}
}
</style>
</head>
<body>

	<!-- This page displays statistics from a specific Top-Delivery -->

	<%
		// ======================= Get Database Connection =======================
		WebSessionInterval interval = new WebSessionInterval(session);
		String real = session.getServletContext().getRealPath("");
		Connection conn = DBUtils.GetTopConnection(real);

		// ======================= Get Information from the Page-URL ======================= 
		Integer ActDelivID;
		if (request.getParameter("delivid") == null) {
			ActDelivID = 1;
		} else {
			ActDelivID = (int) Integer.parseInt(request.getParameter("delivid"));
		}
		String sID = session.getId();
		String pathfile = real + "top.csv";
		String pathfile2 = real + "sevendayTop.csv";

		// ======================= Database-Queries ======================= 
		CsvTop CsvTop = new CsvTop(conn, ActDelivID, real, sID);		//creates .csv-Files for Top-Page

		TopQueries.clDelivQuery DelivQuery = new TopQueries.clDelivQuery(conn, ActDelivID);

		TopQueries.clTypQuery TypQuery = new TopQueries.clTypQuery(conn, ActDelivID);

		TopQueries.clCntQuery CntQuery = new TopQueries.clCntQuery(conn, ActDelivID);

		TopQueries.clTimeQuery TimeQuery = new TopQueries.clTimeQuery(conn, ActDelivID, TypQuery.ActLineID);

		TopQueries.clVBQuery VBQuery = new TopQueries.clVBQuery(conn, ActDelivID);

		TopQueries.clZoneQuery ZoneQuery = new TopQueries.clZoneQuery(conn, TypQuery.ActLineID, ActDelivID);

		TopQueries.clContQuery ContQuery = new TopQueries.clContQuery(conn, ActDelivID, TimeQuery.LineMinutes,
				ZoneQuery.WorkZones);

		TopQueries.clStatQuery StatQuery = new TopQueries.clStatQuery(conn, DelivQuery.StartDate);

		// ======================= Fetching Data for Charts =======================

		String kont = "";
		String exem = "";
		String id = "";
		String pack = "";
		String kund = "";
		String obj = "";
		for (int i = 0; i < StatQuery.vDatum.size(); i++) {
			if (i == StatQuery.vDatum.size() - 1) {
				kont += (StatQuery.vKontakte.get(i));
				exem += (StatQuery.vExemplare.get(i));
				id += ("" + StatQuery.vDeliveryId.get(i));
				pack += (StatQuery.vPakete.get(i));
				kund += (StatQuery.vKunden.get(i));
				obj += (StatQuery.vObjekte.get(i));
			} else {
				kont += (StatQuery.vKontakte.get(i) + ",");
				exem += (StatQuery.vExemplare.get(i) + ",");
				id += ("" + StatQuery.vDeliveryId.get(i) + ",");
				pack += (StatQuery.vPakete.get(i) + ",");
				kund += (StatQuery.vKunden.get(i) + ",");
				obj += (StatQuery.vObjekte.get(i) + ",");
			}
		}

		// ======================= Old Chart Files =======================

		// 		Charts.clChartTop chart1 = new Charts.clChartTop("Exemplare", ActDelivID, StatQuery.vExemplare,
		// 				StatQuery.vDeliveryId, real, sID);

		// 		Charts.clChartTop chart2 = new Charts.clChartTop("Titel", ActDelivID, StatQuery.vObjekte,
		// 				StatQuery.vDeliveryId, real, sID);

		// 		Charts.clChartTop chart3 = new Charts.clChartTop("Pakete", ActDelivID, StatQuery.vPakete,
		// 				StatQuery.vDeliveryId, real, sID);

		// 		Charts.clChartTop chart4 = new Charts.clChartTop("Kunden", ActDelivID, StatQuery.vKunden,
		// 				StatQuery.vDeliveryId, real, sID);

		// 		Charts.clChartTop chart5 = new Charts.clChartTop("Kontakte", ActDelivID, StatQuery.vKontakte,
		// 				StatQuery.vDeliveryId, real, sID);

		// =====================================================================
	%>

	<nav aria-label="breadcrumb">
		<ol class="breadcrumb">
			<li class="breadcrumb-item"><a
				href="${pageContext.request.contextPath}/index">Home</a></li>
			<li class="breadcrumb-item"><a
				href="${pageContext.request.contextPath}/top">TOP</a></li>
			<li class="breadcrumb-item active" aria-current="page">DELIVERY</li>
		</ol>
	</nav>
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-3 sidebar">
				<!-- ======================== Download .csv-Files for delivery statistics ======================== -->
				<a class="btn btn-info btn-block"
					href="<c:url value='/download/csv/top/${pageContext.session.id}'/>"
					class="btn btn-primary" role="button">Export 1 Day</a> <a
					class="btn btn-info btn-block"
					href="<c:url value='/download/csv/seventop/${pageContext.session.id}'/>"
					class="btn btn-primary" role="button">Export 7 Days</a>
				<!-- ============================================================================================= -->
			</div>
			<div class="col-md-9 content">
				<div class="table-responsive">
					<div class="col-md-9 content">
						<div class="dashhead">
							<div class="dashhead-titles">
								<h2 class="dashhead-title">
									TOP/AERO -
									<%=ActDelivID%>
								</h2>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<%-- <br>
	<table style="width: 80%">
		<tr>
			<!-- <td><a href="${pageContext.request.contextPath}/top">Zur&uuml;ck
			</a></td> -->
			<td>&nbsp;</td>

			<!-- ======================== Download .csv-Files for delivery statistics ======================== -->
			<td ALIGN="left"><a
				href="<c:url value='/download/csv/top/${pageContext.session.id}'/>"
				class="btn btn-primary" role="button">Export 1 Day</a></td>
			<td>&nbsp;</td>
			<td ALIGN="left"><a
				href="<c:url value='/download/csv/seventop/${pageContext.session.id}' />"
				class="btn btn-primary" role="button">Export 7 Days</a></td>

			<!-- ============================================================================================= -->
		</tr>
	</table>
	<hr /> --%>
	<div class="iphone">
		<table class="sample">
			<tr>
				<th colspan=3 height="60px">TOP/AERO - <%=ActDelivID%></th>
			</tr>
			<tr>
				<td><img class="col1" src="Datum.jpg" alt=""></td>
				<td class="col2">Datum</td>
				<td class="col3"><%=DelivQuery.StartDate%></td>
			</tr>
			<tr>
				<td><img class="col1" src="LKW.jpg" alt=""></td>
				<td class="col2">Versand</td>
				<td class="col3"><%=ActDelivID%></td>
			</tr>
			<tr>
				<td><img class="col1" src="LKW.jpg" alt=""></td>
				<td class="col2">Versand-Art</td>
				<td class="col3"><%=DelivQuery.DelivName%></td>
			</tr>
			<tr>
				<td><img class="col1" src="BILD.jpg" alt=""></td>
				<td class="col2">Titel</td>
				<td class="col3"><%=CntQuery.Objekte%></td>
			</tr>
			<tr>
				<td><img class="col1" src="Kiosk.jpg" alt=""></td>
				<td class="col2">Kunden</td>
				<td class="col3"><%=CntQuery.Kunden%></td>
			</tr>
			<tr>
				<td><img class="col1" src="fullbundle.png" alt=""></td>
				<td class="col2">Pakete</td>
				<td class="col3"><%=ContQuery.LinePakCntLbl%></td>
			</tr>
			<tr>
				<td><img class="col1" src="picker.jpg" alt=""></td>
				<td class="col2">Z&auml;hler/innen</td>
				<td class="col3"><%=ZoneQuery.PickerCntLbl%></td>
			</tr>
			<tr>
				<td><img class="col1" src="Hand.jpg" alt=""></td>
				<td class="col2">Kontakte</td>
				<td class="col3"><%=CntQuery.Kontakte%></td>
			</tr>
			<tr>
				<td><img class="col1" src="Zeitungen.jpg" alt=""></td>
				<td class="col2">Exemplare</td>
				<td class="col3"><%=CntQuery.Exemplare%></td>
			</tr>
			<tr>
				<td><img class="col1" src="ExKontakt.jpg" alt=""></td>
				<td class="col2">Expl./Kontakt</td>
				<td class="col3"><%=ContQuery.LineExProKontLbl%></td>
			</tr>
			<tr>
				<td><img class="col1" src="prod.jpg" alt=""></td>
				<td class="col2"><b>Produktivit&auml;t</b></td>
				<td class="col3"><b><%=ContQuery.LineProdLbl%> %</b></td>
			</tr>
			<tr>
				<th colspan=3 height="60px">TWI</th>
			</tr>
			<tr>
				<td><img class="col1" src="ampel-gruen.jpg" alt=""></td>
				<td class="col2">Start</td>
				<td class="col3"><%=TimeQuery.StartLbl%></td>
			</tr>
			<tr>
				<td><img class="col1" src="blue.jpg" alt=""></td>
				<td class="col2">1. Paket</td>
				<td class="col3"><%=ContQuery.FirstParcEndTimeLbl%></td>
			</tr>
			<tr>
				<td><img class="col1" src=" ampel-rot.jpg" alt=""></td>
				<td class="col2">Ende</td>
				<td class="col3"><%=TimeQuery.EndLbl%></td>
			</tr>
			<tr>
				<td><img class="col1" src="uhr.jpg" alt=""></td>
				<td class="col2">Arbeitszeit</td>
				<td class="col3"><%=TimeQuery.ArbeitszeitLbl%> h</td>
			</tr>
			<tr>
				<td><img class="col1" src="kaffee.jpg" alt=""></td>
				<td class="col2">Pausenzeit</td>
				<td class="col3"><%=TimeQuery.PausezeitLbl%> h</td>
			</tr>
			<tr>
				<td><img class="col1" src="stop.jpg" alt=""></td>
				<td class="col2">Unterbrechung</td>
				<td class="col3"><%=TimeQuery.UnterbrechungLbl%> h</td>
			</tr>
			<tr>
				<td><img class="col1" src="ExStd.jpg" alt=""></td>
				<td class="col2">Expl./h</td>
				<td class="col3"><%=ContQuery.LineExProStundeLbl%></td>
			</tr>
			<tr>
				<td><img class="col1" src="ExStdZaehler.jpg" alt=""></td>
				<td class="col2">Expl./h/Z&auml;hler</td>
				<td class="col3"><%=ContQuery.LineExProStundeProZaehlerLbl%></td>
			</tr>
			<tr>
				<td><img class="col1" src="PakMin.JPG" alt=""></td>
				<td class="col2">Pakete/min</td>
				<td class="col3"><%=ContQuery.LinePakProMinLbl%></td>
			</tr>
			<tr>
				<th colspan=3 height="60px">Vollballen</th>
			</tr>
			<tr>
				<td><img class="col1" src="fb_ext.jpg" alt=""></td>
				<td class="col2">Extern</td>
				<td class="col3"><%=VBQuery.VBExtern%> <b></b></td>
			</tr>
			<tr>
				<td><img class="col1" src="VBExExt.jpg" alt=""></td>
				<td class="col2">Exemplare Extern</td>
				<td class="col3"><%=VBQuery.VBExExtern%></td>
			</tr>
		</table>
	</div>
	<div class="pc">
		<h2>
			TOP/AERO -
			<%=ActDelivID%></h2>
		<table class="table3">
			<tr>
				<td><img class="col1" src="Datum.jpg" alt=""></td>
				<td class="col2">Datum</td>
				<td class="col3"><%=DelivQuery.StartDate%></td>

				<td width="60px"></td>

				<td><img class="col1" src="Hand.jpg" alt=""></td>
				<td class="col2">Kontakte</td>
				<td class="col3"><%=CntQuery.Kontakte%></td>

				<td width="60px"></td>

				<td><img class="col1" src="ampel-gruen.jpg" alt=""></td>
				<td class="col2">Start</td>
				<td class="col3"><%=TimeQuery.StartLbl%></td>

			</tr>
			<tr>
				<td><img class="col1" src="LKW.jpg" alt=""></td>
				<td class="col2">Versand-ID</td>
				<td class="col3"><%=ActDelivID%></td>

				<td width="60px"></td>

				<td><img class="col1" src="Zeitungen.jpg" alt=""></td>
				<td class="col2">Exemplare</td>
				<td class="col3"><%=CntQuery.Exemplare%></td>

				<td width="60px"></td>

				<td><img class="col1" src="blue.jpg" alt=""></td>
				<td class="col2">1. Paket fertig</td>
				<td class="col3"><%=ContQuery.FirstParcEndTimeLbl%></td>

			</tr>
			<tr>
				<td><img class="col1" src="LKW.jpg" alt=""></td>
				<td class="col2">Versand-Art</td>
				<td class="col3"><%=DelivQuery.DelivName%></td>

				<td width="60px"></td>

				<td><img class="col1" src="ExKontakt.jpg" alt=""></td>
				<td class="col2">Expl./Kontakt</td>
				<td class="col3"><%=ContQuery.LineExProKontLbl%></td>

				<td width="60px"></td>


				<td><img class="col1" src="ampel-rot.jpg" alt=""></td>
				<td class="col2">Ende</td>
				<td class="col3"><%=TimeQuery.EndLbl%></td>

			</tr>
			<tr>
				<td><img class="col1" src="picker.jpg" alt=""></td>
				<td class="col2">Z&auml;hler/innen</td>
				<td class="col3"><%=ZoneQuery.PickerCntLbl%></td>

				<td width="60px"></td>

				<td><img class="col1" src="ExStd.jpg" alt=""></td>
				<td class="col2">Expl./h</td>
				<td class="col3"><%=ContQuery.LineExProStundeLbl%></td>

				<td width="60px"></td>

				<td><img class="col1" src="uhr.jpg" alt=""></td>
				<td class="col2">Arbeitszeit</td>
				<td class="col3"><%=TimeQuery.ArbeitszeitLbl%></td>
			</tr>
			<tr>

				<td><img class="col1" src="BILD.jpg" alt=""></td>
				<td class="col2">Titel</td>
				<td class="col3"><%=CntQuery.Objekte%></td>

				<td width="60px"></td>

				<td><img class="col1" src="ExStdZaehler.jpg" alt=""></td>
				<td class="col2">Expl./h/Z&auml;hler</td>
				<td class="col3"><%=ContQuery.LineExProStundeProZaehlerLbl%></td>

				<td width="60px"></td>

				<td><img class="col1" src="kaffee.jpg" alt=""></td>
				<td class="col2">Pausenzeit</td>
				<td class="col3"><%=TimeQuery.PausezeitLbl%></td>
			</tr>
			<tr>
				<td><img class="col1" src="Kiosk.jpg" alt=""></td>
				<td class="col2">Kunden</td>
				<td class="col3"><%=CntQuery.Kunden%></td>

				<td width="60px"></td>

				<td><img class="col1" src="PakMin.JPG" alt=""></td>
				<td class="col2">Pakete/min</td>
				<td class="col3"><%=ContQuery.LinePakProMinLbl%></td>

				<td width="60px"></td>

				<td><img class="col1" src="stop.jpg" alt=""></td>
				<td class="col2">Unterbrechung</td>
				<td class="col3"><%=TimeQuery.UnterbrechungLbl%></td>
			</tr>
			<tr>

				<td><img class="col1" src="fullbundle.png" alt=""></td>
				<td class="col2">Pakete</td>
				<td class="col3"><%=ContQuery.LinePakCntLbl%></td>

				<td width="60px"></td>

				<td><img class="col1" src="prod.jpg" alt=""></td>
				<td class="col2">Produktivit&auml;t</td>
				<td class="col3"><%=ContQuery.LineProdLbl%> %</td>

				<td width="60px"></td>

				<td></td>
				<td></td>
				<td></td>

			</tr>
		</table>
		<BR>
		<hr noshade width="100%" size="2">

		<h2>Bundles</h2>
		<table class="table4">
			<tr>
				<td><img class="col1" src="fb_ext.jpg" alt=""></td>
				<td class="col2">Extern</td>
				<td class="col3"><%=VBQuery.VBExtern%> <b></b></td>
			</tr>
			<tr>
				<td><img class="col1" src="VBExExt.jpg" alt=""></td>
				<td class="col2">Exemplare Extern</td>
				<td class="col3"><%=VBQuery.VBExExtern%></td>

				<td width="60px"></td>
			</tr>
		</table>

	</div>
	<BR>
	<hr noshade width="100%" size="2">
	<BR>

	<%--	Old Chart-Files --%>
	<%--	<h2>7-Tage-R&uuml;ckblick</h2> --%>
	<%-- 	<c:url var="one" value="<%=chart1.f.getName()%>" /> --%>
	<%-- 	<c:url var="two" value="<%=chart2.f.getName()%>" /> --%>
	<%-- 	<c:url var="three" value="<%=chart3.f.getName()%>" /> --%>
	<%-- 	<c:url var="four" value="<%=chart4.f.getName()%>" /> --%>
	<%-- 	<c:url var="five" value="<%=chart5.f.getName()%>" /> --%>

	<!-- 	<div class="iphone"> -->
	<!-- 		<img alt="" -->
	<%-- 			src="<c:url value='/download/one/${pageContext.session.id}/${one}'/>"> --%>
	<!-- 	</div> -->
	<!-- 	<div class="pc"> -->

	<!-- 		<img alt="" -->
	<%-- 			src="<c:url value='/download/one/${pageContext.session.id}/${one}'/>"> --%>
	<!-- 	</div> -->

	<!-- 	<br> -->
	<!-- 	<br> -->

	<!-- 	<div class="iphone"> -->
	<!-- 		<img alt="" -->
	<%-- 			src="<c:url value='/download/two/${pageContext.session.id}/${two}'/>"> --%>
	<!-- 	</div> -->
	<!-- 	<div class="pc"> -->
	<!-- 		<img alt="" -->
	<%-- 			src="<c:url value='/download/two/${pageContext.session.id}/${two}'/>"> --%>
	<!-- 	</div> -->

	<!-- 	<br> -->
	<!-- 	<br> -->

	<!-- 	<div class="iphone"> -->
	<!-- 		<img alt="" -->
	<%-- 			src="<c:url value='/download/three/${pageContext.session.id}/${three}'/>"> --%>
	<!-- 	</div> -->
	<!-- 	<div class="pc"> -->
	<!-- 		<img alt="" -->
	<%-- 			src="<c:url value='/download/three/${pageContext.session.id}/${three}'/>"> --%>
	<!-- 	</div> -->

	<!-- 	<br> -->
	<!-- 	<br> -->

	<!-- 	<div class="iphone"> -->
	<!-- 		<img alt="" -->
	<%-- 			src="<c:url value='/download/four/${pageContext.session.id}/${four}'/>"> --%>
	<!-- 	</div> -->
	<!-- 	<div class="pc"> -->
	<!-- 		<img alt="" -->
	<%-- 			src="<c:url value='/download/four/${pageContext.session.id}/${four}'/>"> --%>
	<!-- 	</div> -->

	<!-- 	<br> -->
	<!-- 	<br> -->

	<!-- 	<div class="iphone"> -->
	<!-- 		<img alt="" -->
	<%-- 			src="<c:url value='/download/five/${pageContext.session.id}/${five}'/>"> --%>
	<!-- 	</div> -->
	<!-- 	<div class="pc"> -->
	<!-- 		<img alt="" -->
	<%-- 			src="<c:url value='/download/five/${pageContext.session.id}/${five}'/>"> --%>
	<!-- 	</div> -->


	<!-- 	// ======================= Charts  ======================= -->
	<h2>7-Tage-R&uuml;ckblick</h2>


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

	<!-- =========================================================================================================== -->




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
							// get title
							var title = link.html();
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
	<%for (int i = 0; i < StatQuery.vDatum.size(); i++) {
				out.print(StatQuery.vDeliveryId.get(i) + ",");
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
	<%for (int i = 0; i < StatQuery.vDatum.size(); i++) {
				out.print(StatQuery.vDeliveryId.get(i) + ",");
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
	<%for (int i = 0; i < StatQuery.vDatum.size(); i++) {
				out.print(StatQuery.vDeliveryId.get(i) + ",");
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
														labelString : 'Value'
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