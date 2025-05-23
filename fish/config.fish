# Load functions from the functions directory
for file in ~/.config/fish/functions/*.fish
    source $file
end

# NOTE: Currently using wezterm instead of tmux
# if status is-interactive
#     # Commands to run in interactive sessions can go here
#     bind \cf tmux_sessionizer
#   # start_tmux
# end

if type -q uv
  uv generate-shell-completion fish | source
end
if type -q uvx
  uvx --generate-shell-completion fish | source
end
