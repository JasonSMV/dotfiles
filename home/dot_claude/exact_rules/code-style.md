# Code Style

## General

- Prefer clarity over cleverness
- Comments explain WHY, not what
- Small, focused functions with a single responsibility
- Explicit error handling — never swallow exceptions silently

## C# / .NET

- Follow Microsoft naming conventions (PascalCase types/methods, camelCase locals)
- Prefer `record` for immutable data, `class` for mutable domain objects
- Use `async`/`await` throughout — no `.Result` or `.Wait()`
- Nullable reference types enabled — no `!` suppressions without justification

## Angular / TypeScript

- `OnPush` change detection by default
- Signals preferred over `BehaviorSubject` for new code
- Standalone components over NgModule where possible
- `inject()` over constructor injection in new code
