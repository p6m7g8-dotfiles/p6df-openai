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
    p6m7g8-dotfiles/p6df-jupyter
  )
}

######################################################################
#<
#
# Function: p6df::modules::openai::init()
#
#>
######################################################################
p6df::modules::openai::init() {

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::openai::langs()
#
#>
######################################################################
p6df::modules::openai::langs() {

  pip install openai

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::openai::clones()
#
#  Environment:	 P6_DFZ_SRC_FOCUSED_DIR
#>
######################################################################
p6df::modules::openai::clones() {

  p6_github_login_clone "openai" "$P6_DFZ_SRC_FOCUSED_DIR"

  p6_return_void
}

# https://beta.openai.com/docs/
# https://github.com/openai/openai
# https://github.com/openai/openai-cookbook
# https://github.com/openai/triton
# https://github.com/openai/CLIP
# https://github.com/openai/DALL-E

