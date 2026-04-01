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
# Function: p6df::modules::openai::mcp::server::add(name, command, ...)
#
#  Args:
#	name -
#	command -
#	... - 
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
# Function: words openai $OPENAI_API_KEY = p6df::modules::openai::profile::mod()
#
#  Returns:
#	words - openai $OPENAI_API_KEY
#
#  Environment:	 OPENAI_API_KEY
#>
######################################################################
p6df::modules::openai::profile::mod() {

  # shellcheck disable=SC2016
  p6_return_words 'openai' '$OPENAI_API_KEY'
}
