package com.quiz.quiz.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Service
public class JwtUtil {

    // NOTE: keep this long & random; consider loading from config
    private final String SECRET_KEY = "secret1key2is3not4secure6weaddstringupto123u2ifshnvjm13sf128bitslajfnlajdfsnlfndljfnsljgnsjldfnlsjdf";

    private static final long ACCESS_TOKEN_VALIDITY_MS  = 15 * 60 * 1000;      // 15 minutes
    private static final long REFRESH_TOKEN_VALIDITY_MS = 7L * 24 * 60 * 60 * 1000; // 7 days

    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    public <T> T extractClaim(String token, Function<Claims, T> resolver) {
        final Claims claims = extractAllClaims(token);
        return resolver.apply(claims);
    }

    private Claims extractAllClaims(String token) {
        return Jwts.parser()
                .setSigningKey(SECRET_KEY)
                .parseClaimsJws(token)
                .getBody();
    }

    public boolean isTokenExpired(String token) {
        try {
            return extractExpiration(token).before(new Date());
        } catch (ExpiredJwtException ex) {
            return true;
        }
    }

    // ---- Access token (short-lived) ----
    public String generateAccessToken(UserDetails userDetails) {
        Map<String, Object> claims = new HashMap<>();
        return createToken(claims, userDetails.getUsername(), ACCESS_TOKEN_VALIDITY_MS);
    }

    // ---- Refresh token (long-lived) ----
    public String generateRefreshToken(String username) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("type", "refresh");
        return createToken(claims, username, REFRESH_TOKEN_VALIDITY_MS);
    }

    private String createToken(Map<String, Object> claims, String subject, long validityMs) {
        long now = System.currentTimeMillis();
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(subject)
                .setIssuedAt(new Date(now))
                .setExpiration(new Date(now + validityMs))
                .signWith(SignatureAlgorithm.HS256, SECRET_KEY)
                .compact();
    }

    public boolean validateAccessToken(String token, UserDetails userDetails) {
        final String username = extractUsername(token);
        return username.equals(userDetails.getUsername()) && !isTokenExpired(token);
    }

    // refresh token just needs to be valid & not expired; subject must exist
    public boolean validateRefreshToken(String refreshToken) {
        return !isTokenExpired(refreshToken) && extractUsername(refreshToken) != null;
    }

    // Optional helpers for client UX
    public long accessTokenExpiresInSeconds() {
        return ACCESS_TOKEN_VALIDITY_MS / 1000;
    }
}
