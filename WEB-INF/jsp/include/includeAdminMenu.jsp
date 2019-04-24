<%@ page import="sql_queries.DBUtils"%>
<%@ page import="sql_queries.AeroQueries"%>
<%@ page import="java.sql.*"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<nav
	class="navbar navbar-toggleable-md navbar-inverse fixed-top bg-inverse">
	<button class="navbar-toggler navbar-toggler-right hidden-lg-up"
		type="button" data-toggle="collapse" data-target="#navbarsMenu"
		aria-expanded="false" aria-controls="navbarsMenu"
		aria-label="Toggle navigation">
		<span class="navbar-toggler-icon"></span>
	</button>
	<%-- href="${pageContext.request.contextPath}/index" --%>
	<a class="navbar-brand" href="${pageContext.request.contextPath}/index">
		TWI Cockpit</a>

	<div class="collapse navbar-collapse" id="navbarsMenu"
		aria-expanded="true" style="">
		<ul class="nav navbar-nav ">
			<li class="nav-item"><a class="nav-link"
				href="${pageContext.request.contextPath}/aero">AERO<span
					class="sr-only">(current)</span>
			</a></li>
			<li class="nav-item"><a class="nav-link"
				href="${pageContext.request.contextPath}/top">TOP <span
					class="sr-only">(current)</span>
			</a></li>
			<li class="nav-item"><a class="nav-link"
				href="${pageContext.request.contextPath}/ass">ASS</a></li>
			<li class="nav-item"><a class="nav-link"
				href="${pageContext.request.contextPath}/livedata">Livedaten</a></li>
			<li class="nav-item"><a class="nav-link"
				href="${pageContext.request.contextPath}/test">TestPage</a></li>

			<%-- <sec:authorize access="hasAnyRole('ADMIN')">

				<%
					String real = session.getServletContext().getRealPath("");
						Connection conn = DBUtils.GetAeroConnection(real);
						AeroQueries.clAeroIndex Index = new AeroQueries.clAeroIndex(conn);
						
						for (int i = 0; i < Index.vWarehouse.size(); i++) {
				%>
				<li class="nav-item"><a class="nav-link"
					href="${pageContext.request.contextPath}/compaero?warehouse=<%=Index.vWarehouse.get(i)%>"><%=Index.vCompany.get(i)%>
						<%=Index.vLocation.get(i)%></a></li>
				<%
					}
				%>

			</sec:authorize> --%>
		</ul>
	
	
	<ul class="navbar-nav navbar-collapse justify-content-end">
			<li class="nav-item justify-content-end"><a class="nav-link"
				href="${pageContext.request.contextPath}/login">
				<span class="icon icon-login"></span> Login</a></li>
			<li class="nav-item justify-content-end">
				<a class="nav-link" href="javascript:document.getElementById('logout').submit()">				 	
				Logout <span class="icon icon-log-out"></span></a></li>
		</ul>
	</div>
</nav>
<br>
<br>