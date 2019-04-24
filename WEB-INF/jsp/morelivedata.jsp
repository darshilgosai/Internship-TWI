<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC >
<%@ page import="sql_queries.DBUtils"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%-- <%@page import="org.jfree.data.category.DefaultCategoryDataset"%> --%>
<%@page import="session.WebSessionInterval"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html lang="en">
<head>
<meta name="viewport" content="width = device-width">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="author" content="Darshil Gosai - TWI GmbH">
<title>Live-Daten</title>
<jsp:include page="/WEB-INF/jsp/include/includeMenu.jsp" />
<link rel="stylesheet" type="text/css" href="toolkit-inverse.min.css"
	title="dark">
<link rel="alternate stylesheet" type="text/css"
	href="toolkit-light.min.css" title="light">
</head>

<!-- This page displays more information about the livedata -->
<!-- The data is provided from datasync.jsp. -->
<!-- If there is need to change the table classes or something, please check to change it in datasync.jsp also. -->

<%
	//======================= Get Information from the Page-URL ======================= 
	Integer lineID = (int) Integer.parseInt(request.getParameter("lineid"));
	Integer delivID = (int) Integer.parseInt(request.getParameter("delivid"));
	// ================================================================================
%>
<body>
	<nav aria-label="breadcrumb">
		<ol class="breadcrumb">
			<li class="breadcrumb-item"><a
				href="${pageContext.request.contextPath}/index">Home</a></li>
			<li class="breadcrumb-item"><a
				href="${pageContext.request.contextPath}/livedata">LIVE DATA</a></li>
			<li class="breadcrumb-item active" aria-current="page">MORE</li>
		</ol>
	</nav>

	<div>
		<span class="clock"></span> <span id="date"
			style="float: right; font-size: x-large"></span>
	</div>
	<hr>
	<div class="container-fluid">
		<h2>LIVE-Daten</h2>
		<div class="row justify-content-center">
			<div>
				<table class="table table-hover table-bordered table-responsive">
					<caption>laufende Touren</caption>
					<tr id="route">
					</tr>
					<tr id="startroute">
					</tr>
					<tr id="routeend">
					</tr>
					<tr id="routeex">
					</tr>
				</table>
			</div>

			<div class="d-inline">&nbsp;</div>

			<div>
				<table class="table table-hover table-bordered table-responsive">
					<caption>Tourengruppen</caption>
					<tr>
						<td class="colsum">Nr.</td>
						<td class="col3">vorr. Ende</td>
					</tr>
					<tr>
						<td class="colsum">1</td>
						<td class="col3" id="1"></td>
					</tr>
					<tr>
						<td class="colsum">2</td>
						<td class="col3" id="2"></td>
					</tr>
					<tr>
						<td class="colsum">3</td>
						<td class="col3" id="3"></td>
					</tr>
					<tr>
						<td class="colsum">4</td>
						<td class="col3" id="4"></td>
					</tr>
				</table>
			</div>

			<div class="d-inline">&nbsp;</div>

			<div>
				<table class="table table-hover table-bordered table-responsive">
					<caption>Status</caption>
					<tr>
						<td class="colsum">Status</td>
						<td class="col3" id="status"></td>
					</tr>
					<tr>
						<td class="colsum">Endzeitprognose</td>
						<td class="col3" id="end"></td>
					</tr>
					<tr>
						<td class="colsum">Versand-ID</td>
						<td class="col3" id="delivid"><%=delivID%></td>
					</tr>
					<tr>
						<td class="colsum">Pakete/min</td>
						<td class="col3" id="pak"></td>
					</tr>
					<tr>
						<td class="colsum">Ex/h</td>
						<td class="col3" id="exh"></td>
					</tr>
					<tr>
						<td class="colsum">Nachschub</td>
						<td class="col3" id="replen">Spiegel, H&ouml;r zu</td>
					</tr>
				</table>
			</div>

			<hr noshade width="100%" size="2">
			<%
				java.util.Date date = new java.util.Date();
				SimpleDateFormat output = new SimpleDateFormat("yyyy");
			%>
			<table>
				<tr>
					<td id="time" align="left">&copy; <%=output.format(date)%>,
						TWI GmbH
					</td>

				</tr>
			</table>
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

	<script>
		/* 	========================= Intervalfunction to get data every 10 seconds =============================== */
		var myVar = setInterval(function refresh() {
			var str;
			var str2;
			var res;
			var temp2;
			var temp;
			var xhttp;
			xhttp = new XMLHttpRequest();
			xhttp.onreadystatechange = function() {
				if (this.readyState == 4 && this.status == 200) {
					str = this.responseText;
					res = str.split("|");
					/* parcels per minute */
					document.getElementById("pak").innerHTML = res[0];
					/* titles per hour */
					document.getElementById("exh").innerHTML = res[1];
					/* endtime prognose of delivery */
					document.getElementById("end").innerHTML = res[2];
					/* work-, pause-, error-, ... - mode */
					document.getElementById("status").innerHTML = res[3];
					/* commented out, because of replenishment is not in database in the moment */
					/* document.getElementById("replen").innerHTML = res[4]; */
					/* routenumbers */
					document.getElementById("route").innerHTML = res[5];
					/* starttime of a route */
					document.getElementById("startroute").innerHTML = res[9];
					/* titles per route */
					document.getElementById("routeex").innerHTML = res[11];
					/* endgroup is an array.toString() result, so there are brackets, we don't need */
					str2 = res[14];
					temp = str2.replace('[', "").replace(']', "");
					temp2 = temp.split(",");
					/* endtime of routegroup 1 */
					document.getElementById("1").innerHTML = temp2[0];
					var tmp = res[2];
					var tmp2 = temp2[1].split(" ");
					var tmp3 = tmp2[3];
					tmp += " " + tmp3;
					/* endtime of delivery?????? */
					document.getElementById("2").innerHTML = tmp;
					/* endtime of routegroup 3 */
					document.getElementById("3").innerHTML = temp2[2];
					/* endtime of routegroup 4 */
					document.getElementById("4").innerHTML = temp2[3];
				}
			};
			var pfad = "datasync?delivid=" +
	<%=delivID%>
		+ "&lineid="
					+
	<%=lineID%>
		+ "";
			xhttp.open("GET", pfad, true);
			xhttp.send();
		}, 10000);

		/* 	========================= to get data at window load =============================== */
		window.onload = function myFunc() {
			var str;
			var str2;
			var res;
			var temp2;
			var temp;
			var xhttp;
			xhttp = new XMLHttpRequest();
			xhttp.onreadystatechange = function() {
				if (this.readyState == 4 && this.status == 200) {
					str = this.responseText;
					res = str.split("|");
					/* parcels per minute */
					document.getElementById("pak").innerHTML = res[0];
					/* titles per hour */
					document.getElementById("exh").innerHTML = res[1];
					/* endtime prognose of delivery */
					document.getElementById("end").innerHTML = res[2];
					/* work-, pause-, error-, ... - mode */
					document.getElementById("status").innerHTML = res[3];
					/* commented out, because of replenishment is not in database in the moment */
					/* document.getElementById("replen").innerHTML = res[4]; */
					/* routenumbers */
					document.getElementById("route").innerHTML = res[5];
					/* starttime of a route */
					document.getElementById("startroute").innerHTML = res[9];
					/* titles per route */
					document.getElementById("routeex").innerHTML = res[11];
					//endgroup is an array.toString() result, so there are brackets, we don't need
					str2 = res[14];
					temp = str2.replace('[', "").replace(']', "");
					temp2 = temp.split(",");
					/* endgroup is an array.toString() result, so there are brackets, 
					 * which we don't need */
					document.getElementById("1").innerHTML = temp2[0];//routegroup 1
					//parse endtime of delivery
					var tmp = res[2]; //16:11
					var tmp2 = temp2[1].split(" "); //✓ 15:37 09.02.18.tosplit = ,15:21,,27.02.18
					/* tmp2 = 15:21 */
					var tmp3 = tmp2[3]; // 27.02.18
					tmp += " " + tmp3;
					document.getElementById("2").innerHTML = tmp;//endtime of delivery with datetime of endtime routegroup
					/* endtime of routegroup 3 */
					document.getElementById("3").innerHTML = temp2[2];
					/* endtime of routegroup 4 */
					document.getElementById("4").innerHTML = temp2[3];
				}
			};
			var pfad = "datasync?delivid=" +
	<%=delivID%>
		+ "&lineid="
					+
	<%=lineID%>
		+ "";
			xhttp.open("GET", pfad, true);
			xhttp.send();

			/* 	========================= Cookie for styleswitcher =============================== */
			var cookie = readCookie("style");
			var title = cookie ? cookie : getPreferredStyleSheet();
			if ((title == null) || (title == undefined)) {
				setActiveStyleSheet('dark');
			} else {
				setActiveStyleSheet(title);
			}
		}

		/* 	========================= CLOCK =============================== */

		function clock() {// We create a new Date object and assign it to a variable called "time".
			var time = new Date(),

			// Access the "getHours" method on the Date object with the dot accessor.
			hours = time.getHours(),

			// Access the "getMinutes" method with the dot accessor.
			minutes = time.getMinutes(),

			seconds = time.getSeconds();

			document.querySelectorAll('.clock')[0].innerHTML = clock(hours)
					+ ":" + clock(minutes) + ":" + clock(seconds);

			function clock(standIn) {
				if (standIn < 10) {
					standIn = '0' + standIn
				}
				return standIn;
			}
		}
		setInterval(clock, 1000);

		var today = new Date();

		var day = today.getDate();
		var month = today.getMonth() + 1;
		var year = today.getFullYear();

		if (day < 10) {
			day = '0' + day
		}
		if (month < 10) {
			month = '0' + month
		}

		var out = document.getElementById("date");

		out.innerHTML = day + "/" + month + "/" + year;
	</script>
</body>
</html>