<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Exception</title>
<link rel="stylesheet" type="text/css" href="toolkit-inverse.min.css">
<jsp:include page="/WEB-INF/jsp/include/includeGif.jsp" />
<jsp:include page="/WEB-INF/jsp/include/includeMenu.jsp" />
</head>
<body>
	<h1>This SQL-Exception should not have happened!</h1>
	<br>
	<br>
	<p>Please contact the administrator of this website.</p>
	<p>Please check that the requested Information exists.</p>

	<!-- ======================== Java Script ======================== -->
	<!-- Placed at the end of the document so the pages load faster -->
	<!-- required to run bootstrap -->
	<script src="jquery-3.3.1.min.js"></script>
	<script src="popper.min.js"></script>
	<script src="bootstrap.min.js"></script>
	<!-- 	styleswitcher -->
	<script src="styleswitcher.js"></script>
	

</body>
</html>