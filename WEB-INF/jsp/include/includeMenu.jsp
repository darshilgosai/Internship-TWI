<%@ page import="sql_queries.DBUtils"%>
<%@ page import="sql_queries.AeroQueries"%>
<%@ page import="java.sql.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" type="text/css" href="change.css">

<html lang="en">

<script>

	/* var arrLang[] = {
		'en' : {
			'aero' : 'AERO',
			'ass' : 'ASS',
			'livedata' : 'LIVEDATA'
			},
		'de' : {
			'aero' : 'na hoy',
			'ass' : 'su vaat 6',
			'livedata' : 'thank god'
		}
	};
	
	$(function(){
		$('.translate').click(function(){
			var lang = $(this).attr('id');
			
			$('.lang').each(function(includeMenu, element){
				$(this).text(arrLang[lang][$(this).attr('key')]);
			});
		});
	});
 */
 
//Translation dictionary function
 $(document).ready(function() {

 var t = {   
 aero: {  // translates the value="" text
   en: "aerro",
   de: "OREA",
   pt: "dnk"
 },

 };
 var _t = $('body').translate({lang: "en", t: t});
 var str = _t.g("translate");
 console.log(str);

 $(".language").click(function(ev) {
 var lang = $(this).attr("data-value");
 _t.lang(lang);
 console.log(lang);
 ev.preventDefault();
 });
 });
 
</script>


<nav class="navbar navbar-toggleable-md navbar-light fixed-top bg-secondary">
	
	<a class="navbar-brand" href="${pageContext.request.contextPath}/index"
		data-toggle="tooltip" title="HOME PAGE"> <img src="nav_logo.png">
		<!--TWI COCKPIT LOGO -->
	</a>
	
	
	
	<button class="navbar-toggler navbar-toggler-right hidden-lg-up"
		type="button" data-toggle="collapse" data-target="#navbarsMenu"
		aria-expanded="false" aria-controls="navbarsMenu"
		aria-label="Toggle navigation">
		<span class="navbar-toggler-icon"></span>
	</button>
	<%-- href="${pageContext.request.contextPath}/index" --%>
	
	<div class="collapse navbar-collapse" id="navbarsMenu"
		aria-expanded="true" style="">
		<ul class="navbar-nav nav-tabs">
			<li class="nav-item text-center"><a data-trn-value="aero" class="nav-link trn"
				href="${pageContext.request.contextPath}/aero" data-toggle="tooltip"
				title="HINT FOR AERO">AERO</a></li>
			<li class="nav-item text-center" value="ass"><a class="nav-link"
				href="${pageContext.request.contextPath}/top" data-toggle="tooltip"
				title="HINT FOR TOP">TOP</a></li>
			<li class="nav-item text-center lang" value="ass"><a class="nav-link"
				href="${pageContext.request.contextPath}/ass" data-toggle="tooltip"
				title="HINT FOR ASS">ASS</a></li>
			<li class="nav-item text-center lang" value="livedata"><a class="nav-link"
				href="${pageContext.request.contextPath}/livedata"
				data-toggle="tooltip" title="HINT FOR LIVEDATA">Livedaten</a></li>
			

			<!-- ======================================== ToggleStyleSwitch ============================================================== -->
			<li class="nav-item dropdown"><a
				class="nav-link btn dropdown-toggle" data-toggle="dropdown"
				role="button" aria-haspopup="true" aria-expanded="false">Option</a>
				<div class="dropdown-menu position-absolute">
					
						<a class="dropdown-item text-center"> <span class="icon icon-moon"></span>
							<label class="switch"><input type="checkbox" id="Checkbox"
								data-toggle="toggle" onclick="myFunction()"> <span
								class="slider round active"></span></label> <span
							class="icon icon-light-up"></span>
						</a>
						<a class="dropdown-item text-center">
							<button class="translate btn-primary trn" id="en"><!-- <img src="en.png" class="w-50 h-50" -->EN</button>
							<button class="translate btn-warning trn" id="de"><!-- <img src="de.png" class="w-50 h-50" -->DE</button>
						</a>
						
					
				</div></li>
			<!-- ======================================== ToggleStyleSwitch ============================================================= -->


			<li class="nav-item text-center"><a class="nav-link"
				href="${pageContext.request.contextPath}/test" data-toggle="tooltip"
				title="HINT FOR TEST PAGE">TestPage</a></li>
				
<!-- 			<li class="nav-item text-center"><a id="google_translate_element"></a></li> -->
			
		</ul>

		<ul class="navbar-nav navbar-collapse justify-content-end">

			<li class="nav-item justify-content-end text-center"><a
				class="nav-link" href="${pageContext.request.contextPath}/login">
					<span class="icon icon-login"></span> Login
			</a></li>

			<li class="nav-item justify-content-end text-center"><a
				class="nav-link"
				href="javascript:document.getElementById('logout').submit()">
					Logout <span class="icon icon-log-out"></span>
			</a></li>

			<li class="nav-item justify-content-end text-center"><a
				class="nav-link" href="http://www.twi-germany.com/impressum.html"
				data-toggle="tooltip" title="WEBSITE"> <span
					class="icon icon-globe"></span> WebSite
			</a></li>

		</ul>

		
	</div>


	

</nav>
<br>
<br>
<br>
<div id="hidediv" class="media justify-content-between">
	<a href="javascript:history.back()" class="btn btn-primary"
		role="button">BACK</a> <a href="javascript:history.go(+1)"
		class="btn btn-primary" role="button">NEXT</a>
</div>
<br>

<script src="jquery-3.3.1.min.js"></script>
<script src="jquery.translate.js"></script>
<script>
	//========================= ToggleStyleSwitch ===============================

	$(function() {
		var test = localStorage.input === 'true' ? true : false;
		$('input').prop('checked', test || false);
	});

	$('input').on('change', function() {
		localStorage.input = $(this).is(':checked');
		console.log($(this).is(':checked'));
	});

	function myFunction() {
		//Get the Checkbox
		var checkBox = document.getElementById("Checkbox");

		//If checkbox is checked:
		if (checkBox.checked == true) {
			setActiveStyleSheet('light');
			return false;
		} else {
			setActiveStyleSheet('dark');
			return false;
		}

	};
</script>

<!-- --------------------------------------------------------------------------------------------------- -->

<!-- <script type="text/javascript">
function googleTranslateElementInit() {
  new google.translate.TranslateElement({pageLanguage: 'en', 
	  	layout: google.translate.TranslateElement.InlineLayout.SIMPLE
	  }, 'google_translate_element');
}
</script>


<script src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
 -->
<!-- ---------------------------------------------------------------------------------------------------- -->



</html>

