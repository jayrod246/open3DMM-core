const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const kauai_dep = b.dependency("kauai", .{
        .target = target,
        .optimize = optimize,
    });

    const brender_dep = b.dependency("brender", .{
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addStaticLibrary(.{
        .name = "open3dmm-core",
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    lib.disable_sanitize_c = true;

    lib.linkLibrary(brender_dep.artifact("brender"));
    lib.installLibraryHeaders(brender_dep.artifact("brender"));

    lib.linkLibrary(kauai_dep.artifact("kauai"));
    lib.installLibraryHeaders(kauai_dep.artifact("kauai"));

    inline for (&.{ "inc", "bren/inc" }) |include_dir| {
        lib.addIncludePath(.{ .path = include_dir });
        lib.installHeadersDirectory(include_dir, "core");
    }

    lib.addCSourceFiles(engine_sources, engine_cflags);
    b.installArtifact(lib);
}

const engine_cflags: []const []const u8 = &.{
    "-w",
    "-DLITTLE_ENDIAN",
    "-DWIN",
    "-DSTRICT",
    "-fms-extensions",
    "-fno-rtti",
    "-fno-exceptions",
};

const engine_sources: []const []const u8 = &.{
    "src/engine/actor.cpp",
    "src/engine/actredit.cpp",
    "src/engine/actrsave.cpp",
    "src/engine/actrsnd.cpp",
    "src/engine/bkgd.cpp",
    "src/engine/body.cpp",
    "src/engine/modl.cpp",
    "src/engine/movie.cpp",
    "src/engine/msnd.cpp",
    "src/engine/mtrl.cpp",
    "src/engine/scene.cpp",
    "src/engine/srec.cpp",
    "src/engine/tagl.cpp",
    "src/engine/tagman.cpp",
    "src/engine/tbox.cpp",
    "src/engine/tdf.cpp",
    "src/engine/tdt.cpp",
    "src/engine/tmpl.cpp",

    "bren/bwld.cpp",
    "bren/tmap.cpp",
    "bren/zbmp.cpp",
};
