package com.upb.bibliotheque.config;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Service;
import javax.crypto.SecretKey;
import java.util.Date;
import java.util.Map;

@Service
public class JwtService {
    private static final String SECRET = "MaCleSecreteTresLonguePourBibliothequeUPB2026SecureKey!!";
    private static final long EXPIRATION = 24 * 60 * 60 * 1000;

    private SecretKey getKey() { return Keys.hmacShaKeyFor(SECRET.getBytes()); }

    public String genererToken(Long userId, String identifiant, String role) {
        return Jwts.builder()
            .subject(identifiant)
            .claims(Map.of("userId", userId, "role", role))
            .issuedAt(new Date())
            .expiration(new Date(System.currentTimeMillis() + EXPIRATION))
            .signWith(getKey())
            .compact();
    }

    public String extraireIdentifiant(String token) { return extraireClaims(token).getSubject(); }
    public String extraireRole(String token) { return (String) extraireClaims(token).get("role"); }

    public boolean estValide(String token) {
        try { return !extraireClaims(token).getExpiration().before(new Date()); }
        catch (Exception e) { return false; }
    }

    private Claims extraireClaims(String token) {
        return Jwts.parser().verifyWith(getKey()).build().parseSignedClaims(token).getPayload();
    }
}
