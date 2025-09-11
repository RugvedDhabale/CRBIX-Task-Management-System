<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Register Page</title>

  <!-- External CSS -->
  <link rel="stylesheet" type="text/css" href="<c:url value='/css/register.css'/>"/>

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

  <!-- Register Card -->
  <div class="register-container">
    <!-- Left Illustration -->
    <div class="illustration">
      <img src="<c:url value='/images/illustration.png'/>" alt="Employee working"/>
    </div>

    <!-- Right Register Form -->
    <div class="register-form">
      <div class="avatar-circle"></div>

<div class="alert alert-info" role="alert">
  A simple info alert—check it out!
</div>


      <!-- Register Form -->
      <form action="register" method="post" enctype="multipart/form-data">
        <input type="text" name="firstName" placeholder="Enter First Name" value="${user.firstName}" required/>
        <input type="text" name="lastName" placeholder="Enter Last Name" value="${user.lastName}" required/>
        <input type="text" name="username" placeholder="Enter Username" value="${user.username}" required/>
        <input type="password" name="password" placeholder="Enter Password" value="${user.password}" required/>
        <input type="password" name="confirmPassword" placeholder="Confirm Password" value="${user.confirmPassword}" required/>
        <input type="text" name="phone" placeholder="Phone No" value="${user.phone}" required/>

        <!-- Upload Section -->
        <div class="upload-section">
          <label><strong>Upload Documents:</strong></label>

          <div class="file-upload">
            <label>Aadhar Card:</label>
            <input type="file" name="aadharFile" accept=".jpg,.jpeg,.png,.pdf" required/>
          </div>

          <div class="file-upload">
            <label>PAN Card:</label>
            <input type="file" name="panFile" accept=".jpg,.jpeg,.png,.pdf" required/>
          </div>

          <div class="file-upload">
            <label>Marksheet:</label>
            <input type="file" name="marksheetFile" accept=".pdf" required/>
          </div>

          <p class="note">
            PLEASE COMPILE YOUR 10th, 12th and GRADUATION MARKSHEET INTO SINGLE PDF
          </p>
        </div>

        <!-- Register Button -->
        <button type="submit">Register</button>
      </form>

      <!-- Link to Login -->
      <div class="login-link">
        <p>If you already have an account?</p>
        <form action="login" method="get">
          <button type="submit">Login</button>
        </form>
      </div>

      <!-- Error Message -->
      <c:if test="${not empty error}">
        <p style="color:red">${error}</p>
      </c:if>
    </div>
  </div>
</body>
</html>
