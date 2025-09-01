package com.example.demo.controller;

import com.example.demo.entity.User;
import com.example.demo.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    // ---- LOGIN PAGE IS THE MAIN PAGE ----
    @GetMapping("/")
    public String homeRedirect() {
        return "redirect:/login";   // default root → login page
    }


    @GetMapping("/login")
    public String showLoginForm(Model model) {
        model.addAttribute("user", new User());
        return "login";
    }

    @PostMapping("/login")
    public String loginUser(@ModelAttribute("user") User user, Model model) {

        User validUser = userService.login(user.getUsername(), user.getPassword());
        if (validUser != null) {
            model.addAttribute("name", validUser.getUsername());
            return "task";   //   go to task page
        } else {

            model.addAttribute("error", "Invalid Username or Password!");
            return "login";
        }
    }

    // ---- REGISTER PAGE ----
    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("user", new User());
        return "register";
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
        return "redirect:/login";   //  after register → back to login
    }
}
