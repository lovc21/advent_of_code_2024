const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const math = std.math;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day02.txt");

pub fn main() !void {
    print("{s}", .{data});

    const allocator = std.heap.page_allocator;

    var a = std.ArrayList(i32).init(allocator);
    defer a.deinit();

    var lines = std.mem.split(u8, data, "\n");
    var sum: i32 = 0;
    var number_of_lines: i32 = 0;
    while (lines.next()) |line| {
        const trimmed_line = std.mem.trim(u8, line, " \t\r\n");
        //print("Trimmed line: {s}\n", .{trimmed_line});

        if (trimmed_line.len == 0) continue;

        var tokens_it = std.mem.tokenize(u8, trimmed_line, " \t");
        while (tokens_it.next()) |token| {
            const num = try std.fmt.parseInt(i32, token, 10);
            try a.append(num);
        }
        // print("{any}", .{a.items});
        var direction: i32 = 0;
        for (0..(a.items.len - 1)) |i| {
            const change: i32 = a.items[i + 1] - a.items[i];

            if (@abs(change) > 3) {
                sum += 1;
                print("{any}\n", .{a.items});
                break;
            }

            if (a.items[i] == a.items[i + 1]) {
                sum += 1;
                print("{any}\n", .{a.items});
                break;
            }

            const current_direction = math.sign(change);

            if (i == 0) {
                direction = current_direction;
            } else {
                if (current_direction != direction) {
                    sum += 1;
                    print("{any}\n", .{a.items});
                    break;
                }
            }
        }
        number_of_lines += 1;
        a.clearAndFree();
    }
    print("Sum : {d}\n", .{number_of_lines - sum});

    // part 2
    var lines_part2 = std.mem.split(u8, data, "\n");

    var sum_part2: i32 = 0;
    var number_of_lines_part2: i32 = 0;

    var a_part2 = std.ArrayList(i32).init(allocator);
    defer a_part2.deinit();

    while (lines_part2.next()) |line| {
        const trimmed_line = std.mem.trim(u8, line, " \t\r\n");

        if (trimmed_line.len == 0) continue;

        var tokens_it = std.mem.tokenize(u8, trimmed_line, " \t");
        while (tokens_it.next()) |token| {
            const num = try std.fmt.parseInt(i32, token, 10);
            try a_part2.append(num);
        }

        var violation_index: ?usize = null;
        var is_valid = true;

        var direction: i32 = 0;

        for (0..a_part2.items.len - 1) |i| {
            const change: i32 = a_part2.items[i + 1] - a_part2.items[i];
            const current_direction = math.sign(change);

            if (i == 0) {
                direction = current_direction;
            } else {
                if (current_direction != direction) {
                    violation_index = i;
                    is_valid = false;
                    break;
                }
            }

            if (@abs(change) > 3) {
                violation_index = i;
                is_valid = false;
                break;
            }

            if (a_part2.items[i] == a_part2.items[i + 1]) {
                violation_index = i;
                is_valid = false;
                break;
            }
        }

        if (is_valid) {
            sum_part2 += 1;
            print("{any}: Safe without removal\n", .{a_part2.items});
        } else {
            var can_be_safe = false;

            for (0..a_part2.items.len) |remove_idx| {
                var temp_array = try allocator.alloc(i32, a_part2.items.len - 1);
                defer allocator.free(temp_array);

                var temp_idx: usize = 0;
                for (0..a_part2.items.len) |i| {
                    if (i == remove_idx) continue;
                    temp_array[temp_idx] = a_part2.items[i];
                    temp_idx += 1;
                }

                if (tolerate(temp_array)) {
                    can_be_safe = true;
                    print("{any}: Safe by removing index {d} (value {d})\n", .{ temp_array, remove_idx, a_part2.items[remove_idx] });
                    break;
                }
            }

            if (can_be_safe) {
                sum_part2 += 1;
            }
        }

        number_of_lines_part2 += 1;
        a_part2.clearAndFree();
    }

    print("Sum of Safe Reports: {d}\n", .{sum_part2});
    print("Total Number of Reports: {d}\n", .{number_of_lines_part2});
}

fn tolerate(arr: []const i32) bool {
    if (arr.len < 2) {
        return true;
    }

    var direction: i32 = 0;
    for (0..arr.len - 1) |i| {
        const change: i32 = arr[i + 1] - arr[i];

        if (@abs(change) > 3) {
            return false;
        }

        if (arr[i] == arr[i + 1]) {
            return false;
        }

        const current_direction = math.sign(change);

        if (i == 0) {
            direction = current_direction;
        } else {
            if (current_direction != direction) {
                return false;
            }
        }
    }

    return true;
}

// Useful stdlib functions
const tokenizeAny = std.mem.tokenizeAny;
const tokenizeSeq = std.mem.tokenizeSequence;
const tokenizeSca = std.mem.tokenizeScalar;
const splitAny = std.mem.splitAny;
const splitSeq = std.mem.splitSequence;
const splitSca = std.mem.splitScalar;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.block;
const asc = std.sort.asc;
const desc = std.sort.desc;

