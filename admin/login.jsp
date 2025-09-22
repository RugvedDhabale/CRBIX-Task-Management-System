<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Login Page</title>
  <link rel="stylesheet" href="login.css" />
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Poppins&display=swap" rel="stylesheet">
  <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</head>
<body>

  <!-- Header -->
  <header class="header">
    <div class="logo">
      <img class="img" src="CRBIXLOGO.png" alt="Logo">
    </div>
  </header>

  <!-- Login Card -->
  <div class="login-container">
    <!-- Left Illustration -->
    <div class="illustration">
      <img src="CRBIXLOGO.png" alt="Illustration" />
    </div>

    <!-- Right Login Form -->
    <div class="login-form">
      <div class="logo-circle"><p class="logocircleP">OK</p></div>

      <!-- Form -->
      <form action="LoginServlet" method="post">
        <input type="text" name="username" placeholder="Enter Username" required />
        <input type="password" name="password" placeholder="Enter Password" required />

        <button type="submit" id="loginBtn">Login</button>
      </form>

      <div class="register-link">
        <p>If you don't have an account?</p>
        <button type="button" onclick="window.location.href='register.jsp'">Register</button>
      </div>
    </div>
  </div>

  <script src="script.js"></script>
</body>
</html>
