<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC>
<html>
<%@ page import="sql_queries.TopLiveQueries"%>
<%@ page import="sql_queries.DBUtils"%>
<%@page import="session.WebSessionInterval"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.*"%>
<head>
</head>
<body>

	<!-- This page is fetching data for the morelivedata.jsp page & livedata.jsp page -->


	<%
		// ======================= Request Parameters from URI =======================
		Integer delivID;
		if (request.getParameter("delivid") != null) {
			delivID = Integer.parseInt(request.getParameter("delivid"));
		} else {
			delivID = 1;
		}
		
		Integer lineID;
		if (request.getParameter("lineid") != null) {
			lineID = Integer.parseInt(request.getParameter("lineid"));
		} else {
			lineID = 1;
		}
		
		// ======================= Get Database Connection =======================
		String real = session.getServletContext().getRealPath("");
		Connection conn = DBUtils.GetLiveConnection(real);
		
		// ======================= Initialise variables for data =======================
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat dp = new SimpleDateFormat("HH:mm  dd.MM.yy");
		
		//livedata page:
		String pakproz = ""; //Percent of delivery thats already finished
		String prod = ""; //Productivity in percent
		long finparc; //Finished amount of parcels
		String exrest = ""; //Remaining titles for delivery
		String routerest = ""; //Remaining amount of routes
		String route2 = ""; //Actual route
		
		//both pages:
		String pakmin = ""; //Parcels per minute
		String end = ""; //Endtime prognosis of delivery	
		
		//morelivedata page:
		String exh = ""; //Titels per hour
		String status = ""; //State of plant: workmode / pausemode / errormode / …
		String replen = ""; //Replenishment
		String route = ""; //Routenumbers
		String starttour = ""; //Starttime of a route
		String routeex = ""; //Amount of titles for actual route
		String[] endgroup = new String[4]; //Endtime of routegroups (needs to be splitted)
		
		//don't needed?
		String endtour = ""; //end of a route (morelive) 
		
		int seq;
		int[] maxseq = { 18, 41, 39, 28 }; //Tour 1, 2, 3, 4
		
		// ======================= Initialise SQL-Statements =======================
		
		TopLiveQueries.clLiveQuery LiveQuery = new TopLiveQueries.clLiveQuery(conn, lineID);
		TopLiveQueries.clGroupQuery GroupQuery = new TopLiveQueries.clGroupQuery(conn, delivID, lineID);
		TopLiveQueries.clRouteQuery RouteQuery = new TopLiveQueries.clRouteQuery(conn, delivID);
		
		finparc = LiveQuery.fertig;
		
		// ======================= fetching data =======================
		
		//in the info table there is a field no, which contains data for betabright, to show special text
		//each number representating special texts, like if the parcels per minute or the state of the plant
		for (int x = 0; x < LiveQuery.No.size(); x++) {
			pakmin += (LiveQuery.No.elementAt(x) == -1) ? LiveQuery.Text.get(x) : "";
			exh += (LiveQuery.No.elementAt(x) == -5) ? LiveQuery.Text.get(x) : "";
			end += (LiveQuery.No.elementAt(x) == -2) ? LiveQuery.Text.get(x) : "";
			replen += (LiveQuery.No.elementAt(x) > 3) ? LiveQuery.Text.get(x) : "";
			status += (LiveQuery.No.elementAt(x) == -6) ? (LiveQuery.Text.get(x).split(":")[1]) : "";
			pakproz += (LiveQuery.No.elementAt(x) == -3) ? LiveQuery.Text.elementAt(x) : "";
			prod += (LiveQuery.No.elementAt(x) == -4) ? LiveQuery.Text.elementAt(x) : "";
		}
		routerest = "" + RouteQuery.routerest;
		
		// ======================= Route starttime / endtime / amount of titles =======================
		
		/* we need to put the html code inside of this variable,
		 * because we will change complete innerHTML of the table rows
		 * in morelivedata.jsp & livedata.jsp
		 */
		route += "<td class=\"colsum\">Nr.</td>";
		starttour += "<td class=\"colsum\">Start</td>";
		endtour += "<td class=\"colsum\">vorr. Ende</td>";
		routeex += "<td class=\"colsum\">Anz. Tourex</td>";
		
		for (int z = 0; z < RouteQuery.route.size(); z++) {
			route += "<td class=\"col3\">" + RouteQuery.route.elementAt(z) + "</td>";
			// if its the last element of RouteQuery.route don't print a comma at the end)
			route2 += ((z + 1 < RouteQuery.route.size()) ? (RouteQuery.route.elementAt(z) + ", ")
					: RouteQuery.route.elementAt(z));
			
			// instanziate SQL-STATEMENT
			TopLiveQueries.clPakQuery PakQuery = new TopLiveQueries.clPakQuery(conn, RouteQuery.route.elementAt(z),
					LiveQuery.DelivID.elementAt(lineID - 1), lineID);
			
			String hour = PakQuery.Hour;
			
			try {
				//if route hasn't started yet
				if ((hour == null || hour.isEmpty()) || (exh.isEmpty() || exh.contentEquals(""))) {
					starttour += "<td class=\"col3\">" + "not started yet" + "</td> ";
					endtour += "<td class=\"col3\">" + "not started yet" + "</td> ";
					routeex += "<td class=\"col3\">" + PakQuery.exalltour + "</td> ";
				} else {
					java.util.Date x = df.parse(hour);
					java.util.Date timenow = new java.util.Date();
					
					//get starttime & endtime of each route
					int extour = PakQuery.extour;
					double exempl = extour / Double.parseDouble(exh); //amount of titles / amount of titles / h = h
					long millisekunden = timenow.getTime() + (long) (exempl * (60000 * 60));
					java.util.Date date = new java.util.Date(millisekunden);
					
					starttour += "<td class=\"col3\">" + dp.format(x).toString() + "</td> ";
					endtour += "<td class=\"col3\">" + dp.format(date).toString() + "</td> ";
					routeex += "<td class=\"col3\">" + PakQuery.exalltour + "</td> ";
				}
			} catch (Exception ex) {
				ex.printStackTrace();
			}
			exrest = "" + PakQuery.exrest;
		}
		
		// ======================= routegroup starttime / endtime =======================
		
		for (int i = 0; i < 4; i++) {
			
			//actual routegroup hasn't started yeat
			if (exh.isEmpty() || exh.contentEquals("")) {
				endgroup[i] = "";
			} else {
				
				// ======================= actual route is the last route of the routegroup =======================
				if ((maxseq[i]) == GroupQuery.seq.elementAt(0)) {
					TopLiveQueries.clGroupQuery2 GroupQuery2 = new TopLiveQueries.clGroupQuery2(conn, delivID,
							lineID, GroupQuery.seq.elementAt(0));
					
					// instanziate SQL-STATEMENT
					TopLiveQueries.clPakQuery PakQuer = new TopLiveQueries.clPakQuery(conn, GroupQuery2.route,
							LiveQuery.DelivID.elementAt(lineID - 1), lineID);
					try {
						
						try {
							java.util.Date timenow = new java.util.Date();
							int extour = PakQuer.extour;
							double stunde = extour / Double.parseDouble(exh);
							long millisekunden = timenow.getTime() + (long) (stunde * (60000 * 60));
							java.util.Date date = new java.util.Date(millisekunden);
							endgroup[i] = dp.format(date).toString();
						} catch (Exception ex) {
							ex.printStackTrace();
						}
						
					} catch (Exception e) {
						e.printStackTrace();
					}
					
				}
				// ======================= actual route is something in between =======================
				else if ((maxseq[i]) > GroupQuery.seq.elementAt(0)) {
					try {
						TopLiveQueries.clGroupQuery2 GroupQuery2 = new TopLiveQueries.clGroupQuery2(conn, delivID,
								lineID, maxseq[i]);
						java.util.Date timenow = new java.util.Date();
						long extour = GroupQuery2.groupexrest;
						double stunde = extour / Double.parseDouble(exh);
						long millisekunden = timenow.getTime() + (long) (stunde * (60000 * 60));
						java.util.Date date = new java.util.Date(millisekunden);
						endgroup[i] = dp.format(date).toString();
					} catch (Exception ex) {
						ex.printStackTrace();
					}
				}
				
				// ======================= actuale routegroup is finished =======================
				else if ((maxseq[i]) < GroupQuery.seq.elementAt(0)) {
					
					TopLiveQueries.clGroupQuery2 GroupQuery2 = new TopLiveQueries.clGroupQuery2(conn, delivID,
							lineID, maxseq[i]);
					
					TopLiveQueries.clPakQuery PakQuer = new TopLiveQueries.clPakQuery(conn, GroupQuery2.route,
							LiveQuery.DelivID.elementAt(lineID - 1), lineID);
					
					String temp = GroupQuery2.endgroup;
					try {
						try {
							java.util.Date x = df.parse(temp);
							endgroup[i] = "&#10003; " //Check Symbol
									+ dp.format(x).toString();
						} catch (Exception ex) {
							ex.printStackTrace();
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}
		
		// ======================= outprint the result in a string with a separator =======================
		String sep = "|";
		
		out.println(pakmin + sep + exh + sep + end + sep + status + sep + replen + sep + route + sep
				+ (pakproz.isEmpty() ? "0" : pakproz) + sep + (prod.isEmpty() ? "0" : prod) + sep + finparc + sep
				+ starttour + sep + endtour + sep + routeex + sep + exrest + sep + routerest + sep
				+ Arrays.toString(endgroup) + sep + route2);
		conn.close();
	%>
</body>
</html>