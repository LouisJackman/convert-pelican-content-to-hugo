# Convert Pelican Content to Hugo

Convert Pelican content to Hugo. Only works with Markdown-based content, not
Jinja-templates.

It does the following transformations:

* YAML headers to TOML.
* Lowercase header names.
* GitHub-Flavoured Markdown-style code blocks from Pelican's style.

This is merely an assistance tool; such a migration is still mostly a manual
process.
