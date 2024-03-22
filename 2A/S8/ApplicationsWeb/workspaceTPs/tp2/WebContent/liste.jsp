<%@ page language="java" import="pack.*,java.util.*" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Liste</title>
</head>
<body>
<form action="Serv" method="get">
<%
Collection<Personne> listepersonnes = (Collection<Personne>)request.getAttribute("listepersonnes");
%>
<ul>
<%
for(Personne p : listepersonnes){
	String sP = p.getNom() + " " + p.getPrenom();
%>
<li><%=sP %></li>
<ul>
<%
for(Adresse a : p.getAdresse()){
		String sA = a.getRue() + " " + a.getVille();
%>

<li> <%=sA %></li>

<%
}
%>
</ul>
<%
}
%>
</ul>
<br>

<br>
<input type="submit" value="OK">
<input type="hidden" name="op" value="retour">
</form>
</body>
</html>