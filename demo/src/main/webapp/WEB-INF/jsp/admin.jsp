<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="p-4">

    <!-- Admin Info -->
    <div class="mb-4">
        <h3>Admin Dashboard</h3>
        <p><strong>Login Time:</strong> ${inTime}</p>
        <p><strong>Total Tasks Assigned:</strong> ${taskCount}</p>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Logout</a>
    </div>

    <!-- Employees Task Table -->
    <table class="table table-bordered">
        <thead class="table-light">
            <tr>
                <th>Employee Name</th>
                <th>Tasks Assigned</th>
                <th>Task Status</th>
                <th>Work Hours</th>
                <th>Tasks Left</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="emp" items="${employees}">
                <tr>
                    <!-- Employee Name -->
                    <td>${emp.username}</td>

                    <!-- Show summaries of assigned tasks -->
                    <td>
                        <c:forEach var="task" items="${emp.tasks}">
                            • ${task.summary}<br/>
                        </c:forEach>
                    </td>

                    <!-- Show statuses of each task -->
                    <td>
                        <c:forEach var="task" items="${emp.tasks}">
                            ${task.status}<br/>
                        </c:forEach>
                    </td>

                    <!-- Work hours (calculated in service/controller if needed) -->
                    <td>
                        <c:choose>
                            <c:when test="${emp.inTime != null && emp.outTime != null}">
                                ${fn:substring(emp.inTime, 11, 16)} - ${fn:substring(emp.outTime, 11, 16)}
                            </c:when>
                            <c:otherwise>
                                --
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <!-- Remaining Tasks -->
                    <td>
                    <!-- -->





                        <c:set var="remaining" value="0"/>
                        <c:forEach var="task" items="${emp.tasks}">
                               <c:if test="${fn:toUpperCase(task.status) ne 'COMPLETED'}">
                                                  <c:set var="remaining" value="${remaining + 1}"/>
                                              </c:if>
                        </c:forEach>
                        ${remaining}
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

</body>
</html>
