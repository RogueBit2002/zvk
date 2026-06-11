const std = @import("std");

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

pub const Error = error{
    OutOfHostMemory,
    OutOfDeviceMemory,
    InitializationFailed,
    DeviceLost,
    MemoryMapFailed,
    LayerNotPresent,
    ExtensionNotPresent,
    FeaturenotPresent,
    IncompatibleDriver,
    TooManyObjects,
    FormatNotSupported,
    FragmentedPool,
    Unkown,
    ValidationFailed,
    OutOfPoolMemory,
    InvalidExternalHandle,
    InvalidOpaqueCaptureAddress,
    Fragmentation,
    PipelineCompileRequired,
    NotPermitted,
};

pub const Instance = *opaque {};
pub const Device = *opaque {};

pub const StructureType = enum(i32) {
    application_info = 0,
    instance_create_info = 1,
};

pub const ApplicationInfo = extern struct{
    s_type: StructureType = .application_info,
    p_next: ?*const void = null,
    p_application_name: [*:0]const u8,
    application_version: u32,
    p_engine_name: [*:0]const u8,
    engine_version: u32,
    api_version: u32
};

pub const InstanceCreateInfo = extern struct{
    s_type: StructureType = .instance_create_info,
    p_next: ?*const void = null,
    flags: i32 = 0,
    p_application_info: *const ApplicationInfo,
    enabled_layer_count: u32,
    pp_enabled_layer_names: ?[*]const [*:0]const u8,
    enabled_extension_count: u32,
    pp_enabled_extension_names: ?[*]const [*:0]const u8
};


pub fn createInstance(vk: @This(), p_create_info: *const InstanceCreateInfo, p_allocator: ?*const anyopaque, p_instance: *Instance) Error!void {
    const ptr = @as(*State, @ptrCast(@alignCast(vk.ptr)));

    const raw = ptr.getInstanceProcAddr(null, "vkCreateInstance") orelse unreachable;
    const func = @as(*const fn(*const InstanceCreateInfo, ?*const anyopaque, *Instance) callconv(.c) i32, @ptrCast(raw));

    const r = func(p_create_info, p_allocator, p_instance);

    _ = r;
}

pub fn destroyInstance(vk: @This(), instance: ?Instance, p_allocator: ?*const anyopaque) void {
    const ptr = @as(*State, @ptrCast(@alignCast(vk.ptr)));

    const raw = ptr.getInstanceProcAddr(instance, "vkDestroyInstance") orelse unreachable;
    const func = @as(*const fn(?Instance, ?*const anyopaque) callconv(.c) void, @ptrCast(raw));

    func(instance, p_allocator);
}
