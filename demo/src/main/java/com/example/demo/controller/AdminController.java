package com.example.demo.controller;

import com.example.demo.entity.Task;
import com.example.demo.entity.User;
import com.example.demo.service.AdminService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

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

        // Fetch all employees & tasks
        List<User> employees = adminService.getAllEmployees();
        List<Task> allTasks = adminService.getAllTasks();

        model.addAttribute("inTime", inTime);
        model.addAttribute("taskCount", adminService.getTotalTasksAssigned());
        model.addAttribute("employees", employees);
        model.addAttribute("allTasks", allTasks);

        return "admin"; // admin.jsp
    }
}
