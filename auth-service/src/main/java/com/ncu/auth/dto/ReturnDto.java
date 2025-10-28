package com.ncu.auth.dto;

public class ReturnDto {
    private String status;
    private String email;

    public ReturnDto() {}

    public ReturnDto(String status, String email) {
        this.status = status;
        this.email = email;
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

    @Override
    public String toString() {
        return "ReturnDto{" +
                "status='" + status + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}
