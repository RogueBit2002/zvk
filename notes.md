# Library design rules

Structs, enums and other types must exist in a "true to spec" manner. They need c interop

Enums must be renamed to a snake_case format, and should remove the vulkan type prefix

Structs must be renamed to a PascalCase format, and should remove the vulkan prefix.

Handles must be renamed to a PascalCase format, and should remove the vulkan prefix.

You may add extra types that "ziggify" these vulkan types, but they must support converions from and to the original types.

Command names must stay the same as the spec, but may remove the vk prefix is possible

Command parameters must follow the spec, but may add an additional first parameter for struct instance functions as long as the final syntax does not explicitely reference this instance.

