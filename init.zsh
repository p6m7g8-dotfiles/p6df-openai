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
# Function: p6df::modules::openai::mcp::server::add(name, command, [args...])
#
#  Args:
#	name - MCP server name
#	command - command to run the server
#	OPTIONAL args - command arguments
#
#>
######################################################################
p6df::modules::openai::mcp::server::add() {
  local name="$1"
  local command="$2"
  shift 2

  codex mcp add "$name" -- "$command" "$@"

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
#  Environment:	 OPENAI_API_KEY OPENAI_BASE_URL OPENAI_ORG_ID OPENAI_PROJECT_ID P6_DFZ_PROFILE_OPENAI
#>
######################################################################
p6df::modules::openai::prompt::mod() {

  local str
  if p6_string_blank_NOT "$P6_DFZ_PROFILE_OPENAI"; then
    if p6_string_blank_NOT "$OPENAI_API_KEY"; then
      str="openai:\t\t  $P6_DFZ_PROFILE_OPENAI:"
      if p6_string_blank_NOT "$OPENAI_BASE_URL"; then
        str=$(p6_string_append "$str" "$OPENAI_BASE_URL" " ")
      fi
      if p6_string_blank_NOT "$OPENAI_ORG_ID"; then
        str=$(p6_string_append "$str" "$OPENAI_ORG_ID" "/")
      fi
      if p6_string_blank_NOT "$OPENAI_PROJECT_ID"; then
        str=$(p6_string_append "$str" "$OPENAI_PROJECT_ID" "/")
      fi
      str=$(p6_string_append "$str" "api" "/")
    fi
  fi

  p6_return_str "$str"
}

######################################################################
#<
#
# Function: p6df::modules::openai::profile::on(profile, code)
#
#  Args:
#	profile -
#	code - shell code block (export OPENAI_API_KEY=... OPENAI_ORG_ID=... OPENAI_PROJECT_ID=... OPENAI_BASE_URL=...)
#
#  Environment:	 OPENAI_API_KEY OPENAI_BASE_URL OPENAI_ORG_ID OPENAI_PROJECT_ID P6_DFZ_PROFILE_OPENAI
#>
######################################################################
p6df::modules::openai::profile::on() {
  local profile="$1"
  local code="$2"

  p6_run_code "$code"

  p6_env_export "P6_DFZ_PROFILE_OPENAI" "$profile"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::openai::profile::off(code)
#
#  Args:
#	code - shell code block previously passed to profile::on
#
#  Environment:	 OPENAI_API_KEY OPENAI_BASE_URL OPENAI_ORG_ID OPENAI_PROJECT_ID P6_DFZ_PROFILE_OPENAI
#>
######################################################################
p6df::modules::openai::profile::off() {
  local code="$1"

  p6_env_unset_from_code "$code"
  p6_env_export_un P6_DFZ_PROFILE_OPENAI

  p6_return_void
}
