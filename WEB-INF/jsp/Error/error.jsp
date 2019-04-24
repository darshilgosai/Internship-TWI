<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>${errorCode}</title>
<jsp:include page="/WEB-INF/jsp/include/includeMenu.jsp" />
<link rel="stylesheet" type="text/css" href="toolkit-inverse.min.css"
	title="dark">
<link rel="stylesheet" type="text/css" href="toolkit-light.min.css"
	title="light">
</head>
<body>

	<div class="container-fluid">
		<div class="row">
			<div class="col-md-3 sidebar"></div>
			<div class="col-md-9 content">
				<div class="table-responsive">
					<div class="col-md-9 content">
						<div class="dashhead">
							<div class="dashhead-titles">
								<h1 class="dashhead-title">${errorCode}</h1>
							</div>
						</div>
						<br>
						<h1>${errorMsg}</h1>
						<p>Please make sure the URL is correct and you have permission
							to view this page</p>

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
	<!-- Placed at the end of the document so the pages load faster -->
	<!-- required to run bootstrap -->
	<script src="jquery-3.3.1.min.js"></script>
	<script src="popper.min.js"></script>
	<script src="bootstrap.min.js"></script>
	<!-- 	styleswitcher -->
	<script src="styleswitcher.js"></script>

</body>
</html>