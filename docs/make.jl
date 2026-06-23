using Documenter
using DSArith

makedocs(
    sitename = "DSArith.jl",
    modules = [DSArith],
    pages = [
        "Home" => "index.md",
        "API" => "api.md",
        "Theory" => "theory.md",
        "Examples" => "examples.md",
    ],
)
