<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Register Page</title>
    <link rel="stylesheet" href="register.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link
      href="https://fonts.googleapis.com/css2?family=Poppins&display=swap"
      rel="stylesheet"
    />
    <script
      src="https://kit.fontawesome.com/a076d05399.js"
      crossorigin="anonymous"
    ></script>
  </head>
  <body>
    <!-- Header -->
    <header class="header">
      <div class="logo">
        <img class="img" src="CRBIXLOGO.png" alt="" />
      </div>
      <div class="power-icon">
        <i class="fas fa-power-off"></i>
      </div>
    </header>
 
    <!-- Register Card -->
    <div class="register-container">
      <!-- Left Illustration -->
      <div class="illustration">
        <img src="CRBIXLOGO.png" alt="Employee working" />
      </div>
 
      <!-- Right Register Form -->
      <div class="register-form">
        <div class="avatar-circle"><p class="logocircleP">OK</p></div>
 
        <!-- Form -->
        <form action="RegisterServlet" method="post" enctype="multipart/form-data">
          <input type="text" name="firstName" id="firstName" placeholder="Enter First Name" />
          <input type="text" name="lastName" id="lastName" placeholder="Enter Last Name" />
          <input type="password" name="password" id="password" placeholder="Password" />
          <input type="text" name="contact" id="contact" placeholder="Phone No" />
 
          <!-- Upload Section -->
          <div class="upload-section">
            <label><strong class="uplodText">Upload Documents:</strong></label>
 
            <div class="file-upload">
              <label>Aadhar Card:</label>
              <input type="file" name="aadharFile" id="aadharFile" accept=".jpg,.jpeg,.png,.pdf" />
            </div>
 
            <div class="file-upload">
              <label>PAN Card:</label>
              <input type="file" name="panFile" id="panFile" accept=".jpg,.jpeg,.png,.pdf" />
            </div>
 
            <div class="file-upload">
              <label>Marksheet:</label>
              <input type="file" name="marksheetFile" id="marksheetFile" accept=".pdf" />
            </div>
 
            <p class="note">
              PLEASE COMPILE YOUR 10th, 12th and GRADUATION MARKSHEET INTO SINGLE
              PDF
            </p>
          </div>
 
          <!-- Register Button -->
          <button type="submit" id="registerBtn">Register</button>
        </form>
 
        <!-- Link to Login -->
        <div class="login-link">
          <p>If you already have an account?</p>
          <button onclick="window.location.href='login.jsp'">Login</button>
        </div>
      </div>
    </div>
 
    <script src="register.js"></script>
  </body>
</html>
