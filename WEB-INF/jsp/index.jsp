<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="sql_queries.ConnectionPath"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width = device-width, initial-scale=1">
<meta name="author" content="Darshil Gosai- TWI GmbH">
<title>TWI Cockpit</title>
<link rel="stylesheet" type="text/css" href="toolkit-inverse.min.css"
	title="dark">
<link rel="alternate stylesheet" type="text/css" title="light"
	href="toolkit-light.min.css">
<link rel="stylesheet" type="text/css" href="application.css">
<link rel="stylesheet" type="text/css" href="twi.css">
<!-- add for adjusting style in web  -->
<jsp:include page="/WEB-INF/jsp/include/includeMenu.jsp" />
<style>
.sidebar {
	position: fixed;
	top: 51px;
	bottom: 0;
	left: 0;
	z-index: 1000;
	padding: 20px;
	overflow-x: hidden;
	overflow-y: auto;
	border-right: 1px solid #eee;
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

<body class="hide">
	<%
		//makes sure that a session was created and ApplicationPath is accessable
		ConnectionPath cp = new ConnectionPath();
		if (ConnectionPath.getPath() == null) {
			session.invalidate();
			request.getSession();
		}
	%>
	<!-- Alert messages for successful Login/Logout -->
	<div class="container-fluid">
		<div class="row justify-content-center">
			<div id="div-login-msg">
				<c:if test="${not empty login}">
					<div class="alert alert-success">
						<span class="icon icon-check"></span>${login}
					</div>
				</c:if>
			</div>

			<div id="div-logout-msg">
				<c:if test="${not empty logout}">
					<div class="alert alert-success">
						<span class="icon icon-check"></span>${logout}
					</div>
				</c:if>
			</div>
		</div>




		<div class="container-fluid">
			<div class="media">
				<!-- =================================================== NEW CODE START========================================================= -->

				<div id="carousel-generic" class="carousel mx-auto" data-ride="carousel">
					<!-- Indicators -->
					<ol class="carousel-indicators pos-f">
						<li data-target="#carousel-generic" data-slide-to="0"
							class="active"></li>
						<li data-target="#carousel-generic" data-slide-to="1"></li>
						<li data-target="#carousel-generic" data-slide-to="2"></li>
						<li data-target="#carousel-generic" data-slide-to="3"></li>
					</ol>

					<!-- Wrapper for slides -->
					<div class="carousel-inner" role="listbox">
						<div class="carousel-item active">
							<img src="logo-neu.png" alt="Generic placeholder image"
								class="w-100">
						</div>

						<div class="carousel-item">
							<img src="bar_chart.png" alt="Generic placeholder image"
								class="w-100">
						</div>

						<div class="carousel-item">
							<img src="line_chart.png" alt="Generic placeholder image"
								class="w-100">
						</div>

						<div class="carousel-item">
							<img src="bar_chart_color.png" alt="Generic placeholder image"
								class="w-100">
						</div>

						<!-- new Image place -->

					</div>
				
			
					<!-- Controls -->
					<a class="carousel-control-prev carousel-control pos-f"
						href="#carousel-generic" role="button" data-slide="prev"> <span
						class="icon icon-chevron-left" aria-hidden="true"></span>

					</a> <a class="carousel-control-next carousel-control pos-f"
						href="#carousel-generic" role="button" data-slide="next"> <span
						class="icon icon-chevron-right" aria-hidden="true"></span>

					</a>
			</div>

				<!-- =================================================== NEW CODE END========================================================= -->

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
	<!-- required to run styleswitcher -->
	<script src="styleswitcher.js"></script>


	<script>
		//========================= Msg fade-out ===============================

		setTimeout(function() {
			$('#div-login-msg').fadeOut('fast');
		}, 3000);

		setTimeout(function() {
			$('#div-logout-msg').fadeOut('fast');
		}, 3000);
	</script>
</body>
</html>