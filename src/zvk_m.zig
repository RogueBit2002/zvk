const std = @import("std");

// META
const Vk = @This();

const GetInstanceProcAddrFn = *const fn(?*anyopaque, [*:0]const u8) callconv(.c) ?*const fn() callconv(.c) void;

const State = struct{
    allocator: std.mem.Allocator,
    getInstanceProcAddr: GetInstanceProcAddrFn,
};

ptr: *anyopaque, 

pub fn init(allocator: std.mem.Allocator, getInstanceProcAddr: GetInstanceProcAddrFn) !Vk {

    const ptr = try allocator.create(State);
    ptr.allocator = allocator;
    ptr.getInstanceProcAddr = getInstanceProcAddr;

    return @This(){ .ptr = @as(*anyopaque, @ptrCast(ptr)) };
}

pub fn deinit(vk: Vk) void {
    const ptr = @as(*State, @ptrCast(@alignCast(vk.ptr)));
    ptr.allocator.destroy(ptr);
}



pub const Status = enum(i32){
    success = 0,
    not_ready = 1,
    timeout = 2,
    event_set = 3,
    event_reset = 4,
    incomplete = 5,
    pipeline_compile_required = 1000297000,
    suboptimal_khr = 1000001003,
    thread_idle_khr = 1000268000,
    thread_done_khr = 1000268001,
    operation_deferred_khr = 1000268002,
    operation_not_deferred_khr = 1000268003,
    incomplete_shader_binary_ext = 1000482000,
    pipeline_binary_missing_khr = 1000483000,
    _
};

pub const Error = error{
    OutOfHostMemory,
    OutOfDeviceMemory,
    InitializationFailed,
    DeviceLost,
    MemoryMapFailed,
    LayerNotPresent,
    ExtensionNotPresent,
    FeatureNotPresent,
    IncompatibleDriver,
    TooManyObjects,
    FormatNotSupported,
    FragmentedPool,
    Unknown,
    ValidationFailed,
    OutOfPoolMemory,
    InvalidExternalHandle,
    InvalidOpaqueCaptureAddress,
    Fragmentation,
    NotPermitted,
    SurfaceLostKHR,
    NativeWindowInUseKHR,
    OutOfDateKHR,
    IncompatibleDisplayKHR,
    InvalidShaderNV,
    ImageUsageNotSupportedKHR,
    VideoPictureLayoutNotSupportedKHR,
    VideoProfileOperationNotSupportedKHR,
    VideoProfileFormatNotSupportedKHR,
    VideoProfileCodecNotSupportedKHR,
    VideoStdVersionNotSupportedKHR,
    InvalidDrmFormatModifierPlaneLayoutExt,
    PresentTimingQueueFullExt,
    FullScreenExclusiveModeLostExt,
    InvalidVideoStdParametersKHR,
    CompressionExhaustedExt,
    NotEnoughSpaceKHR,
};

fn parseResult(result: i32) Error!Status {
    if(result >= 0) {
        const s: Status = @enumFromInt(result);
        return switch(s) {
            _ => unreachable,
            else => s
        };
    }

    return switch(result) {
        -1=>Error.OutOfHostMemory,
        -2=>Error.OutOfDeviceMemory,
        -3=>Error.InitializationFailed,
        -4=>Error.DeviceLost,
        -5=>Error.MemoryMapFailed,
        -6=>Error.LayerNotPresent,
        -7=>Error.ExtensionNotPresent,
        -8=>Error.FeatureNotPresent,
        -9=>Error.IncompatibleDriver,
        -10=>Error.TooManyObjects,
        -11=>Error.FormatNotSupported,
        -12=>Error.FragmentedPool,
        -13=>Error.Unknown,
        -1000011001=>Error.ValidationFailed,
        -1000069000=>Error.OutOfPoolMemory,
        -1000072003=>Error.InvalidExternalHandle,
        -1000257000=>Error.InvalidOpaqueCaptureAddress,
        -1000161000=>Error.Fragmentation,
        -1000174001=>Error.NotPermitted,
        -1000000000=>Error.SurfaceLostKHR,
        -1000000001=>Error.NativeWindowInUseKHR,
        -1000001004=>Error.OutOfDateKHR,
        -1000003001=>Error.IncompatibleDisplayKHR,
        -1000012000=>Error.InvalidShaderNV,
        -1000023000=>Error.ImageUsageNotSupportedKHR,
        -1000023001=>Error.VideoPictureLayoutNotSupportedKHR,
        -1000023002=>Error.VideoProfileOperationNotSupportedKHR,
        -1000023003=>Error.VideoProfileFormatNotSupportedKHR,
        -1000023004=>Error.VideoProfileCodecNotSupportedKHR,
        -1000023005=>Error.VideoStdVersionNotSupportedKHR,
        -1000158000=>Error.InvalidDrmFormatModifierPlaneLayoutExt,
        -1000208000=>Error.PresentTimingQueueFullExt,
        -1000255000=>Error.FullScreenExclusiveModeLostExt,
        -1000299000=>Error.InvalidVideoStdParametersKHR,
        -1000338000=>Error.CompressionExhaustedExt,
        -1000483000=>Error.NotEnoughSpaceKHR,
        else => unreachable
    };
}

fn scopeError(comptime subset: type, err: anyerror) subset {
    const info = @typeInfo(subset).error_set.?;
    inline for (info) |e| {
        if(err == @field(anyerror, e.name))
            return @field(anyerror, e.name);
    }
    unreachable;
}


// HANDLES

pub const Instance = *opaque {};
pub const PhysicalDevice = *opaque {};
pub const Device = *opaque {};

// DEFINES

pub const SampleMask = u32;
pub const Bool32 = u32;
pub const Flags = u32;
pub const Flags64 = u64;
pub const DeviceSize = u64;
pub const DeviceAddress = u64;

pub const SampleCountFlags = Flags;
pub const max_physical_device_name_size: u32 = 256;
pub const uuid_size: u32 = 16;

// ENUMS

pub const StructureType = enum(i32) {
    application_info = 0,
    instance_create_info = 1,
    physical_device_properties_2 = 1000059001
};

pub const PhysicalDeviceType = enum(i32){
    other = 0,
    integrated_gpu = 1,
    discrete_gpu = 2,
    virtual_gpu = 3,
    cpu = 4
};

// STRUCTS

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

pub const PhysicalDeviceLimits = extern struct{
    max_image_dimension_1d: u32,
    max_image_dimension_2d: u32,
    max_image_dimension_3d: u32,
    max_image_dimension_cube: u32,
    max_image_array_layers: u32,
    max_texel_buffer_elementes: u32,
    max_uniform_buffer_range: u32,
    max_storage_buffer_range: u32,
    max_push_constants_size: u32,
    max_memory_allocation_count: u32,
    max_sampler_allocation_count: u32,
    buffer_image_granularity: DeviceSize,
    sparse_address_space_size: DeviceSize,
    max_bound_descriptor_sets: u32,
    max_per_stage_descriptor_samples: u32,
    max_per_stage_descriptor_uniform_buffers: u32,
    max_per_stage_descriptor_storage_buffers: u32,
    max_per_stage_descriptor_sampled_images: u32,
    max_per_stage_descriptor_storage_images: u32,
    max_per_stage_descriptor_input_attachments: u32,
    max_per_stage_resources: u32,
    max_descriptor_set_samples: u32,
    max_descriptor_set_uniform_buffers: u32,
    max_descriptor_set_uniform_buffers_dynamic: u32,
    max_descriptor_set_storage_buffers: u32,
    max_descriptor_set_storage_buffers_dynamic: u32,
    max_descriptor_set_sampled_images: u32,
    max_descriptor_set_storage_images: u32,
    max_descriptor_set_input_attachments: u32,
    max_vertex_input_attributes: u32,
    max_vertex_input_bindings: u32,
    max_vertex_input_attribute_offset: u32,
    max_vertex_input_binding_stride: u32,
    max_vertex_output_components: u32,
    max_tessellation_generation_level: u32,
    max_tessellation_patch_size: u32,
    max_tessellation_control_per_vertex_input_components: u32,
    max_tessellation_control_per_vertex_output_components: u32,
    max_tessellation_control_per_patch_output_components: u32,
    max_tessellation_control_total_output_components: u32,
    max_tessellation_evaluation_input_components: u32,
    max_tessellation_evaluation_output_components: u32,
    max_geometry_shader_invocations: u32,
    max_geometry_input_components: u32,
    max_geometry_output_components: u32,
    max_geometry_output_vertices: u32,
    max_geometry_total_output_components: u32,
    max_fragment_input_components: u32,
    max_fragment_output_attachments: u32,
    max_fragment_dual_src_attachments: u32,
    max_fragment_combined_output_resources: u32,
    max_compute_shared_memory_size: u32,
    max_compute_work_group_count: [3]u32,
    max_compute_work_group_invocations: u32,
    max_compute_work_group_size: [3]u32,
    sub_pixel_precision_bits: u32,
    sub_texel_precision_bits: u32,
    mipmap_precision_bits: u32,
    max_draw_indexed_index_value: u32,
    max_draw_indirect_count: u32,
    max_sampler_lod_bias: f32,
    max_sampler_anisotropy: f32,
    max_viewports: u32,
    max_viewport_dimensions: [2]u32,
    viewport_bounds_range: [2]f32,
    viewport_sub_pixel_bits: u32,
    min_memory_map_alignment: usize,
    min_texel_buffer_offset_alignment: DeviceSize,
    min_uniform_buffer_offset_alignment: DeviceSize,
    min_storage_buffer_offset_alignment: DeviceSize,
    min_texel_offset: i32,
    max_texel_offset: u32,
    min_texel_gather_offset: i32,
    max_texel_gather_offset: u32,
    min_interpolation_offset: f32,
    max_interpolation_offset: f32,
    sub_pixel_interpolation_offset_bits: u32,
    max_framebuffer_width: u32,
    max_framebuffer_height: u32,
    max_framebuffer_layers: u32,
    framebuffer_color_sample_counts: SampleCountFlags,
    framebuffer_depth_sample_counts: SampleCountFlags,
    framebuffer_stencil_sample_counts: SampleCountFlags,
    fraembuffer_n_attachments_sample_counts: SampleCountFlags,
    max_color_attachments: u32,
    sampled_image_color_sample_counts: SampleCountFlags,
    sampled_image_integer_sample_counts: SampleCountFlags,
    sampled_image_depth_sample_counts: SampleCountFlags,
    sampled_image_stencil_sample_counts: SampleCountFlags,
    sampled_image_sample_counts: SampleCountFlags,
    max_sample_mask_words: u32,
    timestamp_compute_and_graphics: Bool32,
    timestamp_period: f32,
    max_clip_distances: u32,
    max_cull_distances: u32,
    max_combined_clip_and_cull_distances: u32,
    discrete_queue_priorities: u32,
    point_size_range: [2]f32,
    line_width_range: [2]f32,
    point_size_granularity: f32,
    line_width_granularity: f32,
    strict_lines: Bool32,
    standard_sample_locations: Bool32,
    optimal_buffer_copy_offset_alignment: DeviceSize,
    optimal_buffer_copy_row_pitch_alignment: DeviceSize,
    non_coherent_atom_size: DeviceSize
};

pub const PhysicalDeviceSparseProperties = extern struct {
    residency_standard_2d_block_shape: Bool32,
    residency_standard_2d_multisample_block_shape: Bool32,
    residency_standard_3d_block_shape: Bool32,
    residency_aligned_mip_size: Bool32,
    residency_non_resident_strict: Bool32,
};

pub const PhysicalDeviceProperties = extern struct {
    api_version: u32,
    driver_version: u32,
    vendor_id: u32,
    device_id: u32,
    device_type: PhysicalDeviceType,
    device_name: [max_physical_device_name_size]u8,
    pipline_cache_uuid:  [uuid_size]u8,
    limits: PhysicalDeviceLimits,
    sparse_properties: PhysicalDeviceSparseProperties
    
};
pub const PhysicalDeviceProperties2 = extern struct {
    s_type: StructureType = .physical_device_properties_2,
    p_next: ?*void = null, // This needs to default to null, otherwise getPhysicalDeviceProperties2 will try to access it
    properties: PhysicalDeviceProperties
};

// COMMANDS
pub fn createInstance(vk: Vk, p_create_info: *const InstanceCreateInfo, p_allocator: ?*const anyopaque, p_instance: *Instance) error{ ExtensionNotPresent, IncompatibleDriver, InitializationFailed, LayerNotPresent, OutOfDeviceMemory, OutOfHostMemory, Unknown, ValidationFailed}!Status { 
    const err_set = comptime @typeInfo(@typeInfo(@TypeOf(createInstance)).@"fn".return_type.?).error_union.error_set;
    
    const state = @as(*State, @ptrCast(@alignCast(vk.ptr)));

    const raw = state.getInstanceProcAddr(null, "vkCreateInstance") orelse unreachable;
    const func = @as(*const fn(*const InstanceCreateInfo, ?*const anyopaque, *Instance) callconv(.c) i32, @ptrCast(raw));

    const result = func(p_create_info, p_allocator, p_instance);
    
    return parseResult(result) catch |err| scopeError(err_set, err);
}

pub fn destroyInstance(vk: Vk, instance: ?Instance, p_allocator: ?*const anyopaque) void {
    const ptr = @as(*State, @ptrCast(@alignCast(vk.ptr)));

    const raw = ptr.getInstanceProcAddr(instance, "vkDestroyInstance") orelse unreachable;
    const func = @as(*const fn(?Instance, ?*const anyopaque) callconv(.c) void, @ptrCast(raw));

    func(instance, p_allocator);
}
          
pub fn enumeratePhysicalDevices(vk: Vk, instance: Instance, p_physical_device_count: ?*u32, p_physical_devices: ?[*]PhysicalDevice) error{ OutOfHostMemory, OutOfDeviceMemory, InitializationFailed, Unknown, ValidationFailed }!Status {
    const err_set = comptime @typeInfo(@typeInfo(@TypeOf(enumeratePhysicalDevices)).@"fn".return_type.?).error_union.error_set;

    const state = @as(*State, @ptrCast(@alignCast(vk.ptr)));

    const raw = state.getInstanceProcAddr(instance, "vkEnumeratePhysicalDevices") orelse unreachable;
    const func = @as(*const fn(Instance, ?*u32, ?[*]PhysicalDevice) callconv(.c) i32, @ptrCast(raw));
    
    const result = func(instance, p_physical_device_count, p_physical_devices);

    return parseResult(result) catch |err| scopeError(err_set, err);
}

pub fn getPhysicalDeviceProperties(vk: Vk, instance: Instance, physical_device: PhysicalDevice, p_properties: *PhysicalDeviceProperties) void {
    
    const state = @as(*State, @ptrCast(@alignCast(vk.ptr)));
    const raw = state.getInstanceProcAddr(instance, "vkGetPhysicalDeviceProperties") orelse unreachable;
    const func = @as(*const fn(PhysicalDevice, *PhysicalDeviceProperties) callconv(.c) void, @ptrCast(raw));

    std.debug.print("{*}\n", .{ func });
    func(physical_device, p_properties);
}
pub fn getPhysicalDeviceProperties2(vk: Vk, instance: Instance, physical_device: PhysicalDevice, p_properties: *PhysicalDeviceProperties2) void {
    
    const state = @as(*State, @ptrCast(@alignCast(vk.ptr)));
    const raw = state.getInstanceProcAddr(instance, "vkGetPhysicalDeviceProperties2") orelse unreachable;
    const func = @as(*const fn(PhysicalDevice, *PhysicalDeviceProperties2) callconv(.c) void, @ptrCast(raw));

    std.debug.print("{*}\n", .{ func });
    func(physical_device, p_properties);
}
