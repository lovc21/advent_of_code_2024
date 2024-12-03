const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day03.txt");

pub fn main() !void {
    print("{s}", .{data});

    const allocator = std.heap.page_allocator;

    var a = std.ArrayList([]const u8).init(allocator);
    defer a.deinit();

    const delimiters = "{}[]()!@%^&*+-=<>?,; \n";

    var i: usize = 0;
    while (i < data.len) {
        const c = data[i];

        if (std.mem.indexOfScalar(u8, delimiters, c) != null) {
            const slice = data[i .. i + 1];
            try a.append(slice);
            i += 1;
        } else {
            const slice = data[i .. i + 1];
            try a.append(slice);
            i += 1;
        }
    }
    print("doblejna tabela {s}\n", .{a.items});

    var number1 = std.ArrayList(u8).init(allocator);
    defer number1.deinit();
    var number2 = std.ArrayList(u8).init(allocator);
    defer number2.deinit();

    var isActive: bool = true;
    var doactive: bool = true;
    const mul = [_][]const u8{ "m", "u", "l", "(", ",", ")" };

    var j: usize = 0;
    var index: usize = 0;
    var result: i32 = 0;
    // a = { x, m, u, l, (, 2, ,, 4, ), %, &, m, u, l, [, 3, ,, 7, ], !, @, ^, d, o, _, n, o, t, _, m, u, l, (, 5, ,, 5, ), +, m, u, l, (n, (, m, u, l, (, 1, 1, ,, 8, ), m, u, l, (, 8, ,, 5, ), ),
    for (a.items) |token| {
        if (index + 4 <= a.items.len) {
            const slice = try std.mem.concat(allocator, u8, a.items[index .. index + 4]);
            if (std.mem.eql(u8, slice, "do()")) {
                doactive = true;
            }
        }

        if (index + 7 <= a.items.len) {
            const slice = try std.mem.concat(allocator, u8, a.items[index .. index + 7]);
            if (std.mem.eql(u8, slice, "don't()")) {
                doactive = false;
            }
        }

        if (doactive and std.mem.eql(u8, token, mul[j])) {
            print("{s}", .{token});
            //print("{d}", .{index});
            if (j == 3) {
                number2.clearAndFree();
                number1.clearAndFree();
                isActive = true;
                var counter: usize = index;

                while (true) {
                    const next_token_slice = a.items[counter + 1];
                    const next_token: u8 = next_token_slice[0];
                    if (std.ascii.isDigit(next_token) and isActive) {
                        try number1.append(next_token);
                    } else if (std.mem.eql(u8, next_token_slice, mul[4])) {
                        isActive = false;
                    } else if (std.ascii.isDigit(next_token) and !isActive) {
                        try number2.append(next_token);
                    } else if (std.mem.eql(u8, next_token_slice, mul[5])) {
                        result += try std.fmt.parseInt(i32, number1.items, 10) * try std.fmt.parseInt(i32, number2.items, 10);
                        print("{d}.", .{try std.fmt.parseInt(i32, number1.items, 10)});
                        print("{d} ", .{try std.fmt.parseInt(i32, number2.items, 10)});
                        //print(":{d}", .{index});
                        break;
                    } else {
                        break;
                    }
                    counter += 1;
                }
            }
            j += 1;
        } else {
            j = 0;
            if (std.mem.eql(u8, token, "m")) {
                j = 1;
            }
        }
        index += 1;

        //print("{d}", .{i});
        //print("'{s}'\n", .{token});
    }
    print("here we are {d}\n", .{result});
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

