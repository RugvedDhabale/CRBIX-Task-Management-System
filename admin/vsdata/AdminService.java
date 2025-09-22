package com.example.demo.service;

import com.example.demo.entity.Task;
import com.example.demo.entity.User;
import com.example.demo.entity.Admin;
import com.example.demo.repository.TaskRepository;
import com.example.demo.repository.UserRepository;
import com.example.demo.repository.AdminRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class AdminService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private AdminRepository adminRepository;

    // Get all employees with tasks
    public List<User> getAllEmployees() {
        List<User> employees = userRepository.findByRole("EMPLOYEE");
        for (User emp : employees) {
            // manually fetch tasks
            emp.setTasks(taskRepository.findByUserId(emp.getId()));
        }
        return employees;
    }

    // Get employees filtered by department
    public List<User> getEmployeesByDepartment(String department) {
        List<User> employees = userRepository.findByRole("EMPLOYEE");
        if (department != null && !department.equals("All Departments")) {
            employees = employees.stream()
                    .filter(emp -> department.equals(emp.getDepartment()))
                    .collect(Collectors.toList());
        }
        
        // Load tasks for filtered employees
        for (User emp : employees) {
            emp.setTasks(taskRepository.findByUserId(emp.getId()));
        }
        return employees;
    }

    // Get active employees (employees with tasks)
    public List<User> getActiveEmployees() {
        return getAllEmployees().stream()
                .filter(emp -> emp.getTasks() != null && !emp.getTasks().isEmpty())
                .collect(Collectors.toList());
    }

    // Get inactive employees (employees without tasks)
    public List<User> getInactiveEmployees() {
        return getAllEmployees().stream()
                .filter(emp -> emp.getTasks() == null || emp.getTasks().isEmpty())
                .collect(Collectors.toList());
    }

    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    public Long getTotalTasksAssigned() {
        return taskRepository.count();
    }

    // Get completed tasks count
    public Long getCompletedTasksCount() {
        return taskRepository.findAll().stream()
                .filter(task -> "COMPLETED".equals(task.getStatus()))
                .count();
    }

    // Get pending tasks count
    public Long getPendingTasksCount() {
        return taskRepository.findAll().stream()
                .filter(task -> !"COMPLETED".equals(task.getStatus()))
                .count();
    }

    // Get in-progress tasks count
    public Long getInProgressTasksCount() {
        return taskRepository.findAll().stream()
                .filter(task -> "IN_PROGRESS".equals(task.getStatus()))
                .count();
    }

    //Remaining task for specific user
    public Long getRemainingTasks(Long userId) {
        return taskRepository.findByUserId(userId)
                .stream()
                .filter(t -> !t.getStatus().equals("COMPLETED"))
                .count();
    }

    // Get task statistics by status
    public Map<String, Long> getTaskStatistics() {
        List<Task> allTasks = taskRepository.findAll();
        return allTasks.stream()
                .collect(Collectors.groupingBy(
                    Task::getStatus,
                    Collectors.counting()
                ));
    }

    // Get employee performance metrics
    public Map<String, Object> getEmployeePerformanceMetrics() {
        List<User> employees = getAllEmployees();
        long totalEmployees = employees.size();
        long activeEmployees = employees.stream()
                .filter(emp -> emp.getTasks() != null && !emp.getTasks().isEmpty())
                .count();
        
        double productivityRate = totalEmployees > 0 ? 
                (double) activeEmployees / totalEmployees * 100 : 0;

        return Map.of(
                "totalEmployees", totalEmployees,
                "activeEmployees", activeEmployees,
                "inactiveEmployees", totalEmployees - activeEmployees,
                "productivityRate", Math.round(productivityRate * 100.0) / 100.0
        );
    }

    // Calculate work hours for an employee
    public String calculateWorkHours(LocalDateTime inTime, LocalDateTime outTime) {
        if (inTime != null && outTime != null) {
            Duration duration = Duration.between(inTime, outTime);
            long hours = duration.toHours();
            long minutes = duration.toMinutes() % 60;
            return String.format("%02d:%02d", hours, minutes);
        }
        return "--:--";
    }

    // Calculate current session duration
    public String calculateCurrentSessionDuration(LocalDateTime loginTime) {
        if (loginTime != null) {
            Duration duration = Duration.between(loginTime, LocalDateTime.now());
            long hours = duration.toHours();
            long minutes = duration.toMinutes() % 60;
            return String.format("%02d:%02d", hours, minutes);
        }
        return "--:--";
    }

    // Save admin work session (optional - for tracking admin login/logout)
    public void saveAdminWorkSession(String adminUsername, LocalDateTime inTime, LocalDateTime outTime) {
        Admin admin = adminRepository.findByUsernameAndPassword(adminUsername, null); // You might want to improve this
        if (admin != null) {
            admin.setInTime(inTime);
            admin.setOutTime(outTime);
            adminRepository.save(admin);
        }
    }

    // Get employee by ID with tasks
    public User getEmployeeById(Long employeeId) {
        User employee = userRepository.findById(employeeId).orElse(null);
        if (employee != null) {
            employee.setTasks(taskRepository.findByUserId(employee.getId()));
        }
        return employee;
    }

    // Get tasks by status
    public List<Task> getTasksByStatus(String status) {
        return taskRepository.findAll().stream()
                .filter(task -> status.equals(task.getStatus()))
                .collect(Collectors.toList());
    }

    // Get recent tasks (last 7 days)
    public List<Task> getRecentTasks() {
        LocalDateTime weekAgo = LocalDateTime.now().minusDays(7);
        return taskRepository.findAll().stream()
                .filter(task -> task.getCreatedDate() != null && 
                               task.getCreatedDate().isAfter(weekAgo))
                .collect(Collectors.toList());
    }

    // Get employee task summary
    public Map<String, Object> getEmployeeTaskSummary(Long userId) {
        List<Task> userTasks = taskRepository.findByUserId(userId);
        
        long completedTasks = userTasks.stream()
                .filter(task -> "COMPLETED".equals(task.getStatus()))
                .count();
                
        long pendingTasks = userTasks.stream()
                .filter(task -> "PENDING".equals(task.getStatus()))
                .count();
                
        long inProgressTasks = userTasks.stream()
                .filter(task -> "IN_PROGRESS".equals(task.getStatus()))
                .count();

        return Map.of(
                "totalTasks", (long) userTasks.size(),
                "completedTasks", completedTasks,
                "pendingTasks", pendingTasks,
                "inProgressTasks", inProgressTasks,
                "completionRate", userTasks.size() > 0 ? 
                    Math.round((double) completedTasks / userTasks.size() * 100 * 100.0) / 100.0 : 0
        );
    }

    // Search employees by name
    public List<User> searchEmployeesByName(String searchTerm) {
        List<User> allEmployees = getAllEmployees();
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            return allEmployees;
        }
        
        String searchLower = searchTerm.toLowerCase();
        return allEmployees.stream()
                .filter(emp -> emp.getUsername().toLowerCase().contains(searchLower) ||
                              (emp.getEmail() != null && emp.getEmail().toLowerCase().contains(searchLower)))
                .collect(Collectors.toList());
    }

    // Get dashboard summary
    public Map<String, Object> getDashboardSummary() {
        List<User> employees = getAllEmployees();
        List<Task> tasks = getAllTasks();
        
        return Map.of(
                "totalEmployees", (long) employees.size(),
                "totalTasks", (long) tasks.size(),
                "completedTasks", getCompletedTasksCount(),
                "pendingTasks", getPendingTasksCount(),
                "inProgressTasks", getInProgressTasksCount(),
                "activeEmployees", getActiveEmployees().size(),
                "taskCompletionRate", tasks.size() > 0 ? 
                    Math.round((double) getCompletedTasksCount() / tasks.size() * 100 * 100.0) / 100.0 : 0
        );
    }
}