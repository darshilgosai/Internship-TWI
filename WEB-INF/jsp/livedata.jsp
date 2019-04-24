<%-- <%@ page import="org.jfree.data.xy.VectorSeries"%> --%>
<%@ page
	import="org.eclipse.jdt.internal.compiler.flow.SwitchFlowContext"%>
<%@ page import="org.eclipse.jdt.internal.compiler.ast.SwitchStatement"%>
<%@ page import="java.awt.*"%>
<%@ page import="java.io.*"%>
<%-- <%@ page import="org.jfree.chart.*"%>
<%@ page import="org.jfree.chart.entity.*"%>
<%@ page import="org.jfree.chart.plot.*"%>
<%@ page import="org.jfree.data.category.*"%>
<%@ page import="org.jfree.data.general.*"%>
<%@ page import="org.jfree.util.*"%> --%>
<%@ page import="java.util.Vector"%>
<%@ page import="java.sql.*"%>
<%@ page import="sql_queries.DBUtils"%>
<%@ page import="sql_queries.TopLiveQueries"%>
<%@ page import="java.util.concurrent.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%-- <%@ page import="org.jfree.data.category.DefaultCategoryDataset"%> --%>
<%@ page import="session.WebSessionInterval"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC >
<html lang="en">
<head>
<meta content="text/html" charset="UTF-8">
<title>Live-Daten</title>
<jsp:include page="/WEB-INF/jsp/include/includeMenu.jsp" />
<link rel="stylesheet" type="text/css" href="toolkit-inverse.min.css"
	title="dark">
<link rel="alternate stylesheet" type="text/css"
	href="toolkit-light.min.css" title="light">

<meta name="author" content="Darshil Gosai - TWI GmbH">
</head>

<!-- This page displays livedata for TOP-Machine and fetches Data for it -->
<!-- The data is provided from datasync.jsp. -->
<!-- If there is need to change the table classes or something, please check to change it in datasync.jsp also. -->

<%
	//======================= Get Database Connection =======================
	String real = session.getServletContext().getRealPath("");
	Connection conn = DBUtils.GetLiveConnection(real);
	String route = "";
	int delivid;

	// ======================= Database-Queries ======================= 
	TopLiveQueries.clLineQuery LineQuery = new TopLiveQueries.clLineQuery(conn);
%>

<body onload="startTime()">

	<nav aria-label="breadcrumb">
		<ol class="breadcrumb">
			<li class="breadcrumb-item"><a
				href="${pageContext.request.contextPath}/index">Home</a></li>
			<li class="breadcrumb-item active" aria-current="page">LIVE DATA</li>
		</ol>
	</nav>


	<div>
		<span class="clock"></span> <span id="date"
			style="float: right; font-size: x-large"></span>
	</div>

	<hr />
	<div class="container-fluid">
		<h2>LIVE-Daten</h2>

		<div class="justify-content-around">

			<%
				try {
					int r = 0; //machinestate
					String[] p;
					boolean b = false;
					//	out.println("Numbers of Entry Showing : " + LineQuery.LineID.size());
					//	out.println(LineQuery.LineID.size());
					//	here write code for going to new line
			%>
			<span class="badge badge-warning" style="font-size: medium"> <%
 	out.println("Numbers of Entry Showing : " + LineQuery.LineID.size());
 %>
			</span>

			<%
				for (int i = 0; i < LineQuery.LineID.size(); i++) {
						int li = i; //actual lineid
						//initialize sql-statement
						TopLiveQueries.clLiveQuery LiveQuery = new TopLiveQueries.clLiveQuery(conn,
								LineQuery.LineID.elementAt(i));
			%>

			<div>
				<br>
				<table class="table table-hover table-bordered table-responsive">
					<thead><%=LineQuery.LineID.get(i)%>
						<%=LineQuery.Name.get(i)%>
					</thead>
					<tbody>
						<tr>
							<%
								int t = 0;
										int l = 0;
										while ((t < LiveQuery.Name.size()) & (l < LineQuery.LineID.size() - 1)) {
											for (int w = 0; w < LiveQuery.No.size(); w++) {
												//get the state of the machine
												if (LiveQuery.No.elementAt(w) == -6) {
													p = LiveQuery.Text.get(w).split(":");
													r = Integer.parseInt(p[0]);
												}
											}
											if (LiveQuery.Text.isEmpty() || r == 0 || r == 5) { //machine: 0 = off, 5 = testmode
							%>
							<!-- Display if machine state is empty, or machine is off, or in testmode -->
							<!-- there are two tables to align the data for it  -->
							<td id="<%=li%>1" align="left" valign="bottom">&nbsp;</td>
							<td id="<%=li%>2" align="right" valign="bottom">&nbsp;</td>
						</tr>
					</tbody>
				</table>
			</div>
			<table class="table table-hover table-bordered table-responsive">
				<caption>&nbsp;</caption>
				<tr class="anlage" valign="middle">
					<td width="10%"></td>
				</tr>
			</table>
			<!---------------------------->
			<%
				} else if ((r == 1 || r == 2 || r == 3 || r == 4)) { //machine: 1=idle, 2 = works, 3 = pause, 4 = error
								if (LiveQuery.DelivID.isEmpty() || LiveQuery.DelivID.get(i) == null) {
									delivid = 1; //standard value for delivid
								} else {
									delivid = LiveQuery.DelivID.get(i);
								}
								int lineid = LineQuery.LineID.elementAt(i);
			%>
			<script>
			
			/* 	========================= Intervalfunction to get data every 0,5 seconds =============================== */
			
				var myVar = setInterval(
						function refresh() {		
							var str;
							var res;
							var xhttp;
							xhttp = new XMLHttpRequest();
							xhttp.onreadystatechange = function() {
								if (this.readyState == 4 && this.status == 200) {
									str = this.responseText; //text that is outprinted from datasync
									res = str.split("|");
									//state: idle 
									if (
			<%=r%>
				== 1) { 
										
										document.getElementById("fertig").innerHTML = res[8] //parcels finished
												+ " Pakete fertig";
										//li = actual lineid
										//document.getElementById(lineid1).innerHTML
										document.getElementById(
			<%=li%> 
				+ "1").innerHTML = "DelivID: "
												+
			<%=delivid%>
				+ ", "
												+ res[13]		//Remaining amount of routes
												+ " Touren, "
												+ res[12]		//Remaining titles for delivery
												+ " Expl.";
									} else {
										//document.getElementById(lineid2).innerHTML
								
										document.getElementById(
			<%=li%>
				+ "2").innerHTML = res[0]
												+ " P/M";
										document.getElementById(
			<%=li%>
				+ "1").innerHTML = "DelivID: "
												+
			<%=delivid%>
				+ " Tour: "
												+ res[15];		//actual route
										document.getElementById("string").innerHTML = res[6]	//Percent of delivery thats already finished
												+ " % fertig => Prod.: "
												+ res[7]		//productivity
												+ " => Endtime: "
												+ res[2];		//endtime
										document.getElementById("fertig").innerHTML = res[8]	//finished parcels
												+ " Pakete fertig";
									}
								}
							};
							//path to datasync.jsp with additional (required!!) data.
							var pfad = "datasync?delivid=" +
			<%=delivid%>
				+ "&lineid" +
			<%=lineid%>
				+ "";
				//open xhttprequest
							xhttp.open("GET", pfad, true);
				//send xhttprequest
							xhttp.send();
						}, 500); //function is first excecuted after 500 milliseconds, then again after each 500 milliseconds forever.
			</script>


			<table class="table table-hover table-bordered table-responsive">
				<tr>
					<td id="<%=li%>1" align="left" valign="bottom"></td>
					<td id="<%=li%>2" align="right" valign="bottom"></td>
				</tr>
			</table>

			<!-- #################################################################################################### -->




			<!-- #################################################################################################### -->
			<table class="table table-hover table-bordered table-responsive">
				<caption>&nbsp;</caption>
				<tr class="" valign="middle">
					<td width="10%" id="fertig"></td>
				</tr>
			</table>

			<br>

			<table class="table table-hover table-bordered table-responsive">
				<tr>
					<td align="left" valign="bottom" id="string"></td>
					<td>&nbsp;</td>
					<td align="right" valign="bottom"><a
						href="${pageContext.request.contextPath}/morelivedata?delivid=<%=delivid%>&lineid=<%=lineid%>"
						class="btn btn-primary" role="button">Weitere Informationen</a></td>
					<td>&nbsp;</td>
				</tr>
			</table>


			<%-- <div>
		<a href="${pageContext.request.contextPath}/morelivedata?delivid=<%=delivid%>&lineid=<%=lineid%>" 
			class="btn btn-primary" role="button">
			Weitere nformationen</a>
			
	</div>
	 --%>



			<br> <br> <br>
			<%
				}

							// ====================== End of else-if =========================
							//increase l & t to make sure, that only the lines that are working(!) and are still online are printed to the page
							l++;
							t++;
						} // ====================== End of while-loop =========================
					}

					// ====================== End of for-loop =========================
			%>
			<script>
		 		window.onload = function colorChange() {
			<%for (int x = 0; x < LineQuery.LineID.size(); x++) {   /* for every machine in every state */
					TopLiveQueries.clLiveQuery LiveQuer = new TopLiveQueries.clLiveQuery(conn,
							LineQuery.LineID.elementAt(x));
					for (int w = 0; w < LiveQuer.No.size(); w++) {
						if (LiveQuer.No.elementAt(w) == -6) {		/* state of the machine, stored as: number:text e.G. -1:53 */
							int temp;
							String[] parts = LiveQuer.Text.get(w).split(":");
							temp = Integer.parseInt(parts[0]);
							//switch statement, so only the right case will be executed...
							switch (temp) {
								case 0 :
									//off 
									for (int i = LineQuery.LineID.size(); i > 0; i--) {%>
									/* x = lineid, i = size of lineid, see line 119 to understand why we need this */
				var element = document.getElementById("" +
			<%=x%>    	
				+ ""
							+
			<%=i%>						
				);
				/* change background color of table left & right for actual line*/
					element.style.backgroundColor = "#EEE9E9"; //white
			<%}
			//break the execution of code, because case finished
									break;
								case 1 :
									//idle
									for (int i = LineQuery.LineID.size(); i > 0; i--) {%>
				var element = document.getElementById("" +
			<%=x%>
				+ ""
							+
			<%=i%>
				);
					element.style.backgroundColor = "#10F3EC"; //tuerkis
			<%}

									break;
								case 2 :
									//working
									for (int i = LineQuery.LineID.size(); i > 0; i--) {%>
				var element = document.getElementById("" +
			<%=x%>
				+ ""
							+
			<%=i%>
				);
					element.style.backgroundColor = "#0000CD"; //blue
			<%}

									break;
								case 3 :
									//pause
									for (int i = LineQuery.LineID.size(); i > 0; i--) {%>
				var element = document.getElementById("" +
			<%=x%>
				+ ""
							+
			<%=i%>
				);
					element.style.backgroundColor = "#7B68EE"; //purple
			<%}
									break;
								case 4 :
									//error
									for (int i = LineQuery.LineID.size(); i > 0; i--) {%>
				var element = document.getElementById("" +
			<%=x%>
				+ ""
							+
			<%=i%>
				);
					element.style.backgroundColor = "E77D7D"; //something like red
			<%}
									break;
								case 5 :
									//test
									for (int i = LineQuery.LineID.size(); i > 0; i--) {%>
				var element = document.getElementById("" +
			<%=x%>
				+ ""
							+
			<%=i%>
				);
					element.style.backgroundColor = "FFA500"; //orange
			<%}
									break;
								default :
									//default
									for (int i = LineQuery.LineID.size(); i > 0; i--) {%>
				var element = document.getElementById("" +
			<%=x%>
				+ ""
							+
			<%=i%>
				);
					element.style.backgroundColor = "8B8989"; //dark grey
			<%}
									break;
							}
						}
					}
				}%>
				} 
			</script>
			<%
				DBUtils.FreeConnection(conn);
				} catch (Exception ex) {
					ex.printStackTrace();
				}
				//create date to output it on the page
				java.util.Date date = new java.util.Date();
				SimpleDateFormat output = new SimpleDateFormat("yyyy");
			%>


			<br> <br>

		</div>

		<hr noshade width="100%" size="2">




		<table>
			<tr>
				<td id="time" align="left">&copy; <%=output.format(date)%>, TWI
					GmbH
				</td>

			</tr>
		</table>

	</div>
	<!-- ======================== Logout logic ======================== -->
	<c:url value="/logout" var="logoutUrl" />
	<form id="logout" action="${logoutUrl}" method="POST">
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
				standIn = '0' + standIn;
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