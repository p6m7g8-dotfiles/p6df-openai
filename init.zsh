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

  p6df::modules::vscode::extension::install openai.chatgpt

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
# Function: str str = p6df::modules::openai::prompt::mod()
#
#  Returns:
#	str - str
#
#  Environment:	 OPENAI_BASE_URL OPENAI_ORG_ID OPENAI_PROJECT_ID P6_DFZ_PROFILE_OPENAI
#>
######################################################################
p6df::modules::openai::prompt::mod() {

  local str
  if ! p6_string_blank "$P6_DFZ_PROFILE_OPENAI"; then
    if ! p6_string_blank "$OPENAI_BASE_URL"; then
      str="openai:\t\t  $P6_DFZ_PROFILE_OPENAI:"
      str=$(p6_string_append "$str" "$OPENAI_BASE_URL" " ")
    fi
    if ! p6_string_blank "$OPENAI_ORG_ID"; then
      str=$(p6_string_append "$str" "$OPENAI_ORG_ID" "/")
    fi
    if ! p6_string_blank "$OPENAI_PROJECT_ID"; then
      str=$(p6_string_append "$str" "$OPENAI_PROJECT_ID" "/")
    fi
  fi

  p6_return_str "$str"
}

######################################################################
#<
#
# Function: p6df::modules::openai::profile::on(profile, [item=], [vault=])
#
#  Args:
#	profile -
#	OPTIONAL item - []
#	OPTIONAL vault - []
#
#  Environment:	 P6_DFZ_PROFILE_OPENAI
#>
######################################################################
p6df::modules::openai::profile::on() {
  local profile="$1"
  local code_env="$2"

  p6_env_export "P6_DFZ_PROFILE_OPENAI" "$profile"

  eval "$code_env"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::openai::profile::off()
#
#  Environment:	 OPENAI_API_KEY OPENAI_BASE_URL OPENAI_ORG_ID OPENAI_PROJECT_ID P6_DFZ_PROFILE_OPENAI
#>
######################################################################
p6df::modules::openai::profile::off() {

  p6_env_export_un P6_DFZ_PROFILE_OPENAI
  p6_env_export_un OPENAI_API_KEY
  p6_env_export_un OPENAI_BASE_URL
  p6_env_export_un OPENAI_ORG_ID
  p6_env_export_un OPENAI_PROJECT_ID

  p6_return_void
}
