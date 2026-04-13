project = "Engauge Digitizer"
author = "Engauge Maintainers"
release = "fork"

extensions = ["myst_parser"]

source_suffix = {
	".rst": "restructuredtext",
	".md": "markdown",
}

templates_path = ["_templates"]
exclude_patterns = []

html_theme = "furo"
html_static_path = ["_static"]

# git-conventional-commits generates H5 sub-entries under H3 sections in
# CHANGELOG.md; suppress the resulting non-consecutive header level warning.
suppress_warnings = ["myst.header"]
