const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const print = std.debug.print;

const util = @import("util.zig");

const data = @embedFile("data/day01.txt");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var a = std.ArrayList(i32).init(allocator);
    defer a.deinit();

    var b = std.ArrayList(i32).init(allocator);
    defer b.deinit();

    var lines = std.mem.split(u8, data, "\n");

    var i: usize = 0;
    while (lines.next()) |line| {
        const trimmed_line = std.mem.trim(u8, line, " \t\r\n");
        //print("Trimmed line: {s}\n", .{trimmed_line});

        if (trimmed_line.len == 0) continue;

        var tokens_it = std.mem.tokenize(u8, trimmed_line, " \t");
        if (tokens_it.next()) |first_token| {
            const first_num = try std.fmt.parseInt(i32, first_token, 10);
            try a.append(first_num);

            if (tokens_it.next()) |second_token| {
                const second_num = try std.fmt.parseInt(i32, second_token, 10);
                try b.append(second_num);
            } else {
                return error.InvalidData;
            }
        } else {
            return error.InvalidData;
        }

        i = i + 1;
    }
    sort(i32, a.items[0..], {}, comptime asc(i32));
    sort(i32, b.items[0..], {}, comptime asc(i32));

    print("Array a: {any}\n", .{a.items});
    print("Array b: {any}\n", .{b.items});

    var sum: i32 = 0;
    for (0..a.items.len) |j| {
        if (a.items[j] > b.items[j]) {
            sum += a.items[j] - b.items[j];
        } else {
            sum += b.items[j] - a.items[j];
        }
    }
    print("Sum of differences: {d}\n", .{sum});

    var l: usize = 0;
    var k: usize = 0;
    var global_sum: i64 = 0;
    // part 2
    while (l < a.items.len and k < b.items.len) {
        if (a.items[l] == b.items[k]) {
            const value = a.items[l];
            var count_a: i64 = 0;
            var count_b: i64 = 0;

            while (l < a.items.len and a.items[l] == value) {
                count_a += 1;
                l += 1;
            }

            while (k < b.items.len and b.items[k] == value) {
                count_b += 1;
                k += 1;
            }

            const count_product: i64 = count_a * count_b;
            const sum_contribution: i64 = count_product * value;
            global_sum += sum_contribution;
        } else if (a.items[l] < b.items[k]) {
            l += 1;
        } else {
            k += 1;
        }
    }

    print("Global sum: {d}\n", .{global_sum});
    //std.debug.print("{s}", .{data});
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

const assert = std.debug.assert;

const sort = std.sort.block;
const asc = std.sort.asc;
const desc = std.sort.desc;
