<%@page import="javax.jdo.PersistenceManager"%>
<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<%@ page import="java.util.List" %>
<%@ page import="javax.jdo.PersistenceManager" %>    
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="guestbook.Greeting" %>
<%@ page import="guestbook.PMF" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
	<title>Welcome To My Homepage!</title>
	<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
</head>
<body>
<%
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	if(user != null){
%>
	<p>Hello, <%= user.getNickname() %>! (You can 
	<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>

<%
	} else {
%>
	<p>Hello!
		<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
		to include your name with greetings your post.
	</p>
<%
	}
%>

<%
	PersistenceManager pm = PMF.get().getPersistenceManager();
	String query = "select from " + Greeting.class.getName();
	List<Greeting> greetings = (List<Greeting>) pm.newQuery(query).execute();
	if(greetings.isEmpty()){
%>
<p>The guestbook has no messages.</p>
<%
	} else {
		for(Greeting g : greetings) {
			if(g.getAuthor() == null){
%>
<p>An anonymous person wrote:</p>
<%
			} else {
%>
<p><b><%= g.getAuthor().getNickname() %></b> wrote:</p>
<%  		
			}
%>
<blockquote><%= g.getContent() %> </blockquote>
<%
		}
	}
	pm.close();
%>

	<form action="/sign" method="post">
		<div><textarea name="content" rows="3" cols="60"></textarea></div>
		<div><input type="submit" value="Post Greeting" /></div>
	</form>
</body>
</html>