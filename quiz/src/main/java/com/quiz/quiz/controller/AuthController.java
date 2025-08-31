package com.quiz.quiz.controller;

import com.quiz.quiz.dto.JwtResponse;
import com.quiz.quiz.dto.LoginRequest;
import com.quiz.quiz.dto.SignUpRequest;
import com.quiz.quiz.dto.RefreshRequest;
import com.quiz.quiz.security.JwtUtil;
import com.quiz.quiz.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.*;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "http://127.0.0.1:5500")
public class AuthController {

    @Autowired private AuthenticationManager authManager;
    @Autowired private JwtUtil jwtUtil;
    @Autowired private UserDetailsService userDetailsService;
    @Autowired private UserService userService;

    @PostMapping("/signup")
    public ResponseEntity<String> signup(@RequestBody SignUpRequest request) {
        if (userService.findByUsername(request.getUsername()).isPresent()) {
            return ResponseEntity.badRequest().body("Username already exists");
        }
        userService.register(request.getUsername(), request.getPassword());
        return ResponseEntity.ok("User registered successfully");
    }

    @PostMapping("/login")
    public JwtResponse login(@RequestBody LoginRequest request) {
        authManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
        );

        UserDetails userDetails = userDetailsService.loadUserByUsername(request.getUsername());

        String access  = jwtUtil.generateAccessToken(userDetails);
        String refresh = jwtUtil.generateRefreshToken(userDetails.getUsername());

        return new JwtResponse(access, refresh, jwtUtil.accessTokenExpiresInSeconds());
    }

    // Called when access token expired
    @PostMapping("/refresh")
    public ResponseEntity<JwtResponse> refresh(@RequestBody RefreshRequest req) {
        String refreshToken = req.getRefreshToken();
        if (refreshToken == null || refreshToken.isBlank()) {
            return ResponseEntity.badRequest().build();
        }

        if (!jwtUtil.validateRefreshToken(refreshToken)) {
            return ResponseEntity.status(401).build();
        }

        String username = jwtUtil.extractUsername(refreshToken);
        UserDetails userDetails = userDetailsService.loadUserByUsername(username);

        String newAccess = jwtUtil.generateAccessToken(userDetails);
        // you can choose to rotate refresh tokens; keeping same for simplicity
        return ResponseEntity.ok(new JwtResponse(newAccess, refreshToken, jwtUtil.accessTokenExpiresInSeconds()));
    }
}
