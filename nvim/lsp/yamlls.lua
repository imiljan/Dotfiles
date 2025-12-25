return {

  settings = {
    yaml = {
      -- Using the schemastore plugin for schemas.
      schemastore = { enable = false, url = "" },
      schemas = require("schemastore").yaml.schemas(),
    },
  },
}
