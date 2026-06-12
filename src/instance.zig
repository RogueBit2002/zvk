const std = @import("std");
const Vk = @import("zvk.zig");
const util = @import("util.zig");
const Dsp = @This();

vk: Vk,
instance: Vk.Instance,

pub fn destroyInstance(dsp: Dsp, instance: ?Vk.Instance, p_allocator: ?*const anyopaque) void {

    const raw = dsp.vk._handle.getInstanceProcAddr(instance, "vkDestroyInstance") orelse unreachable;
    const func = @as(*const fn(?Vk.Instance, ?*const anyopaque) callconv(.c) void, @ptrCast(raw));

    func(instance, p_allocator);
}
          
pub fn enumeratePhysicalDevices(dsp: Dsp, instance: Vk.Instance, p_physical_device_count: ?*u32, p_physical_devices: ?[*]Vk.PhysicalDevice) error{ OutOfHostMemory, OutOfDeviceMemory, InitializationFailed, Unknown, ValidationFailed }!Vk.Status {
    const err_set = comptime @typeInfo(@typeInfo(@TypeOf(enumeratePhysicalDevices)).@"fn".return_type.?).error_union.error_set;

    const raw = dsp.vk._handle.getInstanceProcAddr(instance, "vkEnumeratePhysicalDevices") orelse unreachable;
    const func = @as(*const fn(Vk.Instance, ?*u32, ?[*]Vk.PhysicalDevice) callconv(.c) i32, @ptrCast(raw));
    
    const result = func(instance, p_physical_device_count, p_physical_devices);

    return Vk.parseResult(result) catch |err| util.scopeError(err_set, err);
}

pub fn getPhysicalDeviceProperties(dsp: Dsp, physical_device: Vk.PhysicalDevice, p_properties: *Vk.PhysicalDeviceProperties) void {
    
    const raw = dsp.vk._handle.getInstanceProcAddr(dsp.instance, "vkGetPhysicalDeviceProperties") orelse unreachable;
    const func = @as(*const fn(Vk.PhysicalDevice, *Vk.PhysicalDeviceProperties) callconv(.c) void, @ptrCast(raw));

    std.debug.print("{*}\n", .{ func });
    func(physical_device, p_properties);
}

// out of spec
pub fn getPhysicalDeviceProperties2(dsp: Dsp, physical_device: Vk.PhysicalDevice, p_properties: *Vk.PhysicalDeviceProperties2) void {   
    const raw = dsp.vk._handle.getInstanceProcAddr(dsp.instance, "vkGetPhysicalDeviceProperties2") orelse unreachable;
    const func = @as(*const fn(Vk.PhysicalDevice, *Vk.PhysicalDeviceProperties2) callconv(.c) void, @ptrCast(raw));

    std.debug.print("{*}\n", .{ func });
    func(physical_device, p_properties);
}
