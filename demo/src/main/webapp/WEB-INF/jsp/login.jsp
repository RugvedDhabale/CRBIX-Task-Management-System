<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Login Page</title>

  <!-- External CSS -->
<link rel="stylesheet" type="text/css" href="<c:url value='/css/login.css'/>"/>

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Poppins&display=swap" rel="stylesheet">

  <!-- FontAwesome -->
  <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</head>
<body>

  <!-- Header -->
  <header class="header">
    <div class="logo">
      <h2>CRBIX SOLUTIONS</h2>
    </div>
    <div class="power-icon">
      <i class="fas fa-power-off"></i>
    </div>
  </header>

  <!-- Login Card -->
  <div class="login-container">
    <!-- Left Illustration -->
    <div class="illustration">
      <img src="<c:url value='/images/illustration.png'/>" alt="Employee working"/>
    </div>

    <!-- Right Login Form -->
    <div class="login-form">
      <div class="logo-circle"></div>

      <form action="login" method="post">
        <input type="text" name="username" placeholder="Enter Username" value="${user.username}" required/>
        <input type="password" name="password" placeholder="Enter Password" value="${user.password}" required/>

        <button type="submit">Login</button>
      </form>

      <div class="register">
        <p>If you don't have an account?</p>
        <form action="register" method="get">
          <button type="submit" class="register-button">Register</button>
        </form>
      </div>

      <c:if test="${not empty error}">
        <p style="color:red">${error}</p>
      </c:if>
    </div>
  </div>
</body>
</html>
