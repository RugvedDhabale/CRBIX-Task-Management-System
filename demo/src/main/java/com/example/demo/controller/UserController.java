package com.example.demo.controller;

import com.example.demo.entity.Task;
import com.example.demo.entity.User;
import com.example.demo.service.UserService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    // ---------------- HOME REDIRECT ----------------
    @GetMapping("/")
    public String homeRedirect() {
        return "redirect:/login"; // default page = login
    }



    // ---------------- LOGIN METHODS ----------------
    @GetMapping("/login")
    public String showLoginForm(Model model) {
        model.addAttribute("user", new User());
        return "login"; // login.jsp
    }


    //if  successfully login user will goes to task page
    @PostMapping("/login")
    public String loginUser(@ModelAttribute("user") User user, Model model, HttpSession session) {
        User validUser = userService.login(user.getUsername(), user.getPassword());
        if (validUser != null) {
            // save login time
            validUser.setInTime(LocalDateTime.now());
            userService.saveUser(validUser);

            // fetch tasks
            List<Task> tasks = userService.getTasksByUserId(validUser.getId());

            // format times
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
            String inTime = validUser.getInTime() != null ? validUser.getInTime().format(formatter) : "--:--";
            String outTime = validUser.getOutTime() != null ? validUser.getOutTime().format(formatter) : "--:--";

            // store in session
            session.setAttribute("userId", validUser.getId());

            // send data to JSP
            model.addAttribute("name", validUser.getUsername());
            model.addAttribute("tasks", tasks);
            model.addAttribute("inTime", inTime);
            model.addAttribute("outTime", outTime);
            model.addAttribute("taskCount", tasks.size());

            return "task"; // task.jsp
        } else {
            model.addAttribute("error", "Invalid Username or Password!");
            return "login";
        }
    }

    // ---------------- LOGOUT METHOD ----------------
    @GetMapping("/logout")
    public String logoutUser(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId != null) {
            User user = userService.findUserById(userId);
            if (user != null) {
                // save logout time
                user.setOutTime(LocalDateTime.now());
                userService.saveUser(user);
            }
        }
        session.invalidate(); // destroy session
        return "redirect:/login";
    }

    // ---------------- REGISTER METHODS ----------------
    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("user", new User());
        return "register"; // register.jsp
    }

    @PostMapping("/register")
    public String registerUser(@Valid @ModelAttribute("user") User user,
                               BindingResult result,
                               Model model) {
        if (result.hasErrors()) {
            model.addAttribute("error", result.getFieldError("password").getDefaultMessage());
            return "register";
        }

        if (!user.getPassword().equals(user.getConfirmPassword())) {
            model.addAttribute("error", "Passwords do not match!");
            return "register";
        }

        userService.saveUser(user);
        return "redirect:/login"; // after register → login
    }

    // ---------------- TASK PAGE METHODS ----------------
    @GetMapping("/tasks")
    public String showTasks(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        User user = userService.findUserById(userId);
        List<Task> tasks = userService.getTasksByUserId(userId);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
        String inTime = user.getInTime() != null ? user.getInTime().format(formatter) : "--:--";
        String outTime = user.getOutTime() != null ? user.getOutTime().format(formatter) : "--:--";

        model.addAttribute("tasks", tasks);
        model.addAttribute("name", user.getUsername());
        model.addAttribute("inTime", inTime);
        model.addAttribute("outTime", outTime);
        model.addAttribute("taskCount", tasks.size());

        return "task"; // task.jsp
    }



}
