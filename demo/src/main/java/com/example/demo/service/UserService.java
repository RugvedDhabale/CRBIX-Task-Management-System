package com.example.demo.service;

import com.example.demo.entity.User;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    //register data will be save
    public void saveUser(User user) {
        userRepository.save(user);
    }

    //search a user in database
    public User login(String username, String password) {
        return userRepository.findByUsernameAndPassword(username, password);
    }


}
