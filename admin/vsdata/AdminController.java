package com.example.demo.controller;

import com.example.demo.entity.Task;
import com.example.demo.entity.User;
import com.example.demo.service.AdminService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
public class AdminController {

    @Autowired
    private AdminService adminService;

    // Admin Dashboard
    @GetMapping("/admin")
    public String adminDashboard(HttpSession session, Model model) {

        // Admin login time (store in session)
        if (session.getAttribute("adminLoginTime") == null) {
            session.setAttribute("adminLoginTime", LocalDateTime.now());
        }

        LocalDateTime loginTime = (LocalDateTime) session.getAttribute("adminLoginTime");

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
        String inTime = loginTime != null ? loginTime.format(formatter) : "--:--";
        
        // Calculate logged hours
        String loggedHours = calculateLoggedHours(loginTime);

        // Fetch all employees & tasks
        List<User> employees = adminService.getAllEmployees();
        List<Task> allTasks = adminService.getAllTasks();

        // Add additional statistics
        long totalEmployees = employees.size();
        long activeEmployees = employees.stream()
                .filter(emp -> emp.getTasks() != null && !emp.getTasks().isEmpty())
                .count();
        
        long completedTasks = allTasks.stream()
                .filter(task -> "COMPLETED".equals(task.getStatus()))
                .count();
                
        long pendingTasks = allTasks.stream()
                .filter(task -> !"COMPLETED".equals(task.getStatus()))
                .count();

        model.addAttribute("inTime", inTime);
        model.addAttribute("outTime", "--:--"); // Will be set on logout
        model.addAttribute("loggedHours", loggedHours);
        model.addAttribute("taskCount", adminService.getTotalTasksAssigned());
        model.addAttribute("employees", employees);
        model.addAttribute("allTasks", allTasks);
        
        // Additional statistics
        model.addAttribute("totalEmployees", totalEmployees);
        model.addAttribute("activeEmployees", activeEmployees);
        model.addAttribute("completedTasks", completedTasks);
        model.addAttribute("pendingTasks", pendingTasks);

        return "admin"; // admin.jsp
    }
    
    // Admin logout
    @PostMapping("/admin/logout")
    public String adminLogout(HttpSession session, Model model) {
        LocalDateTime loginTime = (LocalDateTime) session.getAttribute("adminLoginTime");
        LocalDateTime logoutTime = LocalDateTime.now();
        
        if (loginTime != null) {
            // Calculate total work hours
            Duration workDuration = Duration.between(loginTime, logoutTime);
            long hours = workDuration.toHours();
            long minutes = workDuration.toMinutes() % 60;
            String totalWorkHours = String.format("%02d:%02d", hours, minutes);
            
            // You can save this to database if needed
            // adminService.saveWorkSession(loginTime, logoutTime, totalWorkHours);
            
            // Store logout time in session for display
            session.setAttribute("adminLogoutTime", logoutTime);
            session.setAttribute("totalWorkHours", totalWorkHours);
        }
        
        // Clear login time but keep logout info for display
        session.removeAttribute("adminLoginTime");
        
        return "redirect:/login"; // Redirect to login page
    }
    
    // Helper method to calculate logged hours from login time to current time
    private String calculateLoggedHours(LocalDateTime loginTime) {
        if (loginTime == null) {
            return "--:--";
        }
        
        Duration duration = Duration.between(loginTime, LocalDateTime.now());
        long hours = duration.toHours();
        long minutes = duration.toMinutes() % 60;
        
        return String.format("%02d:%02d", hours, minutes);
    }
    
    // Get current admin session info (for AJAX calls if needed)
    @GetMapping("/admin/session-info")
    public String getSessionInfo(HttpSession session, Model model) {
        LocalDateTime loginTime = (LocalDateTime) session.getAttribute("adminLoginTime");
        LocalDateTime logoutTime = (LocalDateTime) session.getAttribute("adminLogoutTime");
        String totalWorkHours = (String) session.getAttribute("totalWorkHours");
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
        
        model.addAttribute("inTime", loginTime != null ? loginTime.format(formatter) : "--:--");
        model.addAttribute("outTime", logoutTime != null ? logoutTime.format(formatter) : "--:--");
        model.addAttribute("loggedHours", calculateLoggedHours(loginTime));
        model.addAttribute("totalWorkHours", totalWorkHours != null ? totalWorkHours : "--:--");
        
        return "fragments/session-info"; // Return a fragment if using AJAX
    }
    
    // Filter employees by department (for dropdown functionality)
    @GetMapping("/admin/employees/filter")
    public String filterEmployees(String department, String status, String period, Model model) {
        List<User> employees = adminService.getAllEmployees();
        
        // Apply filters based on parameters
        if (department != null && !department.equals("All Departments")) {
            employees = employees.stream()
                    .filter(emp -> department.equals(emp.getDepartment())) // Assuming User has department field
                    .toList();
        }
        
        if (status != null && !status.equals("All Status")) {
            // Filter based on employee status
            employees = employees.stream()
                    .filter(emp -> {
                        if ("Active".equals(status)) {
                            return emp.getTasks() != null && !emp.getTasks().isEmpty();
                        } else if ("Inactive".equals(status)) {
                            return emp.getTasks() == null || emp.getTasks().isEmpty();
                        }
                        return true;
                    })
                    .toList();
        }
        
        model.addAttribute("employees", employees);
        model.addAttribute("selectedDepartment", department);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("selectedPeriod", period);
        
        return "fragments/employee-table"; // Return filtered table fragment
    }
}