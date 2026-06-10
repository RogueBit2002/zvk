const std = @import("std");
const Vk = @import("zvk");

pub fn main() !void {
    // TODO: Make this dynamic and platform agnostic
    var libvulkan = try std.DynLib.open("/nix/store/qmgk97l0kxh1nx898dsqapi3bqjwf5hh-vulkan-loader-1.4.328.0/lib/libvulkan.so.1");
    defer libvulkan.close();

    const vkGetInstanceProcAddr = libvulkan.lookup(
        *const fn(?*const anyopaque, [*:0]const u8) callconv(.c) ?*const fn() callconv(.c) void,
        "vkGetInstanceProcAddr") orelse unreachable;

    var vk = try Vk.init(std.heap.page_allocator, vkGetInstanceProcAddr);

    defer vk.deinit();
}
