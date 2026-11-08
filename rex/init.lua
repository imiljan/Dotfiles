-- Migrated from ~/.config/tmux/tmux.conf (prefix ctrl+a)

rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })
rex.bind("ctrl+a>r", "client.config.reload")

rex.bind("ctrl+a>shift+'", "pane.split", { direction = "down" })
rex.bind("ctrl+a>shift+5", "pane.split", { direction = "right" })
rex.bind("ctrl+a>s", "pane.split", { direction = "down" })
rex.bind("ctrl+a>v", "pane.split", { direction = "right" })
rex.bind("ctrl+a>c", "client.tab.new")

-- Repeatable (bind -r) bindings: ctrl+a then ctrl+r enters repeat mode; enter or escape leaves.
rex.mode("repeat", { exclusive = true })
rex.bind("ctrl+a>ctrl+r", "client.mode.enter", { name = "repeat" })
rex.bind("repeat/enter", "client.mode.exit")
rex.bind("repeat/escape", "client.mode.exit")

rex.bind("ctrl+a>left", "pane.resize", { amount = 10, direction = "left" })
rex.bind("repeat/left", "pane.resize", { amount = 10, direction = "left" })
rex.bind("ctrl+a>right", "pane.resize", { amount = 10, direction = "right" })
rex.bind("repeat/right", "pane.resize", { amount = 10, direction = "right" })
rex.bind("ctrl+a>up", "pane.resize", { amount = 10, direction = "up" })
rex.bind("repeat/up", "pane.resize", { amount = 10, direction = "up" })
rex.bind("ctrl+a>down", "pane.resize", { amount = 10, direction = "down" })
rex.bind("repeat/down", "pane.resize", { amount = 10, direction = "down" })

-- Sessionizer: Rex port of ~/.local/bin/tmux-sessionizer.
-- One session per project directory, named after the folder (dots become underscores),
-- created in that directory if missing, then switched to.
local HOME = os.getenv("HOME")

local function session_name(dir)
  local base = dir:gsub("/+$", ""):match("([^/]+)$") or dir
  return (base:gsub("%.", "_"))
end

rex.action{
  name  = "sessionize",
  title = "Open Project Session",
  category = "Sessions",
  args  = { dir = "string" },
  run   = function(ctx, args)
    local dir = args.dir:gsub("^~", HOME)
    local name = session_name(dir)

    local list, err = rex.call("session.list")
    if err ~= nil then error(err, 0) end
    local id
    for _, s in ipairs(list.sessions or {}) do
      if s.label == name then id = s.session_id break end
    end

    if id == nil then
      local created, cerr = rex.call("session.create", {
        label = name,
        initial_windows = { {
          layout = rex.layout.block{
            flavor  = "com.superlogical.terminal.shell",
            options = { cwd = dir },
          },
        } },
      })
      if cerr ~= nil then error(cerr, 0) end
      id = created.session_id
    end

    rex.client.queue("session.select", { session_id = id })
    return { session_id = id, label = name }
  end,
}

-- Picker: opens a floating fzf over the current window (like tmux's `neww tmux-sessionizer`).
-- The picker writes the chosen directory to a temp file, and this action waits for it and
-- switches the session itself. Switching from here works without Remote Control; switching
-- from the `rex` command line does not. An action may run for 30 seconds, so it waits 28;
-- if you take longer, it deletes the file and the picker falls back to the command line.
rex.action{
  name  = "sessionize_pick",
  title = "Pick Project Session",
  category = "Sessions",
  run   = function(ctx, args)
    local out = os.tmpname()
    local layer, err = rex.session.new_layer{
      bounds = { 0.1, 0.1, 0.8, 0.8 },
      focus  = true,
      layout = rex.layout.block{
        flavor  = "com.superlogical.terminal.shell",
        options = { command = { HOME .. "/.local/bin/rex-sessionizer", "--out", out } },
      },
    }
    if err ~= nil then os.remove(out) error(err, 0) end

    -- Wait until the picker writes something (a lone newline when cancelled).
    local r = rex.exec(
      { "/bin/sh", "-c", 'while [ ! -s "$1" ]; do sleep 0.1; done; cat "$1"', "sh", out },
      { timeout = 28 })
    os.remove(out)
    if layer ~= nil and layer.layer_id ~= nil then
      rex.session.close_layer{ layer_id = layer.layer_id } -- no-op if it already closed
    end

    local dir = r and r.ok and (r.stdout:gsub("%s+$", "")) or ""
    if dir == "" then return end
    local result, ierr = rex.invoke("sessionize", { dir = dir })
    if ierr ~= nil then error(ierr, 0) end
    return result
  end,
}

-- tmux.conf:97-102 (prefix f, D, E, T, F)
rex.bind("ctrl+a>f", "sessionize_pick")
rex.bind("ctrl+a>shift+d", "sessionize", { dir = "~/Dotfiles" })
rex.bind("ctrl+a>shift+e", "sessionize", { dir = "~/Code/expense-service" })
rex.bind("ctrl+a>shift+t", "sessionize", { dir = "~/Code/travel-import-service" })
rex.bind("ctrl+a>shift+f", "sessionize", { dir = "~/Code/direct-reimbursement-service" })
