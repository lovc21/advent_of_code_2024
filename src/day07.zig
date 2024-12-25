const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day07.txt");

pub fn main() !void {
    //print("{s}", .{data});
    const allocator = std.heap.page_allocator;

    //Hash map in zig (int and ArrayList)
    var map = Map(u128, List(u128)).init(allocator);
    defer {
        var it = map.iterator();
        while (it.next()) |entry| {
            entry.value_ptr.deinit();
        }
        map.deinit();
    }
    var lines = std.mem.split(u8, data, "\n");
    while (lines.next()) |line| {
        const trimmed_line = std.mem.trim(u8, line, " \t\r\n");
        print("Trimmed line: {s}\n", .{trimmed_line});
        if (trimmed_line.len == 0) continue;

        var parts = std.mem.split(u8, trimmed_line, ":");

        const key_text = std.mem.trim(u8, parts.first(), "\t\r\n");
        const key_number = try std.fmt.parseInt(u128, key_text, 10);

        var arr_list = List(u128).init(allocator);
        // ok zig :/
        const maybe_vals_text = parts.next() orelse continue;
        const vals_text = std.mem.trim(u8, maybe_vals_text, "\t\r\n");

        var tokens = std.mem.split(u8, vals_text, " ");

        while (tokens.next()) |token| {
            const trimmed_token = std.mem.trim(u8, token, "\t\r\n");
            if (trimmed_token.len == 0) continue;

            const num = try std.fmt.parseInt(u128, trimmed_token, 10);
            try arr_list.append(num);
        }
        try map.put(key_number, arr_list);
    }
    // print the map
    var it = map.iterator();
    while (it.next()) |entry| {
        const key = entry.key_ptr.*;
        const list = entry.value_ptr.*;

        // Print the key
        print("{d}: [", .{key});

        // Print each value in the array list
        var index: u8 = 0;
        for (list.items) |val| {
            if (index > 0) {
                print(", ", .{});
            }
            print("{d}", .{val});
            index += 1;
        }
        print("]\n", .{});
    }

    var it2 = map.iterator();
    var total_number: u128 = 0;
    while (it2.next()) |entry| {
        const key = entry.key_ptr.*;
        const list = entry.value_ptr.*;
        const list_len: u8 = @intCast(list.items.len);
        const number_of_spaces: u32 = list_len - 1;
        const max_val = @as(u32, 1) << @intCast(number_of_spaces);
        const BitPatternList = List(List(u128));
        var bit_arr = BitPatternList.init(allocator);
        defer {
            for (bit_arr.items) |*pattern| {
                pattern.deinit();
            }
            bit_arr.deinit();
        }

        for (0..max_val) |num| {
            var bit_pattern = std.ArrayList(u128).init(allocator);

            for (0..number_of_spaces) |bit_val| {
                const shift = number_of_spaces - 1 - bit_val;
                const bit = (@as(u128, @intCast(num)) >> @intCast(shift)) & 1;
                try bit_pattern.append(bit);
            }
            try bit_arr.append(bit_pattern);
        }
        // pritn the bits
        for (bit_arr.items) |bit_pattern| {
            for (bit_pattern.items) |bit| {
                print("{}", .{bit});
            }
            print("\n", .{});
        }
        //bits 000, 001, 010
        for (bit_arr.items) |value_bit| {
            var i: usize = 0;
            var local_sum: u128 = 0;
            // 6 33
            local_sum = list.items[0];
            // bit 000
            for (value_bit.items) |bit_number| {
                // 0 0 0
                if (bit_number == 0) {
                    local_sum += @as(u128, list.items[i + 1]);
                }
                if (bit_number == 1) {
                    local_sum *= @as(u128, list.items[i + 1]);
                }

                if (local_sum > key) {
                    break;
                }

                i += 1;
            }
            print("the sum is {d}, the key is {d}\n", .{ local_sum, key });
            if (key == local_sum) {
                total_number += key;
                break;
            }
            //print("{d}", .{power_number});
        }

        print("total number is :{d}\n", .{total_number});
    }
    print("total number is :{d}", .{total_number});
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
