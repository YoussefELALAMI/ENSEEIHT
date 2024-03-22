<%@ page language="java" import="pack.*,java.util.*" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Choix</title>
</head>
<body>
Choisir la personne :<br>
<form action="Serv" method="get">
<%
Collection<Personne> listepersonnes = (Collection<Personne>) request.getAttribute("listepersonnes");
for(Personne p : listepersonnes){
	int id = p.getId();
	String s = p.getNom() + " " + p.getPrenom();
%>
<input type="radio" name="idpersonne" value="<%=id %>"> <%=s %><br>
<%
}
%>
<br>
Choisir l'adresse :<br>
<%
Collection<Adresse> listeadresse = (Collection<Adresse>) request.getAttribute("listeadresses");
for(Adresse a : listeadresse){
	int idA = a.getId();
	String sA = a.getRue() + " " + a.getVille();
%>
<input type="radio" name="idadresse" value="<%=idA %>"> <%=sA %><br>
<%
}
%>
<br>
<input type="submit" value="OK">
<input type="hidden" name="op" value="choix">
</form>
</body>
</html>