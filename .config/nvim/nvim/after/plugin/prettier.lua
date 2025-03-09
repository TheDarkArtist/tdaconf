local prettier = require("prettier")

prettier.setup({
  bin = "prettier",                        -- Prefer 'prettier' for performance (ensure it's installed globally or in the project)
  cli_options = {
    arrow_parens = "always",               -- Maintain consistency in arrow function syntax
    bracket_spacing = true,                -- Improve readability
    bracket_same_line = false,             -- Enforce clarity by breaking after closing bracket
    embedded_language_formatting = "auto", -- Let Prettier handle embedded languages
    end_of_line = "lf",                    -- Unix standard line endings for cross-platform consistency
    html_whitespace_sensitivity = "css",   -- Respect CSS styles for whitespace handling
    jsx_bracket_same_line = false,         -- Keep JSX attributes on separate lines
    jsx_single_quote = false,              -- Default to double quotes for JSX attributes
    print_width = 80,                      -- Optimal readability for code in various environments
    prose_wrap = "preserve",               -- Preserve existing wrapping for better flexibility
    quote_props = "consistent",            -- Use consistent quoting for object keys
    semi = true,                           -- Require semicolons for explicit line termination
    single_attribute_per_line = true,      -- Improve readability by breaking attributes
    single_quote = false,                  -- Prefer single quotes for a cleaner look in JavaScript/TypeScript
    tab_width = 2,                         -- Standard tab width for common codebases
    trailing_comma = "all",                -- Better diffs and extensibility
    use_tabs = false,                      -- Spaces over tabs for widespread compatibility
    vue_indent_script_and_style = true,    -- Consistent indentation for Vue files
  },
  filetypes = {
    "svelte",
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
    "java",
    "toml",
    "lua",    -- Added support for Lua files if formatting is needed
    "python", -- Included Python for broader coverage
  },
  -- Optional: Add support for ignoring specific directories or files
  ignore_filetypes = { "go", "cpp" }, -- Prevent accidental reformatting of specific types
})

