-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/ts_ls.lua

---@type vim.lsp.Config
return {
  -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#configuration
  init_options = { -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#initializationoptions
    -- hostInfo = "",
    -- completionDisableFilterText = false,
    -- disableAutomaticTypingAcquisition = false,
    maxTsServerMemory = 4096, -- default undefined
    -- npmLocation = "",
    -- locale = "",
    -- plugins = {}, -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#plugins-option
    preferences = { -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#preferences-options
      -- DEFAULT PREFERENCES https://github.com/typescript-language-server/typescript-language-server/blob/b224b878652438bcdd639137a6b1d1a6630129e4/src/features/fileConfigurationManager.ts#L25

      -- autoImportFileExcludePatterns = [],
      -- autoImportSpecifierExcludeRegexes = [],
      -- disableSuggestions = false,
      -- quotePreference = "auto",
      -- includeCompletionsForModuleExports = true,
      -- includeCompletionsForImportStatements = true,
      -- includeCompletionsWithSnippetText = true,
      -- includeCompletionsWithInsertText = true,
      -- includeAutomaticOptionalChainCompletions = true,
      -- includeCompletionsWithClassMemberSnippets = true,
      -- includeCompletionsWithObjectLiteralMethodSnippets = true,
      -- useLabelDetailsInCompletionEntries = true,
      -- allowIncompleteCompletions = true,
      -- importModuleSpecifierPreference = "shortest",
      -- importModuleSpecifierEnding = "auto",
      -- allowTextChangesInNewFiles = true,
      -- lazyConfiguredProjectsFromExternalProject = false,
      -- maximumHoverLength = 500,
      -- organizeImportsIgnoreCase = "auto",
      -- organizeImportsCollation = "ordinal",
      -- organizeImportsCollationLocale = "en",
      -- organizeImportsNumericCollation = false,
      -- organizeImportsAccentCollation = true,
      -- organizeImportsCaseFirst = false,
      -- organizeImportsTypeOrder = "last",
      -- preferTypeOnlyAutoImports = false,
      -- providePrefixAndSuffixTextForRename = true,
      -- provideRefactorNotApplicableReason = true,
      -- allowRenameOfImportPath = true,
      -- includePackageJsonAutoImports = "auto",
      -- interactiveInlayHints = true,
      -- jsxAttributeCompletionStyle = "auto",
      -- displayPartsForJSDoc = true,
      -- excludeLibrarySymbolsInNavTo = true,
      -- generateReturnInDocTemplate = true,
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayVariableTypeHintsWhenTypeMatchesName = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
    },
    -- supportsMoveToFileCodeAction = true,
    -- tsserver = {}, -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#tsserver-options
  },
  settings = {
    -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#workspacedidchangeconfiguration
    typescript = {
      -- Formatting preferences
      format = {
        baseIndentSize = 2,
        convertTabsToSpaces = true,
        indentSize = 2,
        indentStyle = "None",
        insertSpaceAfterCommaDelimiter = true,
        insertSpaceAfterConstructor = false,
        insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
        insertSpaceAfterKeywordsInControlFlowStatements = true,
        insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
        insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
        insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
        insertSpaceAfterSemicolonInForStatements = true,
        insertSpaceAfterTypeAssertion = false,
        insertSpaceBeforeAndAfterBinaryOperators = true,
        insertSpaceBeforeFunctionParenthesis = false,
        -- newLineCharacter = '',
        placeOpenBraceOnNewLineForControlBlocks = false,
        placeOpenBraceOnNewLineForFunctions = false,
        semicolons = "ignore",
        tabSize = 2,
        trimTrailingWhitespace = true,
      },
      -- -- Inlay Hints preferences
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
      },
      -- Code Lens preferences
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
        showOnAllFunctions = true,
      },
    },
    javascript = {
      -- Formatting preferences
      format = {
        baseIndentSize = 2,
        convertTabsToSpaces = true,
        indentSize = 2,
        indentStyle = "None",
        insertSpaceAfterCommaDelimiter = true,
        insertSpaceAfterConstructor = false,
        insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
        insertSpaceAfterKeywordsInControlFlowStatements = true,
        insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
        insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
        insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
        insertSpaceAfterSemicolonInForStatements = true,
        insertSpaceAfterTypeAssertion = false,
        insertSpaceBeforeAndAfterBinaryOperators = true,
        insertSpaceBeforeFunctionParenthesis = false,
        -- newLineCharacter = '',
        placeOpenBraceOnNewLineForControlBlocks = false,
        placeOpenBraceOnNewLineForFunctions = false,
        semicolons = "ignore",
        tabSize = 2,
        trimTrailingWhitespace = true,
      },
      -- Inlay Hints preferences
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
      },
      -- Code Lens preferences
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
        showOnAllFunctions = true,
      },
    },
    completions = {
      completeFunctionCalls = true,
    },
    diagnostics = {
      ignoredCodes = {},
    },
    -- implicitProjectConfiguration = {
    --   checkJs = true,
    --   experimentalDecorators = "ESNext",
    --   module = true,
    --   strictFunctionTypes = true,
    --   strictNullChecks = true,
    --   target = "ES2020",
    -- },
  },
}
