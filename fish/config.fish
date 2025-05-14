# ~/.config/fish/config.fish
#
set -gx PATH $PATH /home/neovimuser/.local/bin
set -gx PATH $PATH /home/neovimuser/.local/pipx/venvs/thefuck/bin

if type -q thefuck
  thefuck --alias | source
end

