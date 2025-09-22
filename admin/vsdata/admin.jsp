<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            gap: 20px;
            height: calc(100vh - 40px);
        }

        .sidebar {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 25px;
            width: 300px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        .profile-section {
            text-align: center;
            margin-bottom: 30px;
        }

        .profile-avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            border-radius: 50%;
            margin: 0 auto 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            font-weight: bold;
        }

        .info-card {
            background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
            border-radius: 12px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .info-card h3 {
            font-size: 14px;
            color: #333;
            margin-bottom: 8px;
            font-weight: 600;
        }

        .info-card .value {
            font-size: 18px;
            font-weight: bold;
            color: #2c3e50;
        }

        .time-section {
            background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
        }

        .stats-section {
            background: linear-gradient(135deg, #a8caba 0%, #5d4e75 100%);
            color: white;
        }

        .stats-section .value {
            color: white;
        }

        .hours-section {
            background: linear-gradient(135deg, #d299c2 0%, #fef9d7 100%);
        }

        .main-content {
            flex: 1;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .filter-controls {
            display: flex;
            gap: 15px;
        }

        .filter-select {
            padding: 8px 15px;
            border: 2px solid #e1e8ed;
            border-radius: 25px;
            background: white;
            font-size: 14px;
            color: #333;
            outline: none;
            transition: all 0.3s ease;
        }

        .filter-select:focus {
            border-color: #4facfe;
            box-shadow: 0 0 0 3px rgba(79, 172, 254, 0.1);
        }

        .employees-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .employees-table thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .employees-table th {
            padding: 15px 12px;
            text-align: left;
            font-weight: 600;
            font-size: 14px;
            border-right: 1px solid rgba(255, 255, 255, 0.1);
        }

        .employees-table th:last-child {
            border-right: none;
        }

        .employees-table td {
            padding: 15px 12px;
            border-bottom: 1px solid #f1f3f4;
            vertical-align: middle;
        }

        .employees-table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .employee-name {
            font-weight: 600;
            color: #2c3e50;
        }

        .task-summary {
            background: #e3f2fd;
            border: 1px solid #2196f3;
            border-radius: 20px;
            padding: 4px 12px;
            font-size: 12px;
            color: #1976d2;
            display: inline-block;
        }

        .status-badge {
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
        }

        .status-completed {
            background: #e8f5e8;
            color: #2e7d32;
        }

        .status-pending {
            background: #fff3e0;
            color: #f57c00;
        }

        .status-in-progress {
            background: #e3f2fd;
            color: #1976d2;
        }

        .work-hours {
            text-align: center;
        }

        .work-hours .time {
            display: block;
            font-size: 12px;
            color: #666;
        }

        .tasks-count {
            text-align: center;
            font-weight: 600;
            color: #333;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="profile-section">
                <div class="profile-avatar">A</div>
            </div>

            <div class="info-card time-section">
                <h3>In Time:</h3>
                <div class="value">${inTime}</div>
                <h3 style="margin-top: 10px;">Out Time:</h3>
                <div class="value">--:--</div>
            </div>

            <div class="info-card stats-section">
                <h3>No of Tasks Assigned</h3>
                <div class="value">${taskCount}</div>
            </div>

            <div class="info-card hours-section">
                <h3>No of Hrs Logged in</h3>
                <div class="value">--:--</div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="content-header">
                <h2>Employee Management Dashboard</h2>
                <div class="filter-controls">
                    <select class="filter-select">
                        <option>All Departments</option>
                        <option>Engineering</option>
                        <option>Marketing</option>
                        <option>Sales</option>
                    </select>
                    <select class="filter-select">
                        <option>All Status</option>
                        <option>Active</option>
                        <option>Inactive</option>
                    </select>
                    <select class="filter-select">
                        <option>This Month</option>
                        <option>This Week</option>
                        <option>Today</option>
                    </select>
                </div>
            </div>

            <table class="employees-table">
                <thead>
                    <tr>
                        <th>Emp Name</th>
                        <th>Task Assigned</th>
                        <th>Task Status</th>
                        <th>Emp Work HRs</th>
                        <th>No of Tasks Left</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty employees}">
                            <c:forEach var="employee" items="${employees}">
                                <tr>
                                    <td class="employee-name">${employee.username}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty employee.tasks}">
                                                <span class="task-summary">
                                                    ${employee.tasks.size()} Task(s)
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="task-summary">No Tasks</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty employee.tasks}">
                                                <c:forEach var="task" items="${employee.tasks}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${task.status == 'COMPLETED'}">
                                                            <span class="status-badge status-completed">Completed</span>
                                                        </c:when>
                                                        <c:when test="${task.status == 'IN_PROGRESS'}">
                                                            <span class="status-badge status-in-progress">In Progress</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-pending">Pending</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <c:if test="${!status.last}"><br></c:if>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-pending">No Tasks</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="work-hours">
                                        <span class="time">In: ${employee.inTime != null ? employee.inTime.format(java.time.format.DateTimeFormatter.ofPattern('HH:mm')) : '--:--'}</span>
                                        <span class="time">Out: ${employee.outTime != null ? employee.outTime.format(java.time.format.DateTimeFormatter.ofPattern('HH:mm')) : '--:--'}</span>
                                        <span class="time">Hrs: --:--</span>
                                    </td>
                                    <td class="tasks-count">
                                        <c:choose>
                                            <c:when test="${not empty employee.tasks}">
                                                ${employee.tasks.stream().filter(t -> !t.status.equals('COMPLETED')).count()}
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" class="no-data">No employees found</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>


<!-- 
<dependency>
    <groupId>jakarta.servlet.jsp.jstl</groupId>
    <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
    <version>3.0.0</version>
</dependency> -->