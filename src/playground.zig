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

    const app_info = Vk.ApplicationInfo{
        .p_application_name = "ZVK Playground",
        .application_version = makeApiVersion(0, 0, 0, 0),
        .engine_version = makeApiVersion(0, 0, 0, 0),
        .p_engine_name = "No engine",
        .api_version = makeApiVersion(0, 1, 3, 0)
    };
    const create_info = Vk.InstanceCreateInfo{
        .p_application_info = &app_info,
        .enabled_layer_count = 0,
        .pp_enabled_layer_names = null,
        .enabled_extension_count = 0,
        .pp_enabled_extension_names = null
    };
    var instance: Vk.Instance = undefined;

    try vk.createInstance(&create_info, null, &instance);
    defer vk.destroyInstance(instance, null);

    std.debug.print("Instance: {*}", .{ instance });
}



fn makeApiVersion(variant: u32, major: u32, minor: u32, patch: u32) u32 {
    return (variant << 29) | (major << 22) | (minor << 12) | patch;
}
