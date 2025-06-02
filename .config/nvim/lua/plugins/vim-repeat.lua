return {
  -- vim-repeat: Enable repeating plugin actions with "."
  {
    'tpope/vim-repeat',
    -- vim-repeat doesn't usually need any specific configuration.
    -- It's a library that other plugins can hook into.
    -- We can load it very lazily as it's only needed when a plugin tries to register a repeatable action.
    event = 'VeryLazy',
  },
}
