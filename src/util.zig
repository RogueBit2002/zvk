
pub fn scopeError(comptime subset: type, err: anyerror) subset {
    const info = @typeInfo(subset).error_set.?;
    inline for (info) |e| {
        if(err == @field(anyerror, e.name))
            return @field(anyerror, e.name);
    }
    unreachable;
}
