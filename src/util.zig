const std = @import("std");

const DigitResult = struct {
    is_digit: bool,
    value: u8,
};

pub fn isDigit(c: u8) DigitResult {
    if (c >= '0' and c <= '9') {
        return .{ .is_digit = true, .value = c - '0' };
    } else {
        return .{ .is_digit = false, .value = 0 };
    }
}

