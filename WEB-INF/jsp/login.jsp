<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC>
<html lang="en">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="author" content="Darshil Gosai- TWI GmbH">
<title>Login</title>

<link rel="stylesheet" type="text/css" href="toolkit-inverse.min.css"
	title="dark">
<link rel="alternate stylesheet" type="text/css" title="light"
	href="toolkit-light.min.css">
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

.fixed-top {
	position: fixed;
	top: 0;
	right: 0;
	left: 0;
	z-index: 1030;
}

.wrapper {
	margin-top: 60px;
	margin-bottom: 60px;
}

.form-signin {
	max-width: 420px;
	padding: 15px 35px 45px;
	margin: 0 auto;
	border: 1px solid rgba(0, 0, 0, 0.1);
	.
	form-signin-heading
	,
	.checkbox
	{
	margin-bottom
	:
	30px;
}

.checkbox {
	font-weight: normal;
}

.form-control {
	position: relative;
	font-size: 16px;
	height: auto;
	padding: 10px;
	@
	include
	box-sizing(border-box);
	&:
	focus
	{
	z-index
	:
	2;
}

}
input[type="text"] {
	margin-bottom: -1px;
	border-bottom-left-radius: 0;
	border-bottom-right-radius: 0;
}

input[type="password"] {
	margin-bottom: 20px;
	border-top-left-radius: 0;
	border-top-right-radius: 0;
}
</style>

</head>
<body>
	<div class="wrapper">
		<form class="form-signin" name='login' accept-charset="utf-8"
			action="<c:url value='/login' />" method='POST'>

			<h2 class="form-signin-heading">Please login</h2>
			<div id="div-login-msg">

				<c:if test="${not empty error}">
					<div class="alert alert-danger" id="error">
						<span class="icon icon-block"></span> ${error}
					</div>
				</c:if>
				<c:if test="${not empty logout}">
					<div class="alert alert-success">
						<span class="icon icon-check"></span>${logout}
					</div>
				</c:if>
			</div>
			<input type="text" class="form-control" name="username"
				placeholder="Username" required autofocus /> <input type="password"
				class="form-control" name="password" placeholder="Password" required />

			<button class="btn btn-lg btn-primary btn-block" type="submit"
				name="submit" value="submit">Login</button>

			<input type="hidden" name="${_csrf.parameterName}"
				value="${_csrf.token}" />

		</form>
	</div>
	<!-- required to run bootstrap -->
	<script src="jquery-3.3.1.min.js"></script>
	<script src="popper.min.js"></script>
	<script src="bootstrap.min.js"></script>
	<!-- styleswitcher -->
	<script src="styleswitcher.js"></script>
</body>
</html>