package com.company.hrms.shared.exception;

public class PayrollLockedException extends RuntimeException {
    public PayrollLockedException(String message) {
        super(message);
    }
}
