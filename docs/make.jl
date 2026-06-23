using Documenter
using DSArith

makedocs(
    sitename = "DSArith.jl",
    modules = [DSArith],
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", "false") == "true",
        collapselevel = 1,
        assets = ["assets/custom.css"],
    ),
    pages = [
        "Home" => "index.md",
        "Theory" => "theory.md",
        "Examples" => "examples.md",
        "API Reference" => "api.md",
        "References" => "references.md",
    ],
)
