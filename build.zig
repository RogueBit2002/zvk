const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});


    const playground_exe = b.addExecutable(.{
        .name = "zvk-playground",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/playground.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{
                    .name = "zvk",
                    .module = b.createModule(.{
                        .root_source_file = b.path("src/zvk_m.zig"),
                        .target = target,
                        .optimize = optimize,
                        .link_libc = true
                    })
                }
            }
        })
    });

    b.installArtifact(playground_exe);

    const run_exe = b.addRunArtifact(playground_exe);

    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_exe.step);
}
