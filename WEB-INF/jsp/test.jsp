<%@page
	import="com.spring.security.handler.CustomAuthenticationSuccessHandler"%>
<%@page import="java.util.*"%>
<%@ page import="com.spring.security.user.*"%>

<%@page
	import="org.springframework.security.core.session.SessionRegistry"%>
<%@page
	import="org.springframework.security.core.session.SessionRegistryImpl"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>

<html lang="en">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" title="dark"
	href="toolkit-inverse.min.css">
<link rel="alternate stylesheet" type="text/css" title="light"
	href="toolkit-light.min.css">
<link rel="stylesheet" type="text/css" href="jquery.dataTables.min.css">
<title>TestSite</title>
<jsp:include page="/WEB-INF/jsp/include/includeMenu.jsp" />
</head>
<body>

	<%
	  Date createTime = new Date(session.getCreationTime());
		Date lastAccessTime = new Date(session.getLastAccessedTime());
	%>
	<p><%=createTime%></p>
	<p><%=lastAccessTime%></p>

	<sec:authorize access="hasAuthority('24')">
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb">
				<li class="breadcrumb-item"><a
					href="${pageContext.request.contextPath}/index">Home</a></li>
				<li class="breadcrumb-item"><a
					href="${pageContext.request.contextPath}/aero">AERO</a></li>
				<li class="breadcrumb-item"><a
					href="${pageContext.request.contextPath}/compaero">COMPAERO</a></li>
				<li class="breadcrumb-item active" aria-current="page">DELIVAERO</li>
			</ol>
		</nav>
	</sec:authorize>



	<p>
		<security:authorize access="isAuthenticated()">
			<!-- User has to be authenticated to see content -->
    authenticated as <security:authentication
				property="principal.username" />
			<!-- prints out the username of user -->
		</security:authorize>
	</p>
	<p>
		<security:authorize access="hasAuthority('24')">
			<!-- User has to be authenticated to see content -->
    with authorities <security:authentication
				property="principal.authorities" />
			<!-- prints out the authorities of user -->
		</security:authorize>
	</p>
	<p>
		<security:authorize access="isAuthenticated()">
    with homeid <security:authentication property="principal.homeid" />
		</security:authorize>
	</p>
	<p>
		<security:authorize access="isAuthenticated()">
    with userid <security:authentication property="principal.userid" />
		</security:authorize>
	</p>
	<c:forEach items="${sessionScope.allPrinc}" var="element">
		<div>Hallo ${element.username}</div>
	</c:forEach>

	<div id="div-login-msg">
		<c:if test="${not empty users}">
			<div class="alert alert-success">
				<span class="icon icon-check"></span>${users}
			</div>
		</c:if>
	</div>

	<!-- ======================== Logout logic ======================== -->
	<c:url value="/logout" var="logoutUrl" />
	<form id="logout" action="${logoutUrl}" method="post">
		<input type="hidden" name="${_csrf.parameterName}"
			value="${_csrf.token}" />
	</form>
	<!-- ============================================================== -->
	<!-- required to run bootstrap -->
	<script src="jquery-3.3.1.min.js"></script>
	<script src="popper.min.js"></script>
	<script src="bootstrap.min.js"></script>
	<!-- styleswitcher -->
	<script src="styleswitcher.js"></script>
	<!-- sorting tables -->
	<script src="datatables.min.js"></script>
	<!-- charts -->
	<script src="chart.js"></script>
</body>
</html>