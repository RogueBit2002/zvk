const std = @import("std");

pub const Error = error{
    HostOutOfMemory,
    Unkown,
};

const GetInstanceProcAddrFn = *const fn(?*anyopaque, [*:0]const u8) callconv(.c) ?*const fn() callconv(.c) void;

const State = struct{
    allocator: std.mem.Allocator,
    getInstanceProcAddr: GetInstanceProcAddrFn,
};

ptr: *anyopaque, 

pub fn init(allocator: std.mem.Allocator, getInstanceProcAddr: GetInstanceProcAddrFn) !@This() {

    const ptr = try allocator.create(State);
    ptr.allocator = allocator;
    ptr.getInstanceProcAddr = getInstanceProcAddr;

    return @This(){ .ptr = @as(*anyopaque, @ptrCast(ptr)) };
}

pub fn deinit(vk: @This()) void {
    const ptr = @as(*State, @ptrCast(@alignCast(vk.ptr)));
    ptr.allocator.destroy(ptr);
}
