# shellcheck shell=bash
######################################################################
#<
#
# Function: p6df::modules::openai::deps()
#
#>
######################################################################
p6df::modules::openai::deps() {
  ModuleDeps=(
    p6m7g8-dotfiles/p6common
  )
}

######################################################################
#<
#
# Function: p6df::modules::openai::vscodes()
#
#>
######################################################################
p6df::modules::openai::vscodes() {

  code --install-extension openai.chatgpt

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::openai::external::brews()
#
#>
######################################################################
p6df::modules::openai::external::brews() {

  p6df::modules::homebrew::cli::brew::install --cask codex

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::openai::home::symlink()
#
#  Environment:	 P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::modules::openai::home::symlink() {

  p6_file_symlink "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-openai/share/codex" .codex

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::openai::aliases::init()
#
#>
######################################################################
p6df::modules::openai::aliases::init() {

  p6_alias cx "codex"
  p6_alias cdxa "codex ask"
  p6_alias cdxc "codex chat"
  p6_alias cdxcfg "codex config"
  p6_alias cdxE "codex exec"
  p6_alias cdxF "codex fix"
  p6_alias cdxr "codex review"
  p6_alias cdxT "codex test"
  p6_alias cxr "codex resume"

  p6_return_void
}

######################################################################
#<
#
# Function: str str = p6df::modules::openai::prompt::line()
#
#  Returns:
#	str - str
#
#  Environment:	 OPENAI_BASE_URL P6_CODEX_SANDBOX
#>
######################################################################
p6df::modules::openai::prompt::line() {

  local str="openai:\t\t  $OPENAI_BASE_URL/$OPENAI_ORG_ID/$OPENAI_PROJECT_ID"
  str=$(p6_string_append "$str" "codex:\t\t  $P6_CODEX_SANDBOX/$P6_CODEX_MODEL/$P6_CODEX_APPROVAL" "$P6_NL")

  p6_return_str "$str"
}

# AGENTS.md
# ~/.codex/config.toml
# ~/.codex/AGENTS.md
