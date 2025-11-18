package com.ncu.auth.dto;

public class ReturnDto {
    private String status;
    private String email;
    private String token;
    private Long expiresIn;

    public ReturnDto() {}

    public ReturnDto(String status, String email) {
        this.status = status;
        this.email = email;
    }

    public ReturnDto(String status, String email, String token, Long expiresIn) {
        this.status = status;
        this.email = email;
        this.token = token;
        this.expiresIn = expiresIn;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Long getExpiresIn() {
        return expiresIn;
    }

    public void setExpiresIn(Long expiresIn) {
        this.expiresIn = expiresIn;
    }

    @Override
    public String toString() {
        return "ReturnDto{" +
                "status='" + status + '\'' +
                ", email='" + email + '\'' +
                ", token='" + (token != null ? "***" : null) + '\'' +
                ", expiresIn=" + expiresIn +
                '}';
    }
}
