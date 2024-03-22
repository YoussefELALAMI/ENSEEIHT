<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>Calculatrice</h1>
	<form action="Serv" method="get">
		nb1 : <input type="text" name="nb1"><br/>
		nb2 : <input type="text" name="nb2"><br/>
		<input type="submit" value="compute">
	</form>
	<% if (request.getAttribute("result") != null){ %>
	<p> resultat : ${result} </p>
	<%} %>
</body>
</html>