<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Task Page</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="p-4">

<div class="mb-3">
    <p><strong>Username:</strong> ${name}</p>
    <p><strong>In Time:</strong> ${inTime}</p>
    <p><strong>Out Time:</strong> ${outTime}</p>
    <p><strong>No of Tasks Assigned:</strong> ${taskCount}</p>
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Logout</a>
</div>

<div class="d-grid gap-2 d-md-block">
    <c:forEach var="task" items="${tasks}" varStatus="status">
        <button class="btn btn-primary m-1"
                data-bs-toggle="modal"
                data-bs-target="#taskModal"
                data-title="${task.title}"
                data-summary="${task.summary}"
                data-description="${task.description}">
            Task ${status.index + 1}
        </button>
    </c:forEach>
</div>

<!-- Modal for Viewing Task -->
<div class="modal fade" id="taskModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Task Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p><strong>Title:</strong> <span id="taskTitleText"></span></p>
                <p><strong>Summary:</strong> <span id="taskSummary"></span></p>
                <p><strong>Description:</strong> <span id="taskDescription"></span></p>
            </div>
        </div>
    </div>
</div>

<script>
    let taskModal = document.getElementById('taskModal');
    taskModal.addEventListener('show.bs.modal', function (event) {
        let button = event.relatedTarget;
        document.getElementById('taskTitleText').innerText = button.getAttribute('data-title');
        document.getElementById('taskSummary').innerText = button.getAttribute('data-summary');
        document.getElementById('taskDescription').innerText = button.getAttribute('data-description');
    });
</script>


</body>
</html>
