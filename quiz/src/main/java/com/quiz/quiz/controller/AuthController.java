package com.quiz.quiz.controller;

import com.quiz.quiz.dto.JwtResponse;
import com.quiz.quiz.dto.LoginRequest;
import com.quiz.quiz.dto.SignUpRequest;
import com.quiz.quiz.dto.RefreshRequest;
import com.quiz.quiz.security.JwtUtil;
import com.quiz.quiz.security.RateLimiterService;
import com.quiz.quiz.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.*;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired private AuthenticationManager authManager;
    @Autowired private JwtUtil jwtUtil;
    @Autowired private UserDetailsService userDetailsService;
    @Autowired private UserService userService;
    @Autowired private RateLimiterService rateLimiterService;

    private String getClientIp(HttpServletRequest request) {
        String xf = request.getHeader("X-Forwarded-For");
        if (xf != null && !xf.isBlank()) {
            return xf.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }

    @PostMapping("/signup")
    public ResponseEntity<String> signup(@Valid @RequestBody SignUpRequest request, HttpServletRequest httpRequest) {
        String clientIp = getClientIp(httpRequest);
        // Rate limit: max 5 signups per minute per IP
        if (!rateLimiterService.tryAcquire("signup:" + clientIp, 5, 60_000)) {
            return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS)
                    .body("Too many registration requests. Please wait a minute and try again.");
        }

        try {
            if (userService.findByUsername(request.getUsername()).isPresent()) {
                return ResponseEntity.badRequest().body("Username already exists");
            }
            userService.register(request.getUsername(), request.getPassword());
            return ResponseEntity.ok("User registered successfully");
        } catch (DataIntegrityViolationException ex) {
            return ResponseEntity.badRequest().body("Username already exists");
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest request, HttpServletRequest httpRequest) {
        String clientIp = getClientIp(httpRequest);
        String ipRateLimitKey = "login:ip:" + clientIp;
        String userRateLimitKey = "login:user:" + request.getUsername().trim().toLowerCase();

        // Rate limit: max 20 login attempts per minute per IP, max 5 attempts per minute per account
        if (!rateLimiterService.tryAcquire(ipRateLimitKey, 20, 60_000) ||
            !rateLimiterService.tryAcquire(userRateLimitKey, 5, 60_000)) {
            return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS)
                    .body("Too many failed login attempts. Please wait a minute before retrying.");
        }

        authManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
        );

        // Reset user rate limit on successful authentication
        rateLimiterService.reset(userRateLimitKey);

        UserDetails userDetails = userDetailsService.loadUserByUsername(request.getUsername());

        String access  = jwtUtil.generateAccessToken(userDetails);
        String refresh = jwtUtil.generateRefreshToken(userDetails.getUsername());

        return ResponseEntity.ok(new JwtResponse(access, refresh, jwtUtil.accessTokenExpiresInSeconds()));
    }

    @PostMapping("/refresh")
    public ResponseEntity<JwtResponse> refresh(@RequestBody RefreshRequest req, HttpServletRequest httpRequest) {
        String clientIp = getClientIp(httpRequest);
        // Rate limit: max 30 refreshes per minute
        if (!rateLimiterService.tryAcquire("refresh:" + clientIp, 30, 60_000)) {
            return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS).build();
        }

        String refreshToken = req.getRefreshToken();
        if (refreshToken == null || refreshToken.isBlank()) {
            return ResponseEntity.badRequest().build();
        }

        if (!jwtUtil.validateRefreshToken(refreshToken)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        String username = jwtUtil.extractUsername(refreshToken);
        UserDetails userDetails = userDetailsService.loadUserByUsername(username);

        String newAccess = jwtUtil.generateAccessToken(userDetails);
        String newRefresh = jwtUtil.generateRefreshToken(username); // Rotate refresh token
        return ResponseEntity.ok(new JwtResponse(newAccess, newRefresh, jwtUtil.accessTokenExpiresInSeconds()));
    }
}
