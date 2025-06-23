package com.quiz.quiz.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Service
public class JwtUtil {

    @Value("${jwt.secret}")
    private String secret;

    @Value("${jwt.access-token-expiry-ms:900000}")
    private long accessTokenValidityMs;

    @Value("${jwt.refresh-token-expiry-ms:604800000}")
    private long refreshTokenValidityMs;

    @jakarta.annotation.PostConstruct
    public void validateSecret() {
        if (secret == null || secret.isBlank()) {
            throw new IllegalStateException("JWT secret must not be blank.");
        }
        if ("Y2hhbmdlVGhpc1NlY3JldEtleUJlZm9yZURlcGxveWluZ1RoaXNBcHBsaWNhdGlvbg==".equals(secret)) {
            System.err.println("================================================================================");
            System.err.println("CRITICAL SECURITY WARNING: The default placeholder JWT secret is active!");
            System.err.println("For production, configure a secure 256-bit key via the JWT_SECRET environment variable.");
            System.err.println("================================================================================");
        }
    }

    private SecretKey getSigningKey() {
        byte[] keyBytes = Decoders.BASE64.decode(secret);
        return Keys.hmacShaKeyFor(keyBytes);
    }

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
                .verifyWith(getSigningKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    public String extractTokenType(String token) {
        try {
            return extractClaim(token, claims -> claims.get("type", String.class));
        } catch (Exception ex) {
            return null;
        }
    }

    public boolean isTokenExpired(String token) {
        try {
            return extractExpiration(token).before(new Date());
        } catch (ExpiredJwtException ex) {
            return true;
        }
    }

    public String generateAccessToken(UserDetails userDetails) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("type", "access");
        return createToken(claims, userDetails.getUsername(), accessTokenValidityMs);
    }

    public String generateRefreshToken(String username) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("type", "refresh");
        return createToken(claims, username, refreshTokenValidityMs);
    }

    private String createToken(Map<String, Object> claims, String subject, long validityMs) {
        long now = System.currentTimeMillis();
        return Jwts.builder()
                .claims(claims)
                .subject(subject)
                .issuedAt(new Date(now))
                .expiration(new Date(now + validityMs))
                .signWith(getSigningKey())
                .compact();
    }

    public boolean validateAccessToken(String token, UserDetails userDetails) {
        try {
            final String username = extractUsername(token);
            final String type = extractTokenType(token);
            // Must not be a refresh token and username must match
            return !"refresh".equals(type) && username.equals(userDetails.getUsername()) && !isTokenExpired(token);
        } catch (Exception ex) {
            return false;
        }
    }

    public boolean validateRefreshToken(String refreshToken) {
        try {
            final String type = extractTokenType(refreshToken);
            return "refresh".equals(type) && !isTokenExpired(refreshToken) && extractUsername(refreshToken) != null;
        } catch (Exception ex) {
            return false;
        }
    }

    public long accessTokenExpiresInSeconds() {
        return accessTokenValidityMs / 1000;
    }
}
