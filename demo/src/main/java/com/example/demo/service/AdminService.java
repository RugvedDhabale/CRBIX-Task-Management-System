package com.example.demo.service;

import com.example.demo.entity.Task;
import com.example.demo.entity.User;
import com.example.demo.repository.TaskRepository;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class AdminService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TaskRepository taskRepository;

    // Get all employees with tasks
    public List<User> getAllEmployees() {
        List<User> employees = userRepository.findByRole("EMPLOYEE");
        for (User emp : employees) {
            // manually fetch tasks
            emp.setTasks(taskRepository.findByUserId(emp.getId()));
        }
        return employees;
    }

    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    public Long getTotalTasksAssigned() {
        return taskRepository.count();
    }

    //Remaining task
    public Long getRemainingTasks(Long userId) {
        return taskRepository.findByUserId(userId)
                .stream()
                .filter(t -> !t.getStatus().equals("COMPLETED"))
                .count();
    }
}
